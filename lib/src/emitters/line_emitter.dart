import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/particle_range.dart';
import 'particle_emission.dart';
import 'particle_emitter.dart';

/// Emits particles from random positions along a line.
class LineEmitter extends ParticleEmitter {
  /// Creates a line emitter between [start] and [end].
  ///
  /// Each particle is placed at a random position along the line and receives
  /// an initial launch angle sampled from [direction].
  const LineEmitter({
    this.start = Alignment.topLeft,
    this.end = Alignment.topRight,
    this.direction = const ParticleRange(
      0,
      math.pi * 2,
    ),
  });

  /// Start of the emission line.
  final Alignment start;

  /// End of the emission line.
  final Alignment end;

  /// Initial direction angle range in radians.
  final ParticleRange direction;

  @override
  ParticleEmission emit(
      math.Random random,
      Size canvasSize,
      ) {
    final Offset startPosition =
    start.alongSize(
      canvasSize,
    );

    final Offset endPosition =
    end.alongSize(
      canvasSize,
    );

    final double progress =
    random.nextDouble();

    final Offset emissionPosition =
    Offset(
      startPosition.dx +
          (endPosition.dx -
              startPosition.dx) *
              progress,
      startPosition.dy +
          (endPosition.dy -
              startPosition.dy) *
              progress,
    );

    final double angle =
    direction.sample(random);

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