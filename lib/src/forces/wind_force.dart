import 'dart:ui';

import '../core/particle.dart';
import 'particle_force.dart';

/// Applies constant directional acceleration to particles.
class WindForce extends ParticleForce {
  /// Creates a constant directional wind force.
  ///
  /// [x] controls horizontal acceleration and [y] controls vertical
  /// acceleration.
  const WindForce({
    this.x = 0,
    this.y = 0,
  });

  /// Horizontal acceleration.
  final double x;

  /// Vertical acceleration.
  final double y;

  @override
  void apply(
      Particle particle,
      double deltaTime,
      Size canvasSize,
      ) {
    particle.velocity += Offset(
      x * deltaTime,
      y * deltaTime,
    );
  }
}