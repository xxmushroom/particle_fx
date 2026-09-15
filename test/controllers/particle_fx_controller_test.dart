import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ParticleTexture texture;
  late ParticleFxController controller;

  setUp(() async {
    final Uint8List bytes =
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );

    texture =
    await ParticleTexture.fromBytes(
      bytes,
    );

    controller =
        ParticleFxController();
  });

  tearDown(() {
    if (!controller.isDisposed) {
      controller.dispose();
    }

    if (!texture.isDisposed) {
      texture.dispose();
    }
  });

  ParticleBurstConfig buildBurst() {
    return ParticleBurstConfig(
      texture: texture,
      count: 10,
    );
  }

  ParticleStreamConfig buildStream() {
    return ParticleStreamConfig(
      texture: texture,
      particlesPerSecond: 30,
    );
  }

  ParticleCompositeEffect
  buildComposite() {
    return ParticleCompositeEffect(
      layers: const <
          ParticleEffectLayer>[
        ParticleEffectLayer.burst(
          preset: ParticlePreset(),
          count: 20,
        ),
        ParticleEffectLayer.stream(
          preset: ParticlePreset(),
          particlesPerSecond: 25,
          duration: Duration(
            seconds: 1,
          ),
          delay: Duration(
            milliseconds: 100,
          ),
        ),
      ],
    );
  }

  group(
    'ParticleFxController',
        () {
      test(
        'starts with empty state',
            () {
          expect(
            controller.latestBurst,
            isNull,
          );

          expect(
            controller.activeStream,
            isNull,
          );

          expect(
            controller.activeCompositeEffect,
            isNull,
          );

          expect(
            controller.isStreaming,
            isFalse,
          );

          expect(
            controller.isStreamPaused,
            isFalse,
          );

          expect(
            controller.isCompositeActive,
            isFalse,
          );

          expect(
            controller.isDisposed,
            isFalse,
          );
        },
      );

      test(
        'burst stores latest config and increments revision',
            () {
          final ParticleBurstConfig
          first =
          buildBurst();

          final ParticleBurstConfig
          second =
          buildBurst();

          expect(
            controller.burstRevision,
            0,
          );

          controller.burst(
            first,
          );

          expect(
            controller.latestBurst,
            same(first),
          );

          expect(
            controller.burstRevision,
            1,
          );

          controller.burst(
            second,
          );

          expect(
            controller.latestBurst,
            same(second),
          );

          expect(
            controller.burstRevision,
            2,
          );
        },
      );

      test(
        'start activates normal stream',
            () {
          final ParticleStreamConfig
          stream =
          buildStream();

          controller.start(
            stream,
          );

          expect(
            controller.activeStream,
            same(stream),
          );

          expect(
            controller.isStreaming,
            isTrue,
          );

          expect(
            controller.isStreamPaused,
            isFalse,
          );
        },
      );

      test(
        'stream can pause and resume',
            () {
          controller.start(
            buildStream(),
          );

          controller.pause();

          expect(
            controller.isStreamPaused,
            isTrue,
          );

          expect(
            controller.isStreaming,
            isTrue,
          );

          controller.resume();

          expect(
            controller.isStreamPaused,
            isFalse,
          );

          expect(
            controller.isStreaming,
            isTrue,
          );
        },
      );

      test(
        'stop clears active normal stream',
            () {
          controller.start(
            buildStream(),
          );

          controller.stop();

          expect(
            controller.activeStream,
            isNull,
          );

          expect(
            controller.isStreaming,
            isFalse,
          );

          expect(
            controller.isStreamPaused,
            isFalse,
          );
        },
      );

      test(
        'play requires exactly one texture source',
            () {
          final ParticleCompositeEffect
          effect =
          buildComposite();

          expect(
                () => controller.play(
              effect,
            ),
            throwsArgumentError,
          );

          final ParticleTextureSet
          textureSet =
          ParticleTextureSet.single(
            texture,
          );

          expect(
                () => controller.play(
              effect,
              texture: texture,
              textureSet: textureSet,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'play stores active composite and texture',
            () {
          final ParticleCompositeEffect
          effect =
          buildComposite();

          controller.play(
            effect,
            texture: texture,
          );

          expect(
            controller.activeCompositeEffect,
            same(effect),
          );

          expect(
            controller.compositeTexture,
            same(texture),
          );

          expect(
            controller.compositeTextureSet,
            isNull,
          );

          expect(
            controller.isCompositeActive,
            isTrue,
          );

          expect(
            controller.isStreaming,
            isTrue,
          );
        },
      );

      test(
        'starting normal stream cancels composite',
            () {
          controller.play(
            buildComposite(),
            texture: texture,
          );

          final int revisionBefore =
              controller
                  .compositeRevision;

          final ParticleStreamConfig
          stream =
          buildStream();

          controller.start(
            stream,
          );

          expect(
            controller.activeCompositeEffect,
            isNull,
          );

          expect(
            controller.compositeTexture,
            isNull,
          );

          expect(
            controller.compositeTextureSet,
            isNull,
          );

          expect(
            controller.activeStream,
            same(stream),
          );

          expect(
            controller.compositeRevision,
            greaterThan(
              revisionBefore,
            ),
          );
        },
      );

      test(
        'playing composite replaces normal stream',
            () {
          controller.start(
            buildStream(),
          );

          controller.play(
            buildComposite(),
            texture: texture,
          );

          expect(
            controller.activeStream,
            isNull,
          );

          expect(
            controller.isCompositeActive,
            isTrue,
          );
        },
      );

      test(
        'playing another composite invalidates old revision',
            () {
          final ParticleCompositeEffect
          first =
          buildComposite();

          final ParticleCompositeEffect
          second =
          buildComposite();

          controller.play(
            first,
            texture: texture,
          );

          final int firstRevision =
              controller
                  .compositeRevision;

          controller.play(
            second,
            texture: texture,
          );

          expect(
            controller.activeCompositeEffect,
            same(second),
          );

          expect(
            controller.compositeRevision,
            greaterThan(
              firstRevision,
            ),
          );

          controller.completeComposite(
            firstRevision,
          );

          expect(
            controller.activeCompositeEffect,
            same(second),
          );
        },
      );

      test(
        'composite can pause and resume',
            () {
          controller.play(
            buildComposite(),
            texture: texture,
          );

          controller.pause();

          expect(
            controller.isStreamPaused,
            isTrue,
          );

          expect(
            controller.isCompositeActive,
            isTrue,
          );

          controller.resume();

          expect(
            controller.isStreamPaused,
            isFalse,
          );

          expect(
            controller.isCompositeActive,
            isTrue,
          );
        },
      );

      test(
        'stop cancels active composite',
            () {
          controller.play(
            buildComposite(),
            texture: texture,
          );

          controller.stop();

          expect(
            controller.activeCompositeEffect,
            isNull,
          );

          expect(
            controller.compositeTexture,
            isNull,
          );

          expect(
            controller.compositeTextureSet,
            isNull,
          );

          expect(
            controller.isCompositeActive,
            isFalse,
          );

          expect(
            controller.isStreaming,
            isFalse,
          );
        },
      );

      test(
        'composite lifecycle callbacks are delivered',
            () {
          final List<String> events =
          <String>[];

          final ParticleCompositeEffect
          effect =
          buildComposite();

          controller.play(
            effect,
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onStarted: () {
                events.add(
                  'started',
                );
              },
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  'layer-$index-started',
                );
              },
              onLayerCompleted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  'layer-$index-completed',
                );
              },
              onCompleted: () {
                events.add(
                  'completed',
                );
              },
            ),
          );

          final int revision =
              controller
                  .compositeRevision;

          controller
              .notifyCompositeStarted(
            revision,
          );

          controller
              .notifyCompositeLayerStarted(
            revision,
            0,
            effect.layers[0],
          );

          controller
              .notifyCompositeLayerCompleted(
            revision,
            0,
            effect.layers[0],
          );

          controller.completeComposite(
            revision,
          );

          expect(
            events,
            <String>[
              'started',
              'layer-0-started',
              'layer-0-completed',
              'completed',
            ],
          );
        },
      );

      test(
        'stale lifecycle revision is ignored',
            () {
          int callbackCount = 0;

          controller.play(
            buildComposite(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onStarted: () {
                callbackCount++;
              },
              onCompleted: () {
                callbackCount++;
              },
            ),
          );

          final int oldRevision =
              controller
                  .compositeRevision;

          controller.play(
            buildComposite(),
            texture: texture,
          );

          controller
              .notifyCompositeStarted(
            oldRevision,
          );

          controller.completeComposite(
            oldRevision,
          );

          expect(
            callbackCount,
            0,
          );

          expect(
            controller.isCompositeActive,
            isTrue,
          );
        },
      );

      test(
        'completeComposite clears active composite',
            () {
          bool completed = false;

          controller.play(
            buildComposite(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onCompleted: () {
                completed = true;
              },
            ),
          );

          final int revision =
              controller
                  .compositeRevision;

          controller.completeComposite(
            revision,
          );

          expect(
            completed,
            isTrue,
          );

          expect(
            controller.activeCompositeEffect,
            isNull,
          );

          expect(
            controller.compositeTexture,
            isNull,
          );

          expect(
            controller.compositeTextureSet,
            isNull,
          );

          expect(
            controller.isCompositeActive,
            isFalse,
          );
        },
      );

      test(
        'stats can be updated independently',
            () {
          const ParticleFxStats stats =
          ParticleFxStats(
            activeParticles: 120,
            maxParticles: 5000,
            emittedParticles: 800,
            droppedParticles: 3,
            trailSamples: 400,
            estimatedDrawCalls: 520,
            fps: 59.8,
            frameTimeMs: 16.7,
          );

          controller.updateStats(
            stats,
          );

          expect(
            controller.stats,
            same(stats),
          );
        },
      );

      test(
        'dispose prevents further commands',
            () {
          controller.dispose();

          expect(
            controller.isDisposed,
            isTrue,
          );

          expect(
                () => controller.burst(
              buildBurst(),
            ),
            throwsStateError,
          );

          expect(
                () => controller.start(
              buildStream(),
            ),
            throwsStateError,
          );
        },
      );
    },
  );
}