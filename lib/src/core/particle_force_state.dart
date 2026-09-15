import 'dart:ui';

/// Particle state exposed to custom particle force implementations.
///
/// This is intentionally a limited view of the engine's internal particle.
/// It exposes motion-related state that a force may inspect or modify without
/// exposing textures, trails, appearance internals, or other engine-owned
/// implementation details.
///
/// Instances are supplied by the particle engine when a force is evaluated.
abstract interface class ParticleForceState {
  /// Current particle position in particle-canvas coordinates.
  Offset get position;

  /// Updates the particle position in particle-canvas coordinates.
  set position(Offset value);

  /// Current particle velocity in logical pixels per second.
  Offset get velocity;

  /// Updates the particle velocity in logical pixels per second.
  set velocity(Offset value);

  /// Current particle size in logical pixels.
  double get size;

  /// Current particle rotation in radians.
  double get rotation;

  /// Updates the particle rotation in radians.
  set rotation(double value);

  /// Current angular velocity in radians per second.
  double get angularVelocity;

  /// Updates the angular velocity in radians per second.
  set angularVelocity(double value);

  /// Number of seconds the particle has been alive.
  double get age;

  /// Total configured particle lifetime in seconds.
  double get lifetime;

  /// Normalized lifetime progress from `0.0` to `1.0`.
  double get progress;
}