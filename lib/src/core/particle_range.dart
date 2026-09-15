import 'dart:math';

/// Defines a numeric range used to generate randomized particle values.
///
/// Example:
///
/// ```dart
/// const ParticleRange(20, 60)
/// ```
///
/// can generate any value between `20` and `60`.
class ParticleRange {
  /// Creates a range between [min] and [max].
  ///
  /// [min] must be less than or equal to [max].
  const ParticleRange(
      this.min,
      this.max,
      ) : assert(
  min <= max,
  'min must be less than or equal to max.',
  );

  /// Creates a range that always returns the same value.
  const ParticleRange.fixed(double value)
      : min = value,
        max = value;

  /// Minimum value of the range.
  final double min;

  /// Maximum value of the range.
  final double max;

  /// Returns whether this range always produces the same value.
  bool get isFixed => min == max;

  /// Generates a random value within this range.
  double sample(Random random) {
    if (isFixed) {
      return min;
    }

    return min +
        random.nextDouble() *
            (max - min);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ParticleRange &&
            other.min == min &&
            other.max == max;
  }

  @override
  int get hashCode =>
      Object.hash(min, max);

  @override
  String toString() {
    return 'ParticleRange($min, $max)';
  }
}