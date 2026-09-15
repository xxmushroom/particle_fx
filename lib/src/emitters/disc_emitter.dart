import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/particle_range.dart';
import 'particle_emission.dart';
import 'particle_emitter.dart';

/// Emits particles from random positions inside a circular area.
///
/// Unlike [CircleEmitter], which emits from the circumference,
/// this emitter fills the entire disc.
///
/// Particles move radially outward by default.
class DiscEmitter extends ParticleEmitter {
  /// Creates an emitter that fills a circular area.
  ///
  /// [center] defines the disc center and [radius] its size in logical pixels.
  /// Set [inward] to true to launch particles toward the center.
  ///
  /// [directionOffset] is added to each particle's radial launch angle.
  const DiscEmitter({
    this.center = Alignment.center,
    this.radius = 100,
    this.inward = false,
    this.directionOffset =
    const ParticleRange.fixed(0),
  }) : assert(
  radius > 0,
  'radius must be greater than zero.',
  );

  /// Center of the disc.
  final Alignment center;

  /// Radius of the disc in logical pixels.
  final double radius;

  /// Whether particles should initially move toward the center.
  final bool inward;

  /// Angular offset from the radial launch direction.
  final ParticleRange directionOffset;

  @override
  ParticleEmission emit(
      math.Random random,
      Size canvasSize,
      ) {
    final Offset centerPosition =
    center.alongSize(canvasSize);

    final double angle =
        random.nextDouble() *
            math.pi *
            2;

    // sqrt() is important here.
    //
    // Sampling radius linearly would cause too many
    // particles to accumulate near the center.
    final double sampledRadius =
        math.sqrt(
          random.nextDouble(),
        ) *
            radius;

    final Offset radialDirection =
    Offset(
      math.cos(angle),
      math.sin(angle),
    );

    final Offset position =
        centerPosition +
            radialDirection *
                sampledRadius;

    final double baseDirection =
        angle +
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