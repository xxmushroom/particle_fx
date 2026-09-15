import 'dart:math' as math;

import '../appearance/particle_appearance.dart';
import '../core/particle_range.dart';
import '../emitters/point_emitter.dart';
import '../forces/particle_force.dart';
import 'particle_spawn_config.dart';

/// Configuration for a one-shot particle burst.
///
/// A burst emits [count] particles immediately using the configured emitter,
/// ranges, appearance, forces, and texture source.
class ParticleBurstConfig
    extends ParticleSpawnConfig {
  /// Creates a one-shot particle burst configuration.
  ///
  /// Exactly one of [texture] or [textureSet] must be provided.
  ///
  /// [count] determines how many particles are requested when the burst is
  /// triggered. It must be greater than zero.
  ParticleBurstConfig({
    super.texture,
    super.textureSet,
    this.count = 100,
    super.emitter =
    const PointEmitter(),
    super.speed =
    const ParticleRange(
      150,
      500,
    ),
    super.size =
    const ParticleRange(
      24,
      64,
    ),
    super.lifetime =
    const ParticleRange(
      1.5,
      3.5,
    ),
    super.rotation =
    const ParticleRange(
      0,
      math.pi * 2,
    ),
    super.angularVelocity =
    const ParticleRange(
      -4,
      4,
    ),
    super.appearance =
    const ParticleAppearance(),
    super.forces =
    const <ParticleForce>[],
  }) : assert(
  count > 0,
  'count must be greater than zero.',
  );

  /// Number of particles emitted by the burst.
  final int count;
}