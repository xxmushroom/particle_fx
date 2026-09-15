import 'package:flutter/animation.dart';

/// Describes how a numeric particle property changes over its lifetime.
class ParticleLifetimeValue {
  /// Creates a value that interpolates from [begin] to [end].
  ///
  /// The supplied [curve] transforms normalized lifetime progress before
  /// interpolation is performed.
  const ParticleLifetimeValue({
    this.begin = 1,
    this.end = 1,
    this.curve = Curves.linear,
  });

  /// Creates a lifetime value that remains constant.
  const ParticleLifetimeValue.constant(
      double value,
      )   : begin = value,
        end = value,
        curve = Curves.linear;

  /// Value when the particle is born.
  final double begin;

  /// Value reached when the curve evaluates to 1.
  final double end;

  /// Controls interpolation over normalized particle lifetime.
  final Curve curve;

  /// Evaluates this value at normalized particle lifetime [progress].
  ///
  /// The supplied progress is clamped to the range `0.0` to `1.0` before
  /// [curve] is evaluated.
  double evaluate(
      double progress,
      ) {
    final double t =
    progress
        .clamp(
      0.0,
      1.0,
    )
        .toDouble();

    final double transformed =
    curve.transform(
      t,
    );

    return begin +
        (end - begin) * transformed;
  }
}