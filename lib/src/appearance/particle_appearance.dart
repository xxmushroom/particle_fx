import 'dart:ui';

import 'particle_color_over_lifetime.dart';
import 'particle_lifetime_value.dart';
import 'particle_trail.dart';

/// Defines the visual appearance of a particle throughout its lifetime.
///
/// Appearance properties are evaluated independently from particle motion.
/// This allows opacity, scale, color, compositing, and trails to be changed
/// without affecting the emitter or forces controlling the particle.
class ParticleAppearance {
  /// Creates a particle appearance configuration.
  ///
  /// By default, particles fade from fully visible to transparent and shrink
  /// slightly over their lifetime while preserving their original texture
  /// color.
  const ParticleAppearance({
    this.opacity =
    const ParticleLifetimeValue(
      begin: 1,
      end: 0,
    ),
    this.scale =
    const ParticleLifetimeValue(
      begin: 1,
      end: 0.75,
    ),
    this.color =
    const ParticleColorOverLifetime.constant(
      Color(0xFFFFFFFF),
    ),
    this.blendMode = BlendMode.srcOver,
    this.trail,
  });

  /// Particle opacity throughout its lifetime.
  final ParticleLifetimeValue opacity;

  /// Particle scale throughout its lifetime.
  final ParticleLifetimeValue scale;

  /// Particle tint throughout its lifetime.
  final ParticleColorOverLifetime color;

  /// How particles are composited onto the canvas.
  final BlendMode blendMode;

  /// Optional visual trail rendered behind the particle.
  ///
  /// When null, no trail history is stored or rendered.
  final ParticleTrail? trail;
}