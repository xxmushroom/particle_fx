import 'dart:math' as math;

import '../appearance/particle_appearance.dart';
import '../core/particle_range.dart';
import '../emitters/point_emitter.dart';
import '../forces/particle_force.dart';
import 'particle_spawn_config.dart';

/// Configuration for continuously emitted particles.
///
/// A stream emits particles over time at [particlesPerSecond] until it is
/// stopped manually or its optional [duration] is reached.
class ParticleStreamConfig
    extends ParticleSpawnConfig {
  /// Creates a continuous particle stream configuration.
  ///
  /// Exactly one of [texture] or [textureSet] must be provided.
  ///
  /// [particlesPerSecond] determines the requested emission rate and must be
  /// greater than zero.
  ///
  /// When [duration] is null, the stream continues until it is stopped
  /// manually. When [loop] is true, [duration] is required and a new emission
  /// cycle begins after the optional [loopDelay].
  ParticleStreamConfig({
    super.texture,
    super.textureSet,
    this.particlesPerSecond = 60,
    this.duration,
    this.loop = false,
    this.loopDelay = Duration.zero,
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
  })  : assert(
  particlesPerSecond > 0,
  'particlesPerSecond must be greater than zero.',
  ),
        assert(
        duration == null ||
            (!duration.isNegative &&
                duration != Duration.zero),
        'duration must be greater than zero.',
        ),
        assert(
        !loop || duration != null,
        'A looping stream requires a duration.',
        ),
        assert(
        !loopDelay.isNegative,
        'loopDelay cannot be negative.',
        );

  /// Number of particles requested per second.
  final double particlesPerSecond;

  /// How long this stream emits particles.
  ///
  /// When null, the stream continues until it is manually stopped.
  final Duration? duration;

  /// Whether the stream starts another emission cycle after [duration].
  ///
  /// A duration must be provided when this is true.
  final bool loop;

  /// Delay between emission cycles when [loop] is true.
  final Duration loopDelay;
}