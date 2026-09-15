import 'dart:math' as math;
import 'dart:ui';

import '../core/particle_force_state.dart';
import 'particle_force.dart';

/// Gradually reduces particle velocity.
///
/// Drag uses exponential damping, making its behavior stable across
/// different frame rates.
class DragForce extends ParticleForce {
  /// Creates a velocity damping force.
  ///
  /// [coefficient] controls how quickly velocity decays.
  /// A value of zero disables the effect.
  const DragForce({
    this.coefficient = 1,
  }) : assert(
  coefficient >= 0,
  'coefficient cannot be negative.',
  );

  /// Strength of the drag effect.
  ///
  /// `0` means no drag.
  final double coefficient;

  @override
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      ) {
    if (coefficient == 0) {
      return;
    }

    final double damping = math.exp(
      -coefficient * deltaTime,
    );

    particle.velocity *= damping;
  }
}