import 'package:flutter/widgets.dart';

import '../core/particle_force_state.dart';
import 'particle_force.dart';

/// Applies upward acceleration to particles.
///
/// Useful for bubbles, smoke, embers, and floating particles.
class BuoyancyForce extends ParticleForce {
  /// Creates an upward buoyancy force.
  ///
  /// [acceleration] is measured in logical pixels per second squared.
  const BuoyancyForce({
    this.acceleration = 300,
  }) : assert(
  acceleration >= 0,
  'acceleration cannot be negative.',
  );

  /// Upward acceleration in logical pixels per second squared.
  final double acceleration;

  @override
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      ) {
    particle.velocity += Offset(
      0,
      -acceleration * deltaTime,
    );
  }
}