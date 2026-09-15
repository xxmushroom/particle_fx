import 'dart:math' as math;

import '../appearance/particle_appearance.dart';
import '../core/particle_range.dart';
import '../emitters/particle_emitter.dart';
import '../emitters/point_emitter.dart';
import '../forces/particle_force.dart';
import '../textures/particle_texture.dart';
import '../textures/particle_texture_set.dart';

/// Base configuration shared by burst and continuous particle emission.
///
/// This class defines the common spawn properties used by
/// [ParticleBurstConfig] and [ParticleStreamConfig], including texture
/// selection, emitter behavior, motion ranges, appearance, and forces.
abstract class ParticleSpawnConfig {
  /// Creates the common configuration used when particles are spawned.
  ///
  /// Exactly one of [texture] or [textureSet] must be supplied.
  ///
  /// The ranges for [speed], [size], [lifetime], [rotation], and
  /// [angularVelocity] are sampled independently for each newly created
  /// particle.
  ///
  /// [forces] are applied to particles during simulation after they have been
  /// emitted.
  ParticleSpawnConfig({
    this.texture,
    this.textureSet,
    this.emitter = const PointEmitter(),
    this.speed = const ParticleRange(
      150,
      500,
    ),
    this.size = const ParticleRange(
      24,
      64,
    ),
    this.lifetime = const ParticleRange(
      1.5,
      3.5,
    ),
    this.rotation = const ParticleRange(
      0,
      math.pi * 2,
    ),
    this.angularVelocity =
    const ParticleRange(
      -4,
      4,
    ),
    this.appearance =
    const ParticleAppearance(),
    this.forces =
    const <ParticleForce>[],
  })  : assert(
  texture != null ||
      textureSet != null,
  'Either texture or textureSet must be provided.',
  ),
        assert(
        texture == null ||
            textureSet == null,
        'Provide texture or textureSet, not both.',
        ),
        assert(
        speed.min >= 0,
        'speed values cannot be negative.',
        ),
        assert(
        size.min > 0,
        'size values must be greater than zero.',
        ),
        assert(
        lifetime.min > 0,
        'lifetime values must be greater than zero.',
        );

  /// Single texture used for every particle.
  ///
  /// Cannot be used together with [textureSet].
  final ParticleTexture? texture;

  /// Set of textures that can be selected per particle.
  ///
  /// Cannot be used together with [texture].
  final ParticleTextureSet? textureSet;

  /// Controls where particles spawn and their initial direction.
  final ParticleEmitter emitter;

  /// Initial particle speed.
  final ParticleRange speed;

  /// Initial particle size.
  final ParticleRange size;

  /// Particle lifetime in seconds.
  final ParticleRange lifetime;

  /// Initial rotation in radians.
  final ParticleRange rotation;

  /// Rotation velocity in radians per second.
  final ParticleRange angularVelocity;

  /// Visual behavior over the particle lifetime.
  final ParticleAppearance appearance;

  /// Forces applied during simulation.
  final List<ParticleForce> forces;

  /// All textures that may be used by this configuration.
  ///
  /// For a single-texture configuration this yields only [texture].
  /// For a weighted texture set it yields every texture referenced by
  /// [textureSet].
  Iterable<ParticleTexture>
  get availableTextures sync* {
    final ParticleTexture? singleTexture =
        texture;

    if (singleTexture != null) {
      yield singleTexture;
      return;
    }

    final ParticleTextureSet set =
    textureSet!;

    for (final variant in set.variants) {
      yield variant.texture;
    }
  }

  /// Selects the texture for a newly spawned particle.
  ///
  /// Returns [texture] when a single texture is configured. Otherwise,
  /// [random] is used to sample one texture from [textureSet].
  ParticleTexture sampleTexture(
      math.Random random,
      ) {
    final ParticleTexture? singleTexture =
        texture;

    if (singleTexture != null) {
      return singleTexture;
    }

    return textureSet!.sample(
      random,
    );
  }
}