import 'dart:ui';

import '../core/particle_force_state.dart';

/// Base class for forces that can influence particle motion.
///
/// A force is evaluated during each simulation step and may inspect or modify
/// the public [ParticleForceState] supplied by the particle engine.
///
/// Custom forces can extend this class without depending on internal
/// `particle_fx` implementation types.
abstract class ParticleForce {
  /// Creates a particle force.
  const ParticleForce();

  /// Applies this force to [particle].
  ///
  /// [deltaTime] is measured in seconds.
  ///
  /// [canvasSize] is the current size of the particle canvas and allows
  /// positional forces to work relative to the available drawing area.
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      );
}