import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../core/particle.dart';
import 'particle_force.dart';

/// Applies a smooth, fluid-like swirling force field to particles.
///
/// Unlike [TurbulenceForce], which creates irregular motion,
/// [CurlNoiseForce] produces coherent flowing currents.
///
/// This is useful for:
///
/// - Smoke
/// - Fire
/// - Magic effects
/// - Nebula effects
/// - Energy trails
/// - Floating particles
///
/// The field is generated procedurally and does not require any
/// external noise package.
class CurlNoiseForce extends ParticleForce {
  /// Creates a procedural curl-noise force field.
  ///
  /// [strength] controls acceleration magnitude, [scale] controls spatial
  /// frequency, [speed] controls animation speed, and [octaves] controls the
  /// number of layered frequencies.
  ///
  /// [seed] shifts the generated field so different values produce different
  /// flow patterns.
  const CurlNoiseForce({
    this.strength = 250,
    this.scale = 0.012,
    this.speed = 1,
    this.octaves = 3,
    this.seed = 0,
  })  : assert(
  strength >= 0,
  'strength cannot be negative.',
  ),
        assert(
        scale > 0,
        'scale must be greater than zero.',
        ),
        assert(
        speed >= 0,
        'speed cannot be negative.',
        ),
        assert(
        octaves > 0,
        'octaves must be greater than zero.',
        );

  /// Strength of the resulting acceleration field.
  final double strength;

  /// Spatial scale of the flow field.
  ///
  /// Smaller values create larger, smoother swirls.
  ///
  /// Larger values create tighter, more detailed swirls.
  final double scale;

  /// How quickly the field changes over time.
  final double speed;

  /// Number of layered frequencies used to build the field.
  ///
  /// Higher values create more detailed motion.
  final int octaves;

  /// Changes the shape of the generated field.
  final double seed;

  @override
  void apply(
      Particle particle,
      double deltaTime,
      Size canvasSize,
      ) {
    if (strength == 0) {
      return;
    }

    final double centeredX =
        particle.position.dx -
            canvasSize.width / 2;

    final double centeredY =
        particle.position.dy -
            canvasSize.height / 2;

    final double time =
        particle.age * speed;

    double curlX = 0;
    double curlY = 0;

    double frequency = scale;
    double amplitude = 1;

    for (
    int octave = 0;
    octave < octaves;
    octave++
    ) {
      final double octaveSeed =
          seed + octave * 17.371;

      final double phaseX =
          centeredX * frequency +
              time *
                  (1 + octave * 0.13) +
              octaveSeed;

      final double phaseY =
          centeredY *
              frequency *
              1.17 -
              time *
                  (0.8 + octave * 0.11) +
              octaveSeed * 1.91;

      final double phaseXY =
          (centeredX + centeredY) *
              frequency *
              0.73 +
              time *
                  (0.55 + octave * 0.09) +
              octaveSeed * 0.61;

      final double derivativeX =
          math.cos(phaseX) *
              frequency +
              0.5 *
                  math.cos(phaseXY) *
                  frequency *
                  0.73;

      final double derivativeY =
          -math.sin(phaseY) *
              frequency *
              1.17 +
              0.5 *
                  math.cos(phaseXY) *
                  frequency *
                  0.73;

      curlX +=
          derivativeY * amplitude;

      curlY +=
          -derivativeX * amplitude;

      frequency *= 2;
      amplitude *= 0.5;
    }

    final double magnitude =
    math.sqrt(
      curlX * curlX +
          curlY * curlY,
    );

    if (magnitude <= 0.000001) {
      return;
    }

    final Offset direction = Offset(
      curlX / magnitude,
      curlY / magnitude,
    );

    particle.velocity +=
        direction *
            strength *
            deltaTime;
  }
}