import 'dart:math' as math;

import 'package:flutter/animation.dart';

/// Built-in animation curves designed for particle lifetime effects.
abstract final class ParticleLifetimeCurves {
  /// A smooth pulse that starts at zero, reaches one halfway through the
  /// particle lifetime, and returns to zero at the end.
  ///
  /// This is useful for effects such as fade-in/fade-out opacity, glow pulses,
  /// and scale pulses.
  static const Curve pulse =
  _ParticlePulseCurve();
}

class _ParticlePulseCurve extends Curve {
  const _ParticlePulseCurve();

  @override
  double transform(
      double t,
      ) {
    final double clamped =
    t.clamp(
      0.0,
      1.0,
    ).toDouble();

    return math.sin(
      math.pi * clamped,
    );
  }

  @override
  double transformInternal(
      double t,
      ) {
    return math.sin(
      math.pi * t,
    );
  }
}