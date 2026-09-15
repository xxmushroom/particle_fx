// ignore_for_file: public_member_api_docs
import 'dart:ui';

import '../appearance/particle_appearance.dart';
import '../textures/particle_texture.dart';

class ParticleTrailSample {
  const ParticleTrailSample({
    required this.position,
    required this.rotation,
    required this.progress,
  });

  final Offset position;
  final double rotation;
  final double progress;
}

class Particle {
  Particle({
    required this.texture,
    required this.position,
    required this.velocity,
    required this.lifetime,
    required this.size,
    required this.rotation,
    required this.angularVelocity,
    required this.appearance,
  });

  final ParticleTexture texture;

  Offset position;
  Offset velocity;

  final double lifetime;

  double age = 0;
  double size;
  double rotation;
  double angularVelocity;

  final ParticleAppearance appearance;

  /// Internal trail history.
  ///
  /// Allocated lazily only when trails are enabled.
  List<ParticleTrailSample>? trailSamples;

  /// Internal timer used to decide when another trail sample is stored.
  double trailSampleAccumulator = 0;

  double get progress {
    if (lifetime <= 0) {
      return 1;
    }

    return (age / lifetime)
        .clamp(
      0.0,
      1.0,
    );
  }

  bool get isDead =>
      age >= lifetime;
}