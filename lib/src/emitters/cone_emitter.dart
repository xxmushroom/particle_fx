import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'particle_emission.dart';
import 'particle_emitter.dart';

/// Emits particles from a point inside a directional cone.
///
/// Useful for fountains, sparks, exhaust, flames and jets.
class ConeEmitter extends ParticleEmitter {
  /// Creates a directional cone emitter.
  ///
  /// [position] defines the emission origin, [direction] defines the center
  /// launch angle in radians, and [spread] defines the total angular width
  /// of the cone.
  const ConeEmitter({
    this.position = Alignment.center,
    this.direction = -math.pi / 2,
    this.spread = math.pi / 4,
  }) : assert(
  spread >= 0 &&
      spread <= math.pi * 2,
  'spread must be between 0 and 2π.',
  );

  /// Origin of the cone.
  final Alignment position;

  /// Center direction of the cone in radians.
  ///
  /// 0 = right
  /// π / 2 = down
  /// π = left
  /// -π / 2 = up
  final double direction;

  /// Total angular width of the cone.
  final double spread;

  @override
  ParticleEmission emit(
      math.Random random,
      Size canvasSize,
      ) {
    final Offset emissionPosition =
    position.alongSize(
      canvasSize,
    );

    final double angleOffset =
        (random.nextDouble() - 0.5) *
            spread;

    final double angle =
        direction + angleOffset;

    return ParticleEmission(
      position: emissionPosition,
      direction: Offset(
        math.cos(angle),
        math.sin(angle),
      ),
    );
  }
}