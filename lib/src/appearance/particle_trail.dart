/// Controls the visual trail rendered behind a particle.
class ParticleTrail {
  /// Creates a particle trail configuration.
  ///
  /// [maxPoints] controls the maximum number of historical positions retained
  /// for each particle, while [sampleInterval] determines how often positions
  /// are recorded.
  ///
  /// [opacity] controls the maximum trail opacity multiplier, and
  /// [startScale] controls the relative scale of the oldest trail samples.
  const ParticleTrail({
    this.maxPoints = 8,
    this.sampleInterval =
    const Duration(
      milliseconds: 40,
    ),
    this.opacity = 0.45,
    this.startScale = 0.55,
  })  : assert(
  maxPoints > 0,
  'maxPoints must be greater than zero.',
  ),
        assert(
        opacity >= 0 && opacity <= 1,
        'opacity must be between 0 and 1.',
        ),
        assert(
        startScale >= 0,
        'startScale cannot be negative.',
        );

  /// Maximum number of historical samples drawn behind each particle.
  final int maxPoints;

  /// Time between trail samples.
  final Duration sampleInterval;

  /// Maximum opacity multiplier applied to trail samples.
  final double opacity;

  /// Scale multiplier used by the oldest part of the trail.
  ///
  /// Newer samples gradually approach the particle's normal scale.
  final double startScale;
}