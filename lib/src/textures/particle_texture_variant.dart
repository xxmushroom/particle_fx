import 'particle_texture.dart';

/// A texture that can participate in weighted particle texture selection.
class ParticleTextureVariant {
  /// Creates a weighted texture variant.
  ///
  /// [weight] represents this texture's relative probability compared with
  /// other variants in the same texture set and must be greater than zero.
  const ParticleTextureVariant({
    required this.texture,
    this.weight = 1,
  }) : assert(
  weight > 0,
  'weight must be greater than zero.',
  );

  /// Texture rendered by particles that select this variant.
  final ParticleTexture texture;

  /// Relative probability of selecting this texture.
  ///
  /// For example, weights of `5`, `2`, and `1` correspond to
  /// probabilities of 62.5%, 25%, and 12.5%.
  final double weight;
}