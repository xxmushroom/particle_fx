import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../debug/particle_fx_stats.dart';
import '../effects/particle_composite_effect.dart';
import '../effects/particle_effect_layer.dart';
import '../config/particle_burst_config.dart';
import '../controllers/particle_fx_controller.dart';
import '../core/particle_engine.dart';
import '../rendering/image_particle_renderer.dart';
import '../config/particle_stream_config.dart';
/// A particle effect canvas controlled by a [ParticleFxController].
///
/// The widget handles burst and continuous emission requests,
/// runs the particle simulation, and renders all active particles
/// onto a single Flutter canvas.
///
/// Example:
///
/// ```dart
/// ParticleFx(
///   controller: controller,
/// )
/// ```
class ParticleFx extends StatefulWidget {
  /// Creates a particle effect canvas controlled by [controller].
  ///
  /// [maxParticles] limits the number of simultaneously active particles and
  /// must be greater than zero. The default capacity is 5000 particles.
  const ParticleFx({
    super.key,
    required this.controller,
    this.maxParticles = 5000,
  }) : assert(
  maxParticles > 0,
  'maxParticles must be greater than zero.',
  );

  /// Controller used to trigger particle effects.
  final ParticleFxController controller;

  /// Maximum number of particles that may exist simultaneously.
  final int maxParticles;

  @override
  State<ParticleFx> createState() => _ParticleFxState();
}

class _ParticleFxState extends State<ParticleFx>
    with SingleTickerProviderStateMixin {
  late ParticleEngine _engine;
  late final Ticker _ticker;
  double _streamAccumulator = 0;
  double _streamElapsed = 0;
  double _streamLoopDelayElapsed = 0;

  bool _streamWaitingForLoop = false;

  ParticleStreamConfig? _previousStream;

  int _compositeRuntimeRevision = -1;

  bool _compositeStartedNotified =
  false;

  final List<_ParticleCompositeLayerRuntime>
  _compositeLayerRuntimes =
  <_ParticleCompositeLayerRuntime>[];
  static const Duration
  _statsPublishInterval =
  Duration(
    milliseconds: 250,
  );

  Duration? _statsWindowStart;
  int _statsFrameCount = 0;
  final ImageParticleRenderer _renderer =
  ImageParticleRenderer();

  final ValueNotifier<int> _repaint =
  ValueNotifier<int>(0);

  final List<ParticleBurstConfig> _pendingBursts =
  <ParticleBurstConfig>[];

  Duration? _previousFrameTime;

  Size _canvasSize = Size.zero;

  int _handledBurstRevision = 0;

  bool _pendingFlushScheduled = false;
  void _resetStreamRuntime(
      ParticleStreamConfig? stream,
      ) {
    _previousStream = stream;

    _streamAccumulator = 0;
    _streamElapsed = 0;
    _streamLoopDelayElapsed = 0;

    _streamWaitingForLoop = false;
  }
  bool _emitContinuousParticles(
      double deltaTime,
      ) {
    final ParticleStreamConfig? config =
        widget.controller.activeStream;

    if (!identical(
      config,
      _previousStream,
    )) {
      _resetStreamRuntime(
        config,
      );
    }

    if (config == null ||
        widget.controller.isStreamPaused ||
        _canvasSize.isEmpty) {
      return false;
    }

    double remainingDelta =
    deltaTime
        .clamp(
      0.0,
      0.1,
    )
        .toDouble();

    if (remainingDelta <= 0) {
      return false;
    }

    if (_streamWaitingForLoop) {
      final double loopDelaySeconds =
          config.loopDelay.inMicroseconds /
              Duration.microsecondsPerSecond;

      if (loopDelaySeconds > 0) {
        final double delayRemaining =
        math.max(
          0,
          loopDelaySeconds -
              _streamLoopDelayElapsed,
        );

        final double consumedDelay =
        math.min(
          remainingDelta,
          delayRemaining,
        );

        _streamLoopDelayElapsed +=
            consumedDelay;

        remainingDelta -=
            consumedDelay;

        if (_streamLoopDelayElapsed <
            loopDelaySeconds) {
          return false;
        }
      }

      _streamWaitingForLoop = false;
      _streamLoopDelayElapsed = 0;
      _streamElapsed = 0;
      _streamAccumulator = 0;

      if (remainingDelta <= 0) {
        return false;
      }
    }

    double emissionDelta =
        remainingDelta;

    bool reachedDuration = false;

    final Duration? duration =
        config.duration;

    if (duration != null) {
      final double durationSeconds =
          duration.inMicroseconds /
              Duration.microsecondsPerSecond;

      final double durationRemaining =
      math.max(
        0,
        durationSeconds -
            _streamElapsed,
      );

      emissionDelta =
          math.min(
            emissionDelta,
            durationRemaining,
          );

      _streamElapsed +=
          emissionDelta;

      reachedDuration =
          _streamElapsed >=
              durationSeconds;
    }

    bool emitted = false;

    if (emissionDelta > 0) {
      _streamAccumulator +=
          config.particlesPerSecond *
              emissionDelta;

      final int count =
      _streamAccumulator.floor();

      if (count > 0) {
        _streamAccumulator -=
            count;

        final int previousCount =
            _engine.particleCount;

        _engine.spawn(
          config,
          count,
          _canvasSize,
        );

        emitted =
            _engine.particleCount >
                previousCount;
      }
    }

    if (reachedDuration) {
      if (config.loop) {
        _streamAccumulator = 0;
        _streamElapsed = 0;

        if (config.loopDelay >
            Duration.zero) {
          _streamWaitingForLoop =
          true;

          _streamLoopDelayElapsed =
          0;
        }
      } else {
        widget.controller.stop();

        _resetStreamRuntime(
          null,
        );
      }
    }

    return emitted;
  }
  void _syncCompositeRuntime() {
    final int revision =
        widget.controller
            .compositeRevision;

    if (_compositeRuntimeRevision ==
        revision) {
      return;
    }

    _compositeRuntimeRevision =
        revision;

    _compositeStartedNotified =
    false;

    _compositeLayerRuntimes
        .clear();

    final ParticleCompositeEffect?
    effect =
        widget.controller
            .activeCompositeEffect;

    if (effect == null) {
      return;
    }

    final texture =
        widget.controller
            .compositeTexture;

    final textureSet =
        widget.controller
            .compositeTextureSet;

    for (
    int index = 0;
    index < effect.layers.length;
    index++
    ) {
      final ParticleEffectLayer layer =
      effect.layers[index];
      if (layer.isBurst) {
        _compositeLayerRuntimes.add(
          _ParticleCompositeLayerRuntime(
            index: index,
            layer: layer,
            burstConfig:
            layer.buildBurst(
              texture: texture,
              textureSet: textureSet,
            ),
          ),
        );
      } else {
        _compositeLayerRuntimes.add(
          _ParticleCompositeLayerRuntime(
            index: index,
            layer: layer,
            streamConfig:
            layer.buildStream(
              texture: texture,
              textureSet: textureSet,
            ),
          ),
        );
      }
    }
  }

  bool _emitCompositeParticles(
      double deltaTime,
      ) {
    _syncCompositeRuntime();

    if (widget.controller
        .isStreamPaused ||
        _canvasSize.isEmpty ||
        _compositeLayerRuntimes
            .isEmpty) {
      return false;
    }

    final int activeRevision =
        _compositeRuntimeRevision;

    if (!_compositeStartedNotified) {
      _compositeStartedNotified =
      true;

      widget.controller
          .notifyCompositeStarted(
        activeRevision,
      );

      if (widget.controller
          .compositeRevision !=
          activeRevision) {
        return false;
      }
    }

    bool emitted = false;

    for (final _ParticleCompositeLayerRuntime
    runtime
    in _compositeLayerRuntimes) {
      if (runtime.finished) {
        continue;
      }

      if (_updateCompositeLayer(
        runtime,
        deltaTime,
        activeRevision,
      )) {
        emitted = true;
      }

      if (widget.controller
          .compositeRevision !=
          activeRevision) {
        return emitted;
      }
    }

    final bool allFinished =
        _compositeLayerRuntimes
            .isNotEmpty &&
            _compositeLayerRuntimes.every(
                  (
                  _ParticleCompositeLayerRuntime
                  runtime,
                  ) =>
              runtime.finished,
            );

    if (allFinished) {
      widget.controller
          .completeComposite(
        activeRevision,
      );
    }

    return emitted;
  }

  bool _updateCompositeLayer(
      _ParticleCompositeLayerRuntime runtime,
      double deltaTime,
      int activeRevision,
      ) {
    double remainingDelta =
    deltaTime
        .clamp(
      0.0,
      0.1,
    )
        .toDouble();

    if (remainingDelta <= 0) {
      return false;
    }

    if (!runtime.started) {
      final double delaySeconds =
          runtime.layer.delay
              .inMicroseconds /
              Duration
                  .microsecondsPerSecond;

      if (delaySeconds > 0) {
        final double delayRemaining =
        math.max(
          0,
          delaySeconds -
              runtime.delayElapsed,
        );

        final double consumedDelay =
        math.min(
          remainingDelta,
          delayRemaining,
        );

        runtime.delayElapsed +=
            consumedDelay;

        remainingDelta -=
            consumedDelay;

        if (runtime.delayElapsed <
            delaySeconds) {
          return false;
        }
      }

      runtime.started = true;

      widget.controller
          .notifyCompositeLayerStarted(
        activeRevision,
        runtime.index,
        runtime.layer,
      );

      if (widget.controller
          .compositeRevision !=
          activeRevision) {
        return false;
      }

      if (runtime.layer.isBurst) {
        final ParticleBurstConfig config =
        runtime.burstConfig!;

        final int previousCount =
            _engine.particleCount;

        _engine.spawnBurst(
          config,
          _canvasSize,
        );

        runtime.finished = true;

        widget.controller
            .notifyCompositeLayerCompleted(
          activeRevision,
          runtime.index,
          runtime.layer,
        );

        return _engine.particleCount >
            previousCount;
      }
    }

    if (remainingDelta <= 0) {
      return false;
    }

    final ParticleStreamConfig config =
    runtime.streamConfig!;

    if (runtime.waitingForLoop) {
      final double loopDelaySeconds =
          config.loopDelay.inMicroseconds /
              Duration
                  .microsecondsPerSecond;

      if (loopDelaySeconds > 0) {
        final double delayRemaining =
        math.max(
          0,
          loopDelaySeconds -
              runtime.loopDelayElapsed,
        );

        final double consumedDelay =
        math.min(
          remainingDelta,
          delayRemaining,
        );

        runtime.loopDelayElapsed +=
            consumedDelay;

        remainingDelta -=
            consumedDelay;

        if (runtime.loopDelayElapsed <
            loopDelaySeconds) {
          return false;
        }
      }

      runtime.waitingForLoop =
      false;

      runtime.loopDelayElapsed = 0;
      runtime.streamElapsed = 0;
      runtime.accumulator = 0;

      if (remainingDelta <= 0) {
        return false;
      }
    }

    double emissionDelta =
        remainingDelta;

    bool reachedDuration = false;

    final Duration? duration =
        config.duration;

    if (duration != null) {
      final double durationSeconds =
          duration.inMicroseconds /
              Duration
                  .microsecondsPerSecond;

      final double durationRemaining =
      math.max(
        0,
        durationSeconds -
            runtime.streamElapsed,
      );

      emissionDelta =
          math.min(
            emissionDelta,
            durationRemaining,
          );

      runtime.streamElapsed +=
          emissionDelta;

      reachedDuration =
          runtime.streamElapsed >=
              durationSeconds;
    }

    bool emitted = false;

    if (emissionDelta > 0) {
      runtime.accumulator +=
          config.particlesPerSecond *
              emissionDelta;

      final int count =
      runtime.accumulator.floor();

      if (count > 0) {
        runtime.accumulator -=
            count;

        final int previousCount =
            _engine.particleCount;

        _engine.spawn(
          config,
          count,
          _canvasSize,
        );

        emitted =
            _engine.particleCount >
                previousCount;
      }
    }

    if (reachedDuration) {
      if (config.loop) {
        runtime.accumulator = 0;
        runtime.streamElapsed = 0;

        if (config.loopDelay >
            Duration.zero) {
          runtime.waitingForLoop =
          true;

          runtime.loopDelayElapsed =
          0;
        }
      } else {
        runtime.finished = true;

        widget.controller
            .notifyCompositeLayerCompleted(
          activeRevision,
          runtime.index,
          runtime.layer,
        );
      }
    }

    return emitted;
  }
  @override
  void initState() {
    super.initState();

    _engine = ParticleEngine(
      maxParticles: widget.maxParticles,
    );

    widget.controller.addListener(
      _handleControllerChanged,
    );

    _handledBurstRevision =
        widget.controller.burstRevision;

    final ParticleBurstConfig? existingBurst =
        widget.controller.latestBurst;

    if (existingBurst != null) {
      _pendingBursts.add(
        existingBurst,
      );
    }
    _ticker = createTicker(_handleTick);
    _ticker.start();
  }

  void _handleControllerChanged() {
    final int revision =
        widget.controller
            .burstRevision;

    if (revision ==
        _handledBurstRevision) {
      return;
    }

    _handledBurstRevision =
        revision;

    final ParticleBurstConfig?
    config =
        widget.controller
            .latestBurst;

    if (config == null) {
      return;
    }

    if (_canvasSize.isEmpty) {
      _pendingBursts.add(
        config,
      );

      return;
    }

    _spawnBurst(
      config,
    );
  }

  void _spawnBurst(
      ParticleBurstConfig config,
      ) {
    _engine.spawnBurst(
      config,
      _canvasSize,
    );

    _requestRepaint();
  }

  void _requestRepaint() {
    _repaint.value++;
  }

  void _schedulePendingBurstFlush() {
    if (_pendingFlushScheduled ||
        _pendingBursts.isEmpty ||
        _canvasSize.isEmpty) {
      return;
    }

    _pendingFlushScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        _pendingFlushScheduled = false;

        if (!mounted || _canvasSize.isEmpty) {
          return;
        }

        if (_pendingBursts.isEmpty) {
          return;
        }

        final List<ParticleBurstConfig> bursts =
        List<ParticleBurstConfig>.of(
          _pendingBursts,
        );

        _pendingBursts.clear();

        for (final ParticleBurstConfig config
        in bursts) {
          _engine.spawnBurst(
            config,
            _canvasSize,
          );
        }

        _requestRepaint();
      },
    );
  }
  void _updatePerformanceStats(
      Duration elapsed,
      ) {
    final Duration? windowStart =
        _statsWindowStart;

    if (windowStart == null) {
      _statsWindowStart =
          elapsed;

      _statsFrameCount = 0;
      return;
    }

    _statsFrameCount++;

    final Duration window =
        elapsed -
            windowStart;

    if (window <
        _statsPublishInterval) {
      return;
    }

    final double seconds =
        window.inMicroseconds /
            Duration
                .microsecondsPerSecond;

    if (seconds <= 0 ||
        _statsFrameCount <= 0) {
      _statsWindowStart =
          elapsed;

      _statsFrameCount = 0;
      return;
    }

    final double fps =
        _statsFrameCount /
            seconds;

    final double frameTimeMs =
        seconds *
            1000 /
            _statsFrameCount;

    widget.controller.updateStats(
      ParticleFxStats(
        activeParticles:
        _engine.particleCount,
        maxParticles:
        _engine.maxParticles,
        emittedParticles:
        _engine
            .emittedParticles,
        droppedParticles:
        _engine
            .droppedParticles,
        trailSamples:
        _engine
            .trailSampleCount,
        estimatedDrawCalls:
        _engine
            .estimatedDrawCalls,
        fps: fps,
        frameTimeMs:
        frameTimeMs,
      ),
    );

    _statsWindowStart =
        elapsed;

    _statsFrameCount = 0;
  }
  void _handleTick(
      Duration elapsed,
      ) {
    final Duration? previousFrameTime =
        _previousFrameTime;

    _previousFrameTime = elapsed;

    if (previousFrameTime == null) {
      return;
    }

    final double deltaTime =
        (elapsed - previousFrameTime)
            .inMicroseconds /
            Duration.microsecondsPerSecond;

    final bool emitted =
    _emitContinuousParticles(
      deltaTime,
    );

    final bool compositeEmitted =
    _emitCompositeParticles(
      deltaTime,
    );

    final bool updated =
    _engine.update(
      deltaTime,
      _canvasSize,
    );

    if (emitted ||
        compositeEmitted ||
        updated) {
      _requestRepaint();
    }
    _updatePerformanceStats(
      elapsed,
    );
  }

  @override
  void didUpdateWidget(
      covariant ParticleFx oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller !=
        widget.controller) {
      oldWidget.controller
          .removeListener(
        _handleControllerChanged,
      );

      widget.controller.addListener(
        _handleControllerChanged,
      );

      _resetStreamRuntime(
        null,
      );

      _compositeRuntimeRevision = -1;

      _compositeStartedNotified =
      false;

      _compositeLayerRuntimes
          .clear();

      _handledBurstRevision =
          widget.controller
              .burstRevision;

      final ParticleBurstConfig? burst =
          widget.controller
              .latestBurst;

      if (burst != null) {
        _pendingBursts.add(
          burst,
        );
      }

      _schedulePendingBurstFlush();

      _statsWindowStart = null;
      _statsFrameCount = 0;
    }

    if (oldWidget.maxParticles !=
        widget.maxParticles) {
      _engine = ParticleEngine(
        maxParticles: widget.maxParticles,
      );

      _statsWindowStart = null;
      _statsFrameCount = 0;

      _requestRepaint();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(
      _handleControllerChanged,
    );

    _ticker.dispose();
    _repaint.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
          BuildContext context,
          BoxConstraints constraints,
          ) {
        _canvasSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        _schedulePendingBurstFlush();

        return CustomPaint(
          painter: _ParticleFxPainter(
            engine: _engine,
            renderer: _renderer,
            repaint: _repaint,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}
class _ParticleCompositeLayerRuntime {
  _ParticleCompositeLayerRuntime({
    required this.index,
    required this.layer,
    this.burstConfig,
    this.streamConfig,
  }) : assert(
  (burstConfig != null) !=
      (streamConfig != null),
  'Exactly one runtime config is required.',
  );

  final int index;

  final ParticleEffectLayer layer;

  final ParticleBurstConfig?
  burstConfig;

  final ParticleStreamConfig?
  streamConfig;

  double delayElapsed = 0;

  double accumulator = 0;

  double streamElapsed = 0;

  double loopDelayElapsed = 0;

  bool started = false;

  bool waitingForLoop = false;

  bool finished = false;
}
class _ParticleFxPainter extends CustomPainter {
  _ParticleFxPainter({
    required this.engine,
    required this.renderer,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final ParticleEngine engine;

  final ImageParticleRenderer renderer;

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    renderer.render(
      canvas,
      size,
      engine.particles,
    );
  }

  @override
  bool shouldRepaint(
      covariant _ParticleFxPainter oldDelegate,
      ) {
    return oldDelegate.engine != engine ||
        oldDelegate.renderer != renderer;
  }
}