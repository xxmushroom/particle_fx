import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/particle_range.dart';
import 'particle_emission.dart';
import 'particle_emitter.dart';

/// Emits particles from the circumference of a circle.
///
/// Particles move outward by default.
///
/// Use [inward] to reverse the radial direction.
///
/// [directionOffset] can be used to rotate or spread the launch
/// direction relative to the radial direction.
class CircleEmitter extends ParticleEmitter {
  /// Creates an emitter that spawns particles around a circle.
  ///
  /// [center] defines the circle center and [radius] its size in logical
  /// pixels. Set [inward] to true to reverse the radial launch direction.
  ///
  /// [directionOffset] is added to the radial launch angle for each particle.
  const CircleEmitter({
    this.center = Alignment.center,
    this.radius = 100,
    this.inward = false,
    this.directionOffset =
    const ParticleRange.fixed(0),
  }) : assert(
  radius > 0,
  'radius must be greater than zero.',
  );

  /// Center of the circle.
  final Alignment center;

  /// Circle radius in logical pixels.
  final double radius;

  /// Whether particles should initially move toward the center.
  final bool inward;

  /// Angular offset from the radial direction.
  ///
  /// Examples:
  ///
  /// ParticleRange.fixed(0)
  ///   -> radial
  ///
  /// ParticleRange.fixed(pi / 2)
  ///   -> tangential
  ///
  /// ParticleRange(-0.2, 0.2)
  ///   -> slightly scattered radial direction
  final ParticleRange directionOffset;

  @override
  ParticleEmission emit(
      math.Random random,
      Size canvasSize,
      ) {
    final Offset centerPosition =
    center.alongSize(canvasSize);

    final double circleAngle =
        random.nextDouble() *
            math.pi *
            2;

    final Offset radialDirection =
    Offset(
      math.cos(circleAngle),
      math.sin(circleAngle),
    );

    final Offset position =
        centerPosition +
            radialDirection * radius;

    final double baseDirection =
        circleAngle +
            (inward ? math.pi : 0);

    final double launchAngle =
        baseDirection +
            directionOffset.sample(
              random,
            );

    return ParticleEmission(
      position: position,
      direction: Offset(
        math.cos(launchAngle),
        math.sin(launchAngle),
      ),
    );
  }
}