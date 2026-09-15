import 'package:flutter/widgets.dart';

import 'particle_force_target_controller.dart';

/// Defines a point that a positional particle force acts around.
///
/// A target may be:
///
/// - An alignment relative to the particle canvas.
/// - An exact canvas position.
/// - A runtime position controlled by [ParticleForceTargetController].
class ParticleForceTarget {
  /// Creates a target positioned relative to the particle canvas.
  ///
  /// [alignment] is resolved against the current canvas size.
  const ParticleForceTarget.alignment(
      this.alignment,
      )   : position = null,
        controller = null,
        fallbackAlignment =
            Alignment.center;

  /// Creates a target using an absolute particle-canvas [position].
  const ParticleForceTarget.position(
      this.position,
      )   : alignment = null,
        controller = null,
        fallbackAlignment =
            Alignment.center;

  /// Creates a runtime-controlled target.
  ///
  /// The current position is obtained from [controller]. When the controller
  /// has no position, [fallbackAlignment] is used instead.
  const ParticleForceTarget.controller(
      this.controller, {
        this.fallbackAlignment =
            Alignment.center,
      })  : alignment = null,
        position = null;

  /// Target expressed relative to the particle canvas.
  final Alignment? alignment;

  /// Target expressed directly in particle-canvas coordinates.
  final Offset? position;

  /// Runtime-controlled target.
  final ParticleForceTargetController?
  controller;

  /// Position used when a controller does not currently contain
  /// a runtime position.
  final Alignment fallbackAlignment;

  /// Resolves this target into particle-canvas coordinates.
  Offset resolve(
      Size canvasSize,
      ) {
    final Offset? controlledPosition =
        controller?.position;

    if (controlledPosition != null) {
      return controlledPosition;
    }

    final Offset? absolutePosition =
        position;

    if (absolutePosition != null) {
      return absolutePosition;
    }

    final Alignment? relativeAlignment =
        alignment;

    if (relativeAlignment != null) {
      return relativeAlignment.alongSize(
        canvasSize,
      );
    }

    return fallbackAlignment.alongSize(
      canvasSize,
    );
  }
}