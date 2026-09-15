import 'dart:ui';

import '../core/particle_force_state.dart';
import 'particle_force.dart';

/// Applies constant downward acceleration to particles.
class GravityForce extends ParticleForce {
  /// Creates a downward gravity force.
  ///
  /// [acceleration] is measured in logical pixels per second squared.
  const GravityForce({
    this.acceleration = 500,
  }) : assert(
  acceleration >= 0,
  'acceleration cannot be negative.',
  );

  /// Downward acceleration in logical pixels per second squared.
  final double acceleration;

  @override
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      ) {
    particle.velocity += Offset(
      0,
      acceleration * deltaTime,
    );
  }
}