import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/particle_range.dart';
import 'particle_emission.dart';
import 'particle_emitter.dart';

/// Emits particles from a single point.
///
/// By default particles are emitted radially in every direction.
class PointEmitter extends ParticleEmitter {
  /// Creates a point emitter.
  ///
  /// [position] defines the particle origin inside the particle canvas and
  /// [direction] defines the range of possible launch angles in radians.
  const PointEmitter({
    this.position = Alignment.center,
    this.direction = const ParticleRange(
      0,
      math.pi * 2,
    ),
  });

  /// Position of the emitter inside the particle canvas.
  final Alignment position;

  /// Direction angle range in radians.
  ///
  /// Flutter canvas directions:
  ///
  /// 0 = right
  /// π / 2 = down
  /// π = left
  /// 3π / 2 = up
  final ParticleRange direction;

  @override
  ParticleEmission emit(
      math.Random random,
      Size canvasSize,
      ) {
    final double angle =
    direction.sample(random);

    final Offset emissionPosition =
    position.alongSize(
      canvasSize,
    );

    final Offset emissionDirection =
    Offset(
      math.cos(angle),
      math.sin(angle),
    );

    return ParticleEmission(
      position: emissionPosition,
      direction: emissionDirection,
    );
  }
}