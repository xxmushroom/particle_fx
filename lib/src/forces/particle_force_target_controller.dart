import 'dart:ui';

/// Controls the runtime position of a particle force target.
///
/// This allows forces such as attractors, repulsors, and vortices
/// to follow a moving point such as a finger, mouse cursor, or
/// animated position.
class ParticleForceTargetController {
  Offset? _position;

  /// Current target position in particle-canvas coordinates.
  Offset? get position => _position;

  /// Whether a runtime target position is currently available.
  bool get hasPosition => _position != null;

  /// Moves the target to [position].
  void update(Offset position) {
    _position = position;
  }

  /// Removes the runtime position.
  ///
  /// A [ParticleForceTarget] using this controller will fall back
  /// to its configured fallback alignment.
  void clear() {
    _position = null;
  }
}