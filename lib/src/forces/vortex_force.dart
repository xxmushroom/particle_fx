import 'package:flutter/widgets.dart';

import '../core/particle.dart';
import 'force_falloff.dart';
import 'particle_force.dart';
import 'particle_force_target.dart';

/// Accelerates particles around a target point.
class VortexForce extends ParticleForce {
  /// Creates a vortex centered on [target].
  ///
  /// [strength] controls tangential acceleration around the target.
  ///
  /// [inwardStrength] optionally adds radial acceleration toward the target.
  ///
  /// [clockwise] controls rotational direction, while [deadZone] defines an
  /// unaffected region around the target.
  ///
  /// [falloff] controls distance-based strength using [referenceDistance] as
  /// its reference scale.
  const VortexForce({
    this.target = const ParticleForceTarget.alignment(
      Alignment.center,
    ),
    this.strength = 500,
    this.inwardStrength = 0,
    this.clockwise = true,
    this.deadZone = 4,
    this.falloff = ForceFalloff.constant,
    this.referenceDistance = 300,
  })  : assert(
  strength >= 0,
  'strength cannot be negative.',
  ),
        assert(
        inwardStrength >= 0,
        'inwardStrength cannot be negative.',
        ),
        assert(
        deadZone >= 0,
        'deadZone cannot be negative.',
        ),
        assert(
        referenceDistance > 0,
        'referenceDistance must be greater than zero.',
        );

  /// Point around which particles rotate.
  final ParticleForceTarget target;

  /// Tangential acceleration around [target].
  final double strength;

  /// Optional acceleration pulling particles toward [target].
  final double inwardStrength;

  /// Whether particles rotate clockwise around [target].
  final bool clockwise;

  /// Radius around [target] inside which the vortex is not applied.
  final double deadZone;

  /// Distance falloff mode used by this force.
  final ForceFalloff falloff;

  /// Distance used when calculating force falloff.
  final double referenceDistance;

  @override
  void apply(
      Particle particle,
      double deltaTime,
      Size canvasSize,
      ) {
    final Offset center =
    target.resolve(canvasSize);

    final Offset difference =
        particle.position - center;

    final double distance =
        difference.distance;

    if (distance <= deadZone) {
      return;
    }

    final Offset radialDirection =
        difference / distance;

    final Offset tangentDirection =
    clockwise
        ? Offset(
      -radialDirection.dy,
      radialDirection.dx,
    )
        : Offset(
      radialDirection.dy,
      -radialDirection.dx,
    );

    final double multiplier =
    calculateForceFalloff(
      falloff: falloff,
      distance: distance,
      referenceDistance:
      referenceDistance,
    );

    Offset acceleration =
        tangentDirection *
            strength *
            multiplier;

    if (inwardStrength > 0) {
      acceleration +=
          -radialDirection *
              inwardStrength *
              multiplier;
    }

    particle.velocity +=
        acceleration *
            deltaTime;
  }
}