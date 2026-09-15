import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'particle_emission.dart';

/// Defines how particles are initially positioned and launched.
///
/// Custom emitters can extend this class to create new emission patterns.
abstract class ParticleEmitter {
  /// Creates a particle emitter.
  const ParticleEmitter();

  /// Generates the initial state for one particle.
  ParticleEmission emit(
      math.Random random,
      Size canvasSize,
      );
}