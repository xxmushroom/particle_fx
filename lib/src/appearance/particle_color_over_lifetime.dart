import 'package:flutter/animation.dart';

/// Controls particle color throughout its lifetime.
class ParticleColorOverLifetime {
  /// Creates a color transition from [begin] to [end].
  ///
  /// The supplied [curve] transforms normalized particle lifetime progress
  /// before the two colors are interpolated.
  const ParticleColorOverLifetime({
    this.begin = const Color(0xFFFFFFFF),
    this.end = const Color(0xFFFFFFFF),
    this.curve = Curves.linear,
  });

  /// Creates a color configuration that remains constant for the particle's
  /// entire lifetime.
  const ParticleColorOverLifetime.constant(
      Color color,
      )   : begin = color,
        end = color,
        curve = Curves.linear;

  /// Color at the beginning of the particle lifetime.
  final Color begin;

  /// Color at the end of the particle lifetime.
  final Color end;

  /// Curve used to interpolate between [begin] and [end].
  final Curve curve;

  /// Evaluates the color at normalized lifetime [progress].
  ///
  /// Values outside the `0.0` to `1.0` range are clamped before the
  /// interpolation curve is evaluated.
  Color evaluate(
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

    return Color.lerp(
      begin,
      end,
      transformed,
    )!;
  }
}