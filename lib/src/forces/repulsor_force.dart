import 'package:flutter/widgets.dart';

import '../core/particle.dart';
import 'force_falloff.dart';
import 'particle_force.dart';
import 'particle_force_target.dart';

/// Accelerates particles away from a target point.
class RepulsorForce extends ParticleForce {
  /// Creates a repulsive force centered on [target].
  ///
  /// [strength] controls outward acceleration.
  ///
  /// Particles within [deadZone] are not affected.
  ///
  /// [falloff] controls how the force changes with distance, using
  /// [referenceDistance] as the reference scale for distance-based modes.
  const RepulsorForce({
    this.target = const ParticleForceTarget.alignment(
      Alignment.center,
    ),
    this.strength = 500,
    this.deadZone = 4,
    this.falloff = ForceFalloff.constant,
    this.referenceDistance = 300,
  })  : assert(
  strength >= 0,
  'strength cannot be negative.',
  ),
        assert(
        deadZone >= 0,
        'deadZone cannot be negative.',
        ),
        assert(
        referenceDistance > 0,
        'referenceDistance must be greater than zero.',
        );

  /// Point away from which particles are accelerated.
  final ParticleForceTarget target;

  /// Maximum outward acceleration.
  final double strength;

  /// Radius around [target] inside which no repulsion is applied.
  final double deadZone;

  /// Distance falloff mode used by this force.
  final ForceFalloff falloff;

  /// Distance used when calculating falloff.
  final double referenceDistance;

  @override
  void apply(
      Particle particle,
      double deltaTime,
      Size canvasSize,
      ) {
    final Offset targetPosition =
    target.resolve(canvasSize);

    final Offset difference =
        particle.position -
            targetPosition;

    final double distance =
        difference.distance;

    if (distance <= deadZone) {
      return;
    }

    final Offset direction =
        difference / distance;

    final double multiplier =
    calculateForceFalloff(
      falloff: falloff,
      distance: distance,
      referenceDistance:
      referenceDistance,
    );

    particle.velocity +=
        direction *
            strength *
            multiplier *
            deltaTime;
  }
}