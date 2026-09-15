import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/particle_range.dart';
import 'particle_emission.dart';
import 'particle_emitter.dart';

/// Emits particles from random positions inside a rectangular area.
class RectangleEmitter extends ParticleEmitter {
  /// Creates a rectangular-area emitter.
  ///
  /// [topLeft] and [bottomRight] define the two corners of the emission area.
  /// Each particle receives a launch angle sampled from [direction].
  const RectangleEmitter({
    this.topLeft = Alignment.topLeft,
    this.bottomRight = Alignment.bottomRight,
    this.direction = const ParticleRange(
      0,
      math.pi * 2,
    ),
  });

  /// First corner of the emission area.
  final Alignment topLeft;

  /// Opposite corner of the emission area.
  final Alignment bottomRight;

  /// Initial particle direction range in radians.
  final ParticleRange direction;

  @override
  ParticleEmission emit(
      math.Random random,
      Size canvasSize,
      ) {
    final Offset first =
    topLeft.alongSize(canvasSize);

    final Offset second =
    bottomRight.alongSize(canvasSize);

    final double minX =
    math.min(first.dx, second.dx);

    final double maxX =
    math.max(first.dx, second.dx);

    final double minY =
    math.min(first.dy, second.dy);

    final double maxY =
    math.max(first.dy, second.dy);

    final Offset position = Offset(
      minX +
          random.nextDouble() *
              (maxX - minX),
      minY +
          random.nextDouble() *
              (maxY - minY),
    );

    final double angle =
    direction.sample(random);

    return ParticleEmission(
      position: position,
      direction: Offset(
        math.cos(angle),
        math.sin(angle),
      ),
    );
  }
}