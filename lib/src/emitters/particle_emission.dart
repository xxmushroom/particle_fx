import 'package:flutter/widgets.dart';

/// Describes the initial position and direction of one emitted particle.
class ParticleEmission {
  /// Creates an emission result with [position] and [direction].
  ///
  /// [position] uses particle-canvas coordinates and [direction] represents
  /// the particle's initial normalized movement direction.
  const ParticleEmission({
    required this.position,
    required this.direction,
  });

  /// Initial particle position in canvas coordinates.
  final Offset position;

  /// Initial normalized direction vector.
  final Offset direction;
}