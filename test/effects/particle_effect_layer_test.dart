import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';

void main() {
  const ParticlePreset preset =
  ParticlePreset();

  group(
    'ParticleEffectLayer',
        () {
      test(
        'burst layer stores its configuration',
            () {
          const ParticleEffectLayer layer =
          ParticleEffectLayer.burst(
            preset: preset,
            count: 120,
            delay: Duration(
              milliseconds: 80,
            ),
          );

          expect(
            layer.type,
            ParticleEffectLayerType.burst,
          );

          expect(
            layer.isBurst,
            isTrue,
          );

          expect(
            layer.isStream,
            isFalse,
          );

          expect(
            layer.preset,
            same(preset),
          );

          expect(
            layer.count,
            120,
          );

          expect(
            layer.delay,
            const Duration(
              milliseconds: 80,
            ),
          );

          expect(
            layer.particlesPerSecond,
            0,
          );

          expect(
            layer.duration,
            isNull,
          );

          expect(
            layer.loop,
            isFalse,
          );

          expect(
            layer.loopDelay,
            Duration.zero,
          );
        },
      );

      test(
        'stream layer stores its configuration',
            () {
          const ParticleEffectLayer layer =
          ParticleEffectLayer.stream(
            preset: preset,
            particlesPerSecond: 45,
            duration: Duration(
              seconds: 3,
            ),
            delay: Duration(
              milliseconds: 250,
            ),
            loop: true,
            loopDelay: Duration(
              milliseconds: 500,
            ),
          );

          expect(
            layer.type,
            ParticleEffectLayerType.stream,
          );

          expect(
            layer.isBurst,
            isFalse,
          );

          expect(
            layer.isStream,
            isTrue,
          );

          expect(
            layer.preset,
            same(preset),
          );

          expect(
            layer.particlesPerSecond,
            45,
          );

          expect(
            layer.duration,
            const Duration(
              seconds: 3,
            ),
          );

          expect(
            layer.delay,
            const Duration(
              milliseconds: 250,
            ),
          );

          expect(
            layer.loop,
            isTrue,
          );

          expect(
            layer.loopDelay,
            const Duration(
              milliseconds: 500,
            ),
          );

          expect(
            layer.count,
            0,
          );
        },
      );

      test(
        'burst count must be greater than zero',
            () {
          expect(
                () =>
                ParticleEffectLayer.burst(
                  preset: preset,
                  count: 0,
                ),
            throwsAssertionError,
          );
        },
      );

      test(
        'stream rate must be greater than zero',
            () {
          expect(
                () =>
                ParticleEffectLayer.stream(
                  preset: preset,
                  particlesPerSecond: 0,
                ),
            throwsAssertionError,
          );
        },
      );

      test(
        'looping stream requires duration',
            () {
          expect(
                () =>
                ParticleEffectLayer.stream(
                  preset: preset,
                  loop: true,
                ),
            throwsAssertionError,
          );
        },
      );

      test(
        'cannot build stream config from burst layer',
            () {
          const ParticleEffectLayer layer =
          ParticleEffectLayer.burst(
            preset: preset,
          );

          expect(
                () => layer.buildStream(),
            throwsStateError,
          );
        },
      );

      test(
        'cannot build burst config from stream layer',
            () {
          const ParticleEffectLayer layer =
          ParticleEffectLayer.stream(
            preset: preset,
          );

          expect(
                () => layer.buildBurst(),
            throwsStateError,
          );
        },
      );
    },
  );
}