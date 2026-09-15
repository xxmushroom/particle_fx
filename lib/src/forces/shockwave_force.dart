import 'package:flutter/widgets.dart';

import '../core/particle_force_state.dart';
import 'particle_force.dart';
import 'particle_force_target.dart';

/// Pushes particles outward from a target point for a short period.
class ShockwaveForce extends ParticleForce {
  /// Creates a temporary radial shockwave.
  ///
  /// [strength] controls the maximum outward acceleration, [radius] controls
  /// the affected area, and [duration] controls how long the pulse remains
  /// active after a particle is created.
  ///
  /// Particles within [deadZone] are ignored.
  const ShockwaveForce({
    this.target = const ParticleForceTarget.alignment(
      Alignment.center,
    ),
    this.strength = 1400,
    this.radius = 300,
    this.duration = 0.4,
    this.deadZone = 2,
  })  : assert(
  strength >= 0,
  'strength cannot be negative.',
  ),
        assert(
        radius > 0,
        'radius must be greater than zero.',
        ),
        assert(
        duration > 0,
        'duration must be greater than zero.',
        ),
        assert(
        deadZone >= 0,
        'deadZone cannot be negative.',
        );

  /// Center of the shockwave.
  final ParticleForceTarget target;

  /// Maximum outward acceleration.
  final double strength;

  /// Maximum distance affected by the shockwave.
  final double radius;

  /// Duration of the pulse in seconds.
  final double duration;

  /// Radius around [target] inside which no shockwave force is applied.
  final double deadZone;

  @override
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      ) {
    if (particle.age > duration) {
      return;
    }

    final Offset center =
    target.resolve(canvasSize);

    final Offset difference =
        particle.position - center;

    final double distance =
        difference.distance;

    if (distance <= deadZone ||
        distance >= radius) {
      return;
    }

    final Offset direction =
        difference / distance;

    final double distanceFalloff =
        1 - (distance / radius);

    final double timeFalloff =
        1 -
            (particle.age /
                duration);

    final double acceleration =
        strength *
            distanceFalloff *
            timeFalloff;

    particle.velocity +=
        direction *
            acceleration *
            deltaTime;
  }
}