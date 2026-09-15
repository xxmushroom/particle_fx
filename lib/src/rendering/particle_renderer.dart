// ignore_for_file: public_member_api_docs
import 'dart:ui';

import '../core/particle.dart';

/// Defines how particles are drawn onto a Flutter [Canvas].
///
/// Renderers are separate from the simulation so that particle physics
/// and particle appearance can evolve independently.
abstract class ParticleRenderer {
  const ParticleRenderer();

  /// Draws [particles] onto [canvas].
  void render(
      Canvas canvas,
      Size size,
      Iterable<Particle> particles,
      );
}