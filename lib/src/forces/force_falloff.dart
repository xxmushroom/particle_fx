/// Controls how the strength of a positional force changes with distance.
enum ForceFalloff {
  /// Force strength stays constant regardless of distance.
  constant,

  /// Force becomes weaker as distance increases.
  linear,

  /// Force follows approximately 1 / distance.
  inverse,

  /// Force follows approximately 1 / distance².
  ///
  /// This behaves more like gravitational or magnetic attraction.
  inverseSquare,
}

/// Calculates a force multiplier based on distance.
double calculateForceFalloff({
  required ForceFalloff falloff,
  required double distance,
  required double referenceDistance,
}) {
  if (referenceDistance <= 0) {
    return 1;
  }

  final double normalizedDistance =
      distance / referenceDistance;

  switch (falloff) {
    case ForceFalloff.constant:
      return 1;

    case ForceFalloff.linear:
      return (1 - normalizedDistance)
          .clamp(0.0, 1.0);

    case ForceFalloff.inverse:
      return 1 /
          (1 + normalizedDistance);

    case ForceFalloff.inverseSquare:
      return 1 /
          (
              1 +
                  normalizedDistance *
                      normalizedDistance
          );
  }
}