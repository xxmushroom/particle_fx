import 'particle_effect_layer.dart';

/// A reusable effect composed of multiple particle layers.
///
/// Layers may start simultaneously or use individual delays to create
/// sequenced effects.
class ParticleCompositeEffect {
  /// Creates a composite effect from [layers].
  ///
  /// At least one layer is required.
  ///
  /// The supplied list is copied into an unmodifiable list so subsequent
  /// changes to the original list cannot alter this effect.
  ///
  /// Layer delays must not be negative.
  ParticleCompositeEffect({
    required List<ParticleEffectLayer>
    layers,
  }) : _layers =
  List<ParticleEffectLayer>
      .unmodifiable(
    layers,
  ) {
    if (layers.isEmpty) {
      throw ArgumentError.value(
        layers,
        'layers',
        'A composite effect requires at least one layer.',
      );
    }

    for (final ParticleEffectLayer layer
    in layers) {
      if (layer.delay.isNegative) {
        throw ArgumentError.value(
          layer.delay,
          'delay',
          'Layer delay cannot be negative.',
        );
      }
    }
  }

  final List<ParticleEffectLayer>
  _layers;

  /// Layers that make up this composite effect.
  ///
  /// The returned list is unmodifiable.
  List<ParticleEffectLayer>
  get layers =>
      _layers;

  /// Whether this composite contains at least one burst layer.
  bool get hasBurstLayers =>
      _layers.any(
            (ParticleEffectLayer layer) =>
        layer.isBurst,
      );

  /// Whether this composite contains at least one stream layer.
  bool get hasStreamLayers =>
      _layers.any(
            (ParticleEffectLayer layer) =>
        layer.isStream,
      );

  /// Number of layers in this composite effect.
  int get length =>
      _layers.length;
}