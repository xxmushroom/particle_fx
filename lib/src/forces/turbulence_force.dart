import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/particle_force_state.dart';
import 'particle_force.dart';

/// Adds smooth, irregular motion to particles.
///
/// Useful for smoke, dust, sparks, magic effects, and fire-like movement.
class TurbulenceForce extends ParticleForce {
  /// Creates a procedural turbulence force.
  ///
  /// [strength] controls maximum acceleration, [scale] controls spatial
  /// frequency, and [speed] controls how quickly the field changes over time.
  const TurbulenceForce({
    this.strength = 120,
    this.scale = 0.02,
    this.speed = 2,
  })  : assert(
  strength >= 0,
  'strength cannot be negative.',
  ),
        assert(
        scale > 0,
        'scale must be greater than zero.',
        ),
        assert(
        speed >= 0,
        'speed cannot be negative.',
        );

  /// Maximum turbulence acceleration.
  final double strength;

  /// Spatial frequency of the turbulence field.
  final double scale;

  /// How quickly the turbulence changes over time.
  final double speed;

  @override
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      ) {
    final double x =
        particle.position.dx *
            scale;

    final double y =
        particle.position.dy *
            scale;

    final double time =
        particle.age * speed;

    final double forceX =
        math.sin(y + time) +
            math.cos(
              x * 0.7 -
                  time * 0.6,
            );

    final double forceY =
        math.cos(x - time) +
            math.sin(
              y * 0.9 +
                  time * 0.8,
            );

    particle.velocity += Offset(
      forceX *
          strength *
          0.5 *
          deltaTime,
      forceY *
          strength *
          0.5 *
          deltaTime,
    );
  }
}