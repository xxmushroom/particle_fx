import 'package:flutter/foundation.dart';

import '../config/particle_burst_config.dart';
import '../config/particle_stream_config.dart';
import '../debug/particle_fx_stats.dart';
import '../effects/particle_composite_callbacks.dart';
import '../effects/particle_composite_effect.dart';
import '../effects/particle_effect_layer.dart';
import '../textures/particle_texture.dart';
import '../textures/particle_texture_set.dart';

/// Controls particle bursts, streams, composite effects, and runtime state.
///
/// A [ParticleFxController] is passed to a `ParticleFx` widget and is used to
/// trigger particle emission without rebuilding the surrounding widget tree.
///
/// The controller can:
///
/// - emit one-shot bursts
/// - start continuous or timed streams
/// - pause and resume stream/composite scheduling
/// - stop active scheduling
/// - play layered composite effects
/// - expose live [ParticleFxStats]
///
/// The controller should be disposed when it is no longer needed.
class ParticleFxController
    extends ChangeNotifier {
  ParticleBurstConfig? _latestBurst;

  int _burstRevision = 0;

  ParticleStreamConfig?
  _activeStream;

  ParticleCompositeEffect?
  _activeCompositeEffect;

  ParticleTexture?
  _compositeTexture;

  ParticleTextureSet?
  _compositeTextureSet;

  ParticleCompositeCallbacks
  _compositeCallbacks =
  const ParticleCompositeCallbacks();

  int _compositeRevision = 0;

  bool _streamPaused = false;

  bool _isDisposed = false;

  final ValueNotifier<ParticleFxStats>
  _statsNotifier =
  ValueNotifier<ParticleFxStats>(
    const ParticleFxStats(),
  );

  /// Most recently submitted one-shot burst configuration.
  ///
  /// This value remains available after the burst has been requested so that
  /// the particle widget can react to [burstRevision] changes.
  ParticleBurstConfig?
  get latestBurst =>
      _latestBurst;

  /// Revision number incremented whenever [burst] is called.
  ///
  /// The particle widget uses this value to distinguish a new burst request
  /// from a previously handled one.
  int get burstRevision =>
      _burstRevision;

  /// Currently active normal particle stream.
  ///
  /// Returns null when no standalone stream is scheduled.
  ParticleStreamConfig?
  get activeStream =>
      _activeStream;

  /// Currently active composite effect.
  ///
  /// Returns null when no composite effect is being scheduled.
  ParticleCompositeEffect?
  get activeCompositeEffect =>
      _activeCompositeEffect;

  /// Texture currently bound to the active composite effect.
  ///
  /// This is null when no composite is active or when the composite uses
  /// [compositeTextureSet] instead.
  ParticleTexture?
  get compositeTexture =>
      _compositeTexture;

  /// Weighted texture set currently bound to the active composite effect.
  ///
  /// This is null when no composite is active or when the composite uses
  /// [compositeTexture] instead.
  ParticleTextureSet?
  get compositeTextureSet =>
      _compositeTextureSet;

  /// Lifecycle callbacks associated with the active composite effect.
  ParticleCompositeCallbacks
  get compositeCallbacks =>
      _compositeCallbacks;

  /// Revision number of the current composite scheduling state.
  ///
  /// The value changes whenever composite scheduling is replaced, cancelled,
  /// or completed. Runtime schedulers use it to ignore stale work.
  int get compositeRevision =>
      _compositeRevision;

  /// Whether a composite effect is currently active.
  bool get isCompositeActive =>
      _activeCompositeEffect != null;

  /// Whether the controller currently has stream-based emission scheduled.
  ///
  /// This returns true for either a standalone stream or an active composite
  /// containing at least one stream layer.
  bool get isStreaming =>
      _activeStream != null ||
          (_activeCompositeEffect
              ?.hasStreamLayers ??
              false);

  /// Whether active stream or composite scheduling is currently paused.
  bool get isStreamPaused =>
      _streamPaused;

  /// Whether this controller has already been disposed.
  bool get isDisposed =>
      _isDisposed;

  /// Latest published particle performance statistics.
  ParticleFxStats get stats =>
      _statsNotifier.value;

  /// Listenable that publishes updated particle performance statistics.
  ///
  /// This can be consumed with widgets such as
  /// `ValueListenableBuilder<ParticleFxStats>`.
  ValueListenable<ParticleFxStats>
  get statsListenable =>
      _statsNotifier;

  /// Emits a one-shot particle burst.
  void burst(
      ParticleBurstConfig config,
      ) {
    _ensureNotDisposed();

    _latestBurst = config;
    _burstRevision++;

    notifyListeners();
  }

  /// Starts one continuous particle stream.
  ///
  /// Starting a normal stream cancels any active composite scheduling.
  void start(
      ParticleStreamConfig config,
      ) {
    _ensureNotDisposed();

    _activeStream = config;

    _clearComposite();

    _compositeRevision++;

    _streamPaused = false;

    notifyListeners();
  }

  /// Plays a composite effect.
  ///
  /// Exactly one of [texture] or [textureSet] must be provided.
  ///
  /// Starting a composite replaces the currently active normal stream
  /// and any previously scheduled composite.
  void play(
      ParticleCompositeEffect effect, {
        ParticleTexture? texture,
        ParticleTextureSet? textureSet,
        ParticleCompositeCallbacks callbacks =
        const ParticleCompositeCallbacks(),
      }) {
    _ensureNotDisposed();

    final bool hasTexture =
        texture != null;

    final bool hasTextureSet =
        textureSet != null;

    if (hasTexture ==
        hasTextureSet) {
      throw ArgumentError(
        'Provide exactly one of texture or textureSet.',
      );
    }

    _activeStream = null;

    _activeCompositeEffect =
        effect;

    _compositeTexture =
        texture;

    _compositeTextureSet =
        textureSet;

    _compositeCallbacks =
        callbacks;

    _streamPaused = false;

    _compositeRevision++;

    notifyListeners();
  }

  /// Pauses new particle emission and composite scheduling.
  ///
  /// Existing particles continue moving and aging.
  void pause() {
    _ensureNotDisposed();

    if (_activeStream == null &&
        _activeCompositeEffect ==
            null) {
      return;
    }

    if (_streamPaused) {
      return;
    }

    _streamPaused = true;

    notifyListeners();
  }

  /// Resumes paused stream and composite scheduling.
  void resume() {
    _ensureNotDisposed();

    if ((_activeStream == null &&
        _activeCompositeEffect ==
            null) ||
        !_streamPaused) {
      return;
    }

    _streamPaused = false;

    notifyListeners();
  }

  /// Stops all scheduled emission.
  ///
  /// Existing particles remain alive until their normal lifetime ends.
  ///
  /// Any delayed composite layers that have not started yet are cancelled.
  void stop() {
    _ensureNotDisposed();

    if (_activeStream == null &&
        _activeCompositeEffect ==
            null) {
      return;
    }

    _activeStream = null;

    _clearComposite();

    _compositeRevision++;

    _streamPaused = false;

    notifyListeners();
  }

  /// Runtime hook invoked when a composite effect begins.
  ///
  /// The callback is ignored when [revision] does not match the active
  /// [compositeRevision], preventing stale composite runtimes from firing.
  ///
  /// Application code normally does not need to call this method directly.
  void notifyCompositeStarted(
      int revision,
      ) {
    if (_isDisposed ||
        revision !=
            _compositeRevision ||
        _activeCompositeEffect ==
            null) {
      return;
    }

    _compositeCallbacks
        .onStarted
        ?.call();
  }

  /// Runtime hook invoked when a composite layer begins.
  ///
  /// [index] identifies the layer inside the active composite and [layer]
  /// contains that layer's configuration.
  ///
  /// Stale revisions are ignored.
  ///
  /// Application code normally does not need to call this method directly.
  void notifyCompositeLayerStarted(
      int revision,
      int index,
      ParticleEffectLayer layer,
      ) {
    if (_isDisposed ||
        revision !=
            _compositeRevision ||
        _activeCompositeEffect ==
            null) {
      return;
    }

    _compositeCallbacks
        .onLayerStarted
        ?.call(
      index,
      layer,
    );
  }

  /// Runtime hook invoked when a finite composite layer completes.
  ///
  /// [index] identifies the completed layer inside the active composite.
  /// Stale revisions are ignored.
  ///
  /// Application code normally does not need to call this method directly.
  void notifyCompositeLayerCompleted(
      int revision,
      int index,
      ParticleEffectLayer layer,
      ) {
    if (_isDisposed ||
        revision !=
            _compositeRevision ||
        _activeCompositeEffect ==
            null) {
      return;
    }

    _compositeCallbacks
        .onLayerCompleted
        ?.call(
      index,
      layer,
    );
  }

  /// Runtime hook invoked when an entire finite composite has completed.
  ///
  /// Completion clears the active composite state, invalidates its revision,
  /// notifies listeners, and finally invokes the configured completion
  /// callback.
  ///
  /// Stale revisions are ignored.
  ///
  /// Application code normally does not need to call this method directly.
  void completeComposite(
      int revision,
      ) {
    if (_isDisposed ||
        revision !=
            _compositeRevision ||
        _activeCompositeEffect ==
            null) {
      return;
    }

    final ParticleCompositeCallback?
    onCompleted =
        _compositeCallbacks
            .onCompleted;

    _clearComposite();

    _compositeRevision++;

    _streamPaused = false;

    notifyListeners();

    onCompleted?.call();
  }

  /// Publishes a new particle performance statistics snapshot.
  ///
  /// This method is used by the particle widget to update [stats] and
  /// [statsListenable].
  ///
  /// Application code normally does not need to call this method directly.
  void updateStats(
      ParticleFxStats stats,
      ) {
    if (_isDisposed) {
      return;
    }

    _statsNotifier.value =
        stats;
  }

  void _clearComposite() {
    _activeCompositeEffect =
    null;

    _compositeTexture =
    null;

    _compositeTextureSet =
    null;

    _compositeCallbacks =
    const ParticleCompositeCallbacks();
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError(
        'ParticleFxController has already been disposed.',
      );
    }
  }

  /// Releases resources owned by this controller.
  ///
  /// After disposal, commands such as [burst], [start], and [play] must not
  /// be used.
  @override
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    _latestBurst = null;
    _activeStream = null;

    _clearComposite();

    _streamPaused = false;

    _statsNotifier.dispose();

    super.dispose();
  }
}