import 'package:flutter/widgets.dart';

import '../core/particle_force_state.dart';
import 'force_falloff.dart';
import 'particle_force.dart';
import 'particle_force_target.dart';

/// Accelerates particles toward a target point.
class AttractorForce extends ParticleForce {
  /// Creates an attractive force centered on [target].
  ///
  /// [strength] controls the acceleration toward the target.
  ///
  /// Particles within [deadZone] are not affected.
  ///
  /// [falloff] controls how force strength changes with distance, using
  /// [referenceDistance] as the reference scale for distance-based modes.
  const AttractorForce({
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

  /// Point toward which particles are accelerated.
  final ParticleForceTarget target;

  /// Maximum acceleration applied toward [target].
  final double strength;

  /// Radius around [target] inside which no attraction is applied.
  final double deadZone;

  /// Distance falloff mode used by this force.
  final ForceFalloff falloff;

  /// Distance used when calculating falloff.
  final double referenceDistance;

  @override
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      ) {
    final Offset targetPosition =
    target.resolve(canvasSize);

    final Offset difference =
        targetPosition - particle.position;

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