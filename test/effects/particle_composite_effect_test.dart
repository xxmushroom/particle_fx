import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';

void main() {
  const ParticlePreset preset =
  ParticlePreset();

  group(
    'ParticleCompositeEffect',
        () {
      test(
        'requires at least one layer',
            () {
          expect(
                () => ParticleCompositeEffect(
              layers:
              <ParticleEffectLayer>[],
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'rejects negative layer delay',
            () {
          expect(
                () => ParticleCompositeEffect(
              layers: const <
                  ParticleEffectLayer>[
                ParticleEffectLayer.burst(
                  preset: preset,
                  delay: Duration(
                    milliseconds: -1,
                  ),
                ),
              ],
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'accepts zero delay',
            () {
          final ParticleCompositeEffect
          effect =
          ParticleCompositeEffect(
            layers: const <
                ParticleEffectLayer>[
              ParticleEffectLayer.burst(
                preset: preset,
              ),
            ],
          );

          expect(
            effect.length,
            1,
          );
        },
      );

      test(
        'reports burst layers',
            () {
          final ParticleCompositeEffect
          effect =
          ParticleCompositeEffect(
            layers: const <
                ParticleEffectLayer>[
              ParticleEffectLayer.burst(
                preset: preset,
              ),
            ],
          );

          expect(
            effect.hasBurstLayers,
            isTrue,
          );

          expect(
            effect.hasStreamLayers,
            isFalse,
          );
        },
      );

      test(
        'reports stream layers',
            () {
          final ParticleCompositeEffect
          effect =
          ParticleCompositeEffect(
            layers: const <
                ParticleEffectLayer>[
              ParticleEffectLayer.stream(
                preset: preset,
              ),
            ],
          );

          expect(
            effect.hasBurstLayers,
            isFalse,
          );

          expect(
            effect.hasStreamLayers,
            isTrue,
          );
        },
      );

      test(
        'supports mixed layers',
            () {
          final ParticleCompositeEffect
          effect =
          ParticleCompositeEffect(
            layers: const <
                ParticleEffectLayer>[
              ParticleEffectLayer.burst(
                preset: preset,
                count: 80,
              ),
              ParticleEffectLayer.stream(
                preset: preset,
                particlesPerSecond: 35,
                duration: Duration(
                  seconds: 2,
                ),
                delay: Duration(
                  milliseconds: 250,
                ),
              ),
            ],
          );

          expect(
            effect.length,
            2,
          );

          expect(
            effect.hasBurstLayers,
            isTrue,
          );

          expect(
            effect.hasStreamLayers,
            isTrue,
          );

          expect(
            effect.layers[0].isBurst,
            isTrue,
          );

          expect(
            effect.layers[1].isStream,
            isTrue,
          );

          expect(
            effect.layers[1].delay,
            const Duration(
              milliseconds: 250,
            ),
          );
        },
      );

      test(
        'layers collection is immutable',
            () {
          final ParticleCompositeEffect
          effect =
          ParticleCompositeEffect(
            layers: const <
                ParticleEffectLayer>[
              ParticleEffectLayer.burst(
                preset: preset,
              ),
            ],
          );

          expect(
                () => effect.layers.add(
              const ParticleEffectLayer
                  .burst(
                preset: preset,
              ),
            ),
            throwsUnsupportedError,
          );
        },
      );

      test(
        'copies the source layer list',
            () {
          final List<ParticleEffectLayer>
          source =
          <ParticleEffectLayer>[
            const ParticleEffectLayer
                .burst(
              preset: preset,
            ),
          ];

          final ParticleCompositeEffect
          effect =
          ParticleCompositeEffect(
            layers: source,
          );

          source.add(
            const ParticleEffectLayer.stream(
              preset: preset,
            ),
          );

          expect(
            source.length,
            2,
          );

          expect(
            effect.length,
            1,
          );
        },
      );
    },
  );
}