import 'dart:ui';

import '../core/particle.dart';

/// Base class for forces that can influence particle motion.
///
/// A force modifies a particle's velocity during each simulation step.
abstract class ParticleForce {
  /// Creates a particle force.
  const ParticleForce();

  /// Applies this force to [particle].
  ///
  /// [deltaTime] is measured in seconds.
  ///
  /// [canvasSize] is the current size of the particle canvas and allows
  /// forces such as attractors and vortices to use relative positions.
  void apply(
      Particle particle,
      double deltaTime,
      Size canvasSize,
      );
}