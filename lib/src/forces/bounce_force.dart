import 'package:flutter/widgets.dart';

import '../core/particle.dart';
import 'particle_force.dart';

/// Makes particles bounce off the particle canvas boundaries.
class BounceForce extends ParticleForce {
  /// Creates a boundary collision force.
  ///
  /// [restitution] controls how much velocity is preserved after collision
  /// and must be between `0.0` and `1.0`.
  ///
  /// [padding] moves the effective collision boundary inward from the canvas
  /// edges.
  const BounceForce({
    this.restitution = 0.8,
    this.padding = 0,
  })  : assert(
  restitution >= 0 &&
      restitution <= 1,
  'restitution must be between 0 and 1.',
  ),
        assert(
        padding >= 0,
        'padding cannot be negative.',
        );

  /// Amount of velocity preserved after a collision.
  ///
  /// `1.0` creates a perfectly elastic bounce.
  /// `0.0` removes all velocity on the collision axis.
  final double restitution;

  /// Additional distance from the canvas edge.
  final double padding;

  @override
  void apply(
      Particle particle,
      double deltaTime,
      Size canvasSize,
      ) {
    final double radius =
        particle.size / 2;

    final double left =
        padding + radius;

    final double right =
        canvasSize.width -
            padding -
            radius;

    final double top =
        padding + radius;

    final double bottom =
        canvasSize.height -
            padding -
            radius;

    double x =
        particle.position.dx;

    double y =
        particle.position.dy;

    double velocityX =
        particle.velocity.dx;

    double velocityY =
        particle.velocity.dy;

    if (x < left && velocityX < 0) {
      x = left;
      velocityX =
          -velocityX * restitution;
    } else if (
    x > right &&
        velocityX > 0) {
      x = right;
      velocityX =
          -velocityX * restitution;
    }

    if (y < top && velocityY < 0) {
      y = top;
      velocityY =
          -velocityY * restitution;
    } else if (
    y > bottom &&
        velocityY > 0) {
      y = bottom;
      velocityY =
          -velocityY * restitution;
    }

    particle.position = Offset(
      x,
      y,
    );

    particle.velocity = Offset(
      velocityX,
      velocityY,
    );
  }
}