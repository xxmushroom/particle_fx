import 'package:flutter/widgets.dart';

import '../core/particle.dart';
import 'particle_force.dart';
import 'particle_force_target.dart';

/// Pulls particles toward a target using spring physics.
///
/// Unlike [AttractorForce], this can overshoot and oscillate.
class SpringForce extends ParticleForce {
  /// Creates a spring force centered on [target].
  ///
  /// [stiffness] controls the restoring acceleration and [damping] reduces
  /// oscillation based on particle velocity.
  const SpringForce({
    this.target = const ParticleForceTarget.alignment(
      Alignment.center,
    ),
    this.stiffness = 5,
    this.damping = 2,
  })  : assert(
  stiffness >= 0,
  'stiffness cannot be negative.',
  ),
        assert(
        damping >= 0,
        'damping cannot be negative.',
        );

  /// Point toward which the spring pulls particles.
  final ParticleForceTarget target;

  /// Strength of the spring.
  final double stiffness;

  /// Reduces oscillation over time.
  final double damping;

  @override
  void apply(
      Particle particle,
      double deltaTime,
      Size canvasSize,
      ) {
    final Offset targetPosition =
    target.resolve(canvasSize);

    final Offset displacement =
        targetPosition -
            particle.position;

    final Offset springAcceleration =
        displacement * stiffness;

    final Offset dampingAcceleration =
        particle.velocity *
            -damping;

    particle.velocity +=
        (springAcceleration +
            dampingAcceleration) *
            deltaTime;
  }
}