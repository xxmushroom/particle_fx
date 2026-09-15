import 'dart:math' as math;

import '../appearance/particle_appearance.dart';
import '../config/particle_burst_config.dart';
import '../config/particle_stream_config.dart';
import '../core/particle_range.dart';
import '../emitters/particle_emitter.dart';
import '../emitters/point_emitter.dart';
import '../forces/particle_force.dart';
import '../textures/particle_texture.dart';
import '../textures/particle_texture_set.dart';

/// Reusable particle behavior that can be emitted as either a burst or stream.
///
/// A preset describes how particles look and move, while the caller still
/// chooses the texture, emission count/rate, and stream timing.
class ParticlePreset {
  /// Creates a reusable particle preset.
  ///
  /// The preset stores emission geometry, randomized spawn ranges,
  /// appearance-over-lifetime behavior, and forces.
  ///
  /// A preset does not own a particle texture. Supply a [ParticleTexture] or
  /// [ParticleTextureSet] when calling [burst] or [stream].
  const ParticlePreset({
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
  });

  /// Controls where particles spawn and their initial direction.
  final ParticleEmitter emitter;

  /// Range of initial particle speeds.
  final ParticleRange speed;

  /// Range of initial particle sizes.
  final ParticleRange size;

  /// Range of particle lifetimes in seconds.
  final ParticleRange lifetime;

  /// Range of initial particle rotations in radians.
  final ParticleRange rotation;

  /// Range of angular velocities in radians per second.
  final ParticleRange angularVelocity;

  /// Visual behavior of particles over their lifetime.
  final ParticleAppearance appearance;

  /// Forces applied to particles during simulation.
  final List<ParticleForce> forces;

  /// Creates a one-shot burst using this preset.
  ParticleBurstConfig burst({
    ParticleTexture? texture,
    ParticleTextureSet? textureSet,
    int count = 100,
  }) {
    return ParticleBurstConfig(
      texture: texture,
      textureSet: textureSet,
      count: count,
      emitter: emitter,
      speed: speed,
      size: size,
      lifetime: lifetime,
      rotation: rotation,
      angularVelocity:
      angularVelocity,
      appearance: appearance,
      forces: forces,
    );
  }

  /// Creates a continuous stream using this preset.
  ParticleStreamConfig stream({
    ParticleTexture? texture,
    ParticleTextureSet? textureSet,
    double particlesPerSecond = 60,
    Duration? duration,
    bool loop = false,
    Duration loopDelay = Duration.zero,
  }) {
    return ParticleStreamConfig(
      texture: texture,
      textureSet: textureSet,
      particlesPerSecond:
      particlesPerSecond,
      duration: duration,
      loop: loop,
      loopDelay: loopDelay,
      emitter: emitter,
      speed: speed,
      size: size,
      lifetime: lifetime,
      rotation: rotation,
      angularVelocity:
      angularVelocity,
      appearance: appearance,
      forces: forces,
    );
  }

  /// Creates a modified copy of this preset.
  ParticlePreset copyWith({
    ParticleEmitter? emitter,
    ParticleRange? speed,
    ParticleRange? size,
    ParticleRange? lifetime,
    ParticleRange? rotation,
    ParticleRange? angularVelocity,
    ParticleAppearance? appearance,
    List<ParticleForce>? forces,
  }) {
    return ParticlePreset(
      emitter:
      emitter ?? this.emitter,
      speed:
      speed ?? this.speed,
      size:
      size ?? this.size,
      lifetime:
      lifetime ?? this.lifetime,
      rotation:
      rotation ?? this.rotation,
      angularVelocity:
      angularVelocity ??
          this.angularVelocity,
      appearance:
      appearance ??
          this.appearance,
      forces:
      forces ?? this.forces,
    );
  }
}