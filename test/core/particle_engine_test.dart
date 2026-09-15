import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';
import 'package:particle_fx/src/core/particle_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const Size canvasSize =
  Size(
    300,
    300,
  );

  late ParticleTexture texture;

  setUp(() async {
    final Uint8List bytes =
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );

    texture =
    await ParticleTexture.fromBytes(
      bytes,
    );
  });

  tearDown(() {
    if (!texture.isDisposed) {
      texture.dispose();
    }
  });

  ParticleBurstConfig buildConfig({
    int count = 1,
    double lifetime = 1,
    ParticleTrail? trail,
  }) {
    return ParticleBurstConfig(
      texture: texture,
      count: count,
      emitter:
      const PointEmitter(
        position:
        Alignment.center,
      ),
      speed:
      const ParticleRange.fixed(
        0,
      ),
      size:
      const ParticleRange.fixed(
        20,
      ),
      lifetime:
      ParticleRange.fixed(
        lifetime,
      ),
      rotation:
      const ParticleRange.fixed(
        0,
      ),
      angularVelocity:
      const ParticleRange.fixed(
        0,
      ),
      appearance:
      ParticleAppearance(
        opacity:
        const ParticleLifetimeValue
            .constant(
          1,
        ),
        scale:
        const ParticleLifetimeValue
            .constant(
          1,
        ),
        trail: trail,
      ),
    );
  }

  group(
    'ParticleEngine',
        () {
      test(
        'starts empty',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 100,
          );

          expect(
            engine.particleCount,
            0,
          );

          expect(
            engine.emittedParticles,
            0,
          );

          expect(
            engine.droppedParticles,
            0,
          );

          expect(
            engine.trailSampleCount,
            0,
          );

          expect(
            engine.estimatedDrawCalls,
            0,
          );

          expect(
            engine.maxParticles,
            100,
          );
        },
      );

      test(
        'spawn creates requested particles',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 100,
          );

          final ParticleBurstConfig config =
          buildConfig(
            count: 5,
          );

          engine.spawnBurst(
            config,
            canvasSize,
          );

          expect(
            engine.particleCount,
            5,
          );

          expect(
            engine.emittedParticles,
            5,
          );

          expect(
            engine.droppedParticles,
            0,
          );
        },
      );

      test(
        'respects maximum particle capacity',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 3,
          );

          engine.spawnBurst(
            buildConfig(
              count: 5,
            ),
            canvasSize,
          );

          expect(
            engine.particleCount,
            3,
          );

          expect(
            engine.emittedParticles,
            3,
          );

          expect(
            engine.droppedParticles,
            2,
          );
        },
      );

      test(
        'additional particles are dropped when capacity is already full',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 2,
          );

          engine.spawnBurst(
            buildConfig(
              count: 2,
            ),
            canvasSize,
          );

          engine.spawnBurst(
            buildConfig(
              count: 4,
            ),
            canvasSize,
          );

          expect(
            engine.particleCount,
            2,
          );

          expect(
            engine.emittedParticles,
            2,
          );

          expect(
            engine.droppedParticles,
            4,
          );
        },
      );

      test(
        'empty canvas does not count particles as dropped',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 10,
          );

          engine.spawnBurst(
            buildConfig(
              count: 5,
            ),
            Size.zero,
          );

          expect(
            engine.particleCount,
            0,
          );

          expect(
            engine.emittedParticles,
            0,
          );

          expect(
            engine.droppedParticles,
            0,
          );
        },
      );

      test(
        'particles expire after their lifetime',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 10,
          );

          engine.spawnBurst(
            buildConfig(
              count: 3,
              lifetime: 1,
            ),
            canvasSize,
          );

          expect(
            engine.particleCount,
            3,
          );

          for (
          int i = 0;
          i < 10;
          i++
          ) {
            engine.update(
              0.05,
              canvasSize,
            );
          }

          expect(
            engine.particleCount,
            3,
          );

          for (
          int i = 0;
          i < 11;
          i++
          ) {
            engine.update(
              0.05,
              canvasSize,
            );
          }

          expect(
            engine.particleCount,
            0,
          );
        },
      );

      test(
        'expired particles free capacity for new particles',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 2,
          );

          engine.spawnBurst(
            buildConfig(
              count: 2,
              lifetime: 0.1,
            ),
            canvasSize,
          );

          expect(
            engine.particleCount,
            2,
          );

          for (
          int i = 0;
          i < 3;
          i++
          ) {
            engine.update(
              0.05,
              canvasSize,
            );
          }

          expect(
            engine.particleCount,
            0,
          );

          engine.spawnBurst(
            buildConfig(
              count: 2,
            ),
            canvasSize,
          );

          expect(
            engine.particleCount,
            2,
          );

          expect(
            engine.emittedParticles,
            4,
          );

          expect(
            engine.droppedParticles,
            0,
          );
        },
      );

      test(
        'emitted counter is cumulative',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 10,
          );

          engine.spawnBurst(
            buildConfig(
              count: 3,
              lifetime: 0.1,
            ),
            canvasSize,
          );

          for (
          int i = 0;
          i < 3;
          i++
          ) {
            engine.update(
              0.05,
              canvasSize,
            );
          }

          engine.spawnBurst(
            buildConfig(
              count: 4,
            ),
            canvasSize,
          );

          expect(
            engine.particleCount,
            4,
          );

          expect(
            engine.emittedParticles,
            7,
          );
        },
      );

      test(
        'particles without trails have no trail samples',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 10,
          );

          engine.spawnBurst(
            buildConfig(
              count: 3,
            ),
            canvasSize,
          );

          engine.update(
            0.1,
            canvasSize,
          );

          expect(
            engine.trailSampleCount,
            0,
          );

          expect(
            engine.estimatedDrawCalls,
            engine.particleCount,
          );
        },
      );

      test(
        'trail samples contribute to estimated draw calls',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 10,
          );

          engine.spawnBurst(
            buildConfig(
              count: 1,
              lifetime: 2,
              trail:
              const ParticleTrail(
                maxPoints: 8,
                sampleInterval:
                Duration(
                  milliseconds: 10,
                ),
                opacity: 0.5,
                startScale: 0.5,
              ),
            ),
            canvasSize,
          );

          for (
          int i = 0;
          i < 5;
          i++
          ) {
            engine.update(
              0.02,
              canvasSize,
            );
          }

          expect(
            engine.particleCount,
            1,
          );

          expect(
            engine.trailSampleCount,
            greaterThan(0),
          );

          expect(
            engine.estimatedDrawCalls,
            engine.particleCount +
                engine.trailSampleCount,
          );
        },
      );

      test(
        'trail sample count respects maxPoints',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 10,
          );

          engine.spawnBurst(
            buildConfig(
              count: 1,
              lifetime: 5,
              trail:
              const ParticleTrail(
                maxPoints: 3,
                sampleInterval:
                Duration(
                  milliseconds: 10,
                ),
              ),
            ),
            canvasSize,
          );

          for (
          int i = 0;
          i < 20;
          i++
          ) {
            engine.update(
              0.02,
              canvasSize,
            );
          }

          expect(
            engine.trailSampleCount,
            lessThanOrEqualTo(3),
          );
        },
      );

      test(
        'trail samples disappear when particle expires',
            () {
          final ParticleEngine engine =
          ParticleEngine(
            maxParticles: 10,
          );

          engine.spawnBurst(
            buildConfig(
              lifetime: 0.2,
              trail:
              const ParticleTrail(
                maxPoints: 8,
                sampleInterval:
                Duration(
                  milliseconds: 10,
                ),
              ),
            ),
            canvasSize,
          );

          engine.update(
            0.05,
            canvasSize,
          );

          expect(
            engine.trailSampleCount,
            greaterThan(0),
          );

          for (
          int i = 0;
          i < 4;
          i++
          ) {
            engine.update(
              0.05,
              canvasSize,
            );
          }

          expect(
            engine.particleCount,
            0,
          );

          expect(
            engine.trailSampleCount,
            0,
          );

          expect(
            engine.estimatedDrawCalls,
            0,
          );
        },
      );
    },
  );
}
