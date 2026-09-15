// ignore_for_file: public_member_api_docs
import 'dart:ui' as ui;

import '../appearance/particle_trail.dart';
import '../core/particle.dart';
import 'particle_renderer.dart';

class ImageParticleRenderer
    extends ParticleRenderer {
  ImageParticleRenderer({
    this.filterQuality =
        ui.FilterQuality.medium,
  });

  final ui.FilterQuality
  filterQuality;

  @override
  void render(
      ui.Canvas canvas,
      ui.Size size,
      Iterable<Particle> particles,
      ) {
    final ui.Paint paint =
    ui.Paint()
      ..filterQuality =
          filterQuality;

    for (final Particle particle
    in particles) {
      if (particle.texture.isDisposed) {
        continue;
      }

      _renderTrail(
        canvas,
        paint,
        particle,
      );

      _renderParticle(
        canvas,
        paint,
        particle,
      );
    }
  }

  void _renderTrail(
      ui.Canvas canvas,
      ui.Paint paint,
      Particle particle,
      ) {
    final ParticleTrail? trail =
        particle.appearance.trail;

    final List<ParticleTrailSample>?
    samples =
        particle.trailSamples;

    if (trail == null ||
        samples == null ||
        samples.isEmpty) {
      return;
    }

    final int count =
        samples.length;

    for (
    int index = 0;
    index < count;
    index++
    ) {
      final ParticleTrailSample sample =
      samples[index];

      final double historyProgress =
      count == 1
          ? 1
          : index /
          (count - 1);

      final double opacityMultiplier =
          trail.opacity *
              ((index + 1) / count);

      final double scaleMultiplier =
          trail.startScale +
              (1 - trail.startScale) *
                  historyProgress;

      _drawParticleImage(
        canvas: canvas,
        paint: paint,
        particle: particle,
        position: sample.position,
        rotation: sample.rotation,
        progress: sample.progress,
        opacityMultiplier:
        opacityMultiplier,
        scaleMultiplier:
        scaleMultiplier,
      );
    }
  }

  void _renderParticle(
      ui.Canvas canvas,
      ui.Paint paint,
      Particle particle,
      ) {
    _drawParticleImage(
      canvas: canvas,
      paint: paint,
      particle: particle,
      position: particle.position,
      rotation: particle.rotation,
      progress: particle.progress,
      opacityMultiplier: 1,
      scaleMultiplier: 1,
    );
  }

  void _drawParticleImage({
    required ui.Canvas canvas,
    required ui.Paint paint,
    required Particle particle,
    required ui.Offset position,
    required double rotation,
    required double progress,
    required double opacityMultiplier,
    required double scaleMultiplier,
  }) {
    final ui.Image image =
        particle.texture.image;

    final double opacity =
        particle.appearance.opacity
            .evaluate(
          progress,
        )
            .clamp(
          0.0,
          1.0,
        )
            .toDouble() *
            opacityMultiplier;

    final double scale =
        particle.appearance.scale
            .evaluate(
          progress,
        ) *
            scaleMultiplier;

    if (opacity <= 0 ||
        scale <= 0) {
      return;
    }

    final ui.Color tint =
    particle.appearance.color
        .evaluate(
      progress,
    );

    final double particleHeight =
        particle.size *
            scale;

    final double particleWidth =
        particleHeight *
            particle.texture
                .aspectRatio;

    final ui.Rect sourceRect =
    ui.Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final ui.Rect destinationRect =
    ui.Rect.fromCenter(
      center: ui.Offset.zero,
      width: particleWidth,
      height: particleHeight,
    );

    final int alpha =
    (opacity * 255)
        .round()
        .clamp(
      0,
      255,
    );

    paint
      ..color =
      ui.Color.fromARGB(
        alpha,
        255,
        255,
        255,
      )
      ..colorFilter =
      ui.ColorFilter.mode(
        tint,
        ui.BlendMode.modulate,
      )
      ..blendMode =
          particle
              .appearance
              .blendMode;

    canvas.save();

    canvas.translate(
      position.dx,
      position.dy,
    );

    canvas.rotate(
      rotation,
    );

    canvas.drawImageRect(
      image,
      sourceRect,
      destinationRect,
      paint,
    );

    canvas.restore();
  }
}