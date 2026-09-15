import 'dart:math' as math;

import 'particle_texture.dart';
import 'particle_texture_variant.dart';

/// A collection of particle textures selected using relative weights.
class ParticleTextureSet {
  /// Creates a weighted particle texture set from [variants].
  ///
  /// At least one variant is required.
  ///
  /// Every variant weight must be finite and greater than zero. The supplied
  /// list is copied into an unmodifiable list.
  ParticleTextureSet({
    required List<ParticleTextureVariant> variants,
  })  : _variants =
  List<ParticleTextureVariant>.unmodifiable(
    variants,
  ),
        _totalWeight = _calculateTotalWeight(
          variants,
        ) {
    if (variants.isEmpty) {
      throw ArgumentError.value(
        variants,
        'variants',
        'At least one texture variant is required.',
      );
    }

    for (final ParticleTextureVariant variant
    in variants) {
      if (!variant.weight.isFinite ||
          variant.weight <= 0) {
        throw ArgumentError.value(
          variant.weight,
          'weight',
          'Texture weights must be finite and greater than zero.',
        );
      }
    }
  }

  /// Creates a texture set where every texture has equal probability.
  factory ParticleTextureSet.uniform(
      List<ParticleTexture> textures,
      ) {
    if (textures.isEmpty) {
      throw ArgumentError.value(
        textures,
        'textures',
        'At least one texture is required.',
      );
    }

    return ParticleTextureSet(
      variants: textures
          .map(
            (ParticleTexture texture) =>
            ParticleTextureVariant(
              texture: texture,
            ),
      )
          .toList(),
    );
  }

  /// Creates a texture set containing a single texture.
  factory ParticleTextureSet.single(
      ParticleTexture texture,
      ) {
    return ParticleTextureSet(
      variants: <ParticleTextureVariant>[
        ParticleTextureVariant(
          texture: texture,
        ),
      ],
    );
  }

  final List<ParticleTextureVariant>
  _variants;

  final double _totalWeight;

  /// Texture variants contained in this set.
  List<ParticleTextureVariant>
  get variants => _variants;

  /// Number of available texture variants.
  int get length => _variants.length;

  /// Whether the set contains exactly one texture.
  bool get isSingle =>
      _variants.length == 1;

  /// Selects a texture using the configured relative weights.
  ParticleTexture sample(
      math.Random random,
      ) {
    if (_variants.length == 1) {
      return _variants.first.texture;
    }

    final double target =
        random.nextDouble() *
            _totalWeight;

    double accumulatedWeight = 0;

    for (final ParticleTextureVariant variant
    in _variants) {
      accumulatedWeight +=
          variant.weight;

      if (target <
          accumulatedWeight) {
        return variant.texture;
      }
    }

    // Floating-point safety fallback.
    return _variants.last.texture;
  }

  static double _calculateTotalWeight(
      List<ParticleTextureVariant> variants,
      ) {
    double total = 0;

    for (final ParticleTextureVariant variant
    in variants) {
      total += variant.weight;
    }

    return total;
  }
}