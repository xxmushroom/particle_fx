import 'particle_effect_layer.dart';

/// Callback invoked for a composite-level lifecycle event.
typedef ParticleCompositeCallback =
void Function();

/// Callback invoked for the lifecycle event of one composite layer.
///
/// [index] is the layer's position inside the composite and [layer] is the
/// corresponding layer configuration.
typedef ParticleCompositeLayerCallback =
void Function(
    int index,
    ParticleEffectLayer layer,
    );

/// Optional lifecycle callbacks for one composite effect playback.
///
/// Callbacks belong to a playback invocation rather than the reusable
/// composite effect definition.
class ParticleCompositeCallbacks {
  /// Creates lifecycle callbacks for a composite playback.
  const ParticleCompositeCallbacks({
    this.onStarted,
    this.onLayerStarted,
    this.onLayerCompleted,
    this.onCompleted,
  });

  /// Called when the composite runtime actually begins.
  final ParticleCompositeCallback?
  onStarted;

  /// Called when an individual layer begins.
  final ParticleCompositeLayerCallback?
  onLayerStarted;

  /// Called when an individual finite layer completes.
  final ParticleCompositeLayerCallback?
  onLayerCompleted;

  /// Called when every layer in the composite has completed.
  ///
  /// A composite containing an endlessly looping layer does not complete
  /// automatically.
  final ParticleCompositeCallback?
  onCompleted;
}