import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ParticleTexture textureA;
  late ParticleTexture textureB;

  setUp(() async {
    final Uint8List bytes =
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );

    textureA =
    await ParticleTexture.fromBytes(
      bytes,
    );

    textureB =
    await ParticleTexture.fromBytes(
      bytes,
    );
  });

  tearDown(() {
    if (!textureA.isDisposed) {
      textureA.dispose();
    }

    if (!textureB.isDisposed) {
      textureB.dispose();
    }
  });

  group(
    'ParticleTextureSet',
        () {
      test(
        'stores weighted variants',
            () {
          final ParticleTextureSet set =
          ParticleTextureSet(
            variants: <
                ParticleTextureVariant>[
              ParticleTextureVariant(
                texture: textureA,
                weight: 1,
              ),
              ParticleTextureVariant(
                texture: textureB,
                weight: 3,
              ),
            ],
          );

          expect(
            set.variants.length,
            2,
          );

          expect(
            set.variants[0].texture,
            same(textureA),
          );

          expect(
            set.variants[0].weight,
            1,
          );

          expect(
            set.variants[1].texture,
            same(textureB),
          );

          expect(
            set.variants[1].weight,
            3,
          );
        },
      );

      test(
        'variants collection is immutable',
            () {
          final ParticleTextureSet set =
          ParticleTextureSet(
            variants: <
                ParticleTextureVariant>[
              ParticleTextureVariant(
                texture: textureA,
              ),
            ],
          );

          expect(
                () => set.variants.add(
              ParticleTextureVariant(
                texture: textureB,
              ),
            ),
            throwsUnsupportedError,
          );
        },
      );

      test(
        'copies source variant list',
            () {
          final List<ParticleTextureVariant>
          source =
          <ParticleTextureVariant>[
            ParticleTextureVariant(
              texture: textureA,
            ),
          ];

          final ParticleTextureSet set =
          ParticleTextureSet(
            variants: source,
          );

          source.add(
            ParticleTextureVariant(
              texture: textureB,
            ),
          );

          expect(
            source.length,
            2,
          );

          expect(
            set.variants.length,
            1,
          );
        },
      );

      test(
        'single set always samples its texture',
            () {
          final ParticleTextureSet set =
          ParticleTextureSet.single(
            textureA,
          );

          final math.Random random =
          math.Random(
            42,
          );

          for (
          int i = 0;
          i < 100;
          i++
          ) {
            expect(
              set.sample(
                random,
              ),
              same(textureA),
            );
          }
        },
      );

      test(
        'weighted sampling favors larger weight',
            () {
          final ParticleTextureSet set =
          ParticleTextureSet(
            variants: <
                ParticleTextureVariant>[
              ParticleTextureVariant(
                texture: textureA,
                weight: 1,
              ),
              ParticleTextureVariant(
                texture: textureB,
                weight: 4,
              ),
            ],
          );

          final math.Random random =
          math.Random(
            42,
          );

          int countA = 0;
          int countB = 0;

          for (
          int i = 0;
          i < 2000;
          i++
          ) {
            final ParticleTexture sampled =
            set.sample(
              random,
            );

            if (identical(
              sampled,
              textureA,
            )) {
              countA++;
            } else if (identical(
              sampled,
              textureB,
            )) {
              countB++;
            }
          }

          expect(
            countA,
            greaterThan(0),
          );

          expect(
            countB,
            greaterThan(0),
          );

          expect(
            countB,
            greaterThan(
              countA * 2,
            ),
          );
        },
      );

      test(
        'rejects empty variant list',
            () {
          expect(
                () => ParticleTextureSet(
              variants: <
                  ParticleTextureVariant>[],
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'rejects non-positive weight',
            () {
          expect(
                () => ParticleTextureSet(
              variants: <
                  ParticleTextureVariant>[
                ParticleTextureVariant(
                  texture: textureA,
                  weight: 0,
                ),
              ],
            ),
            throwsAssertionError,
          );
        },
      );

      test(
        'rejects infinite weight',
            () {
          expect(
                () => ParticleTextureSet(
              variants: <
                  ParticleTextureVariant>[
                ParticleTextureVariant(
                  texture: textureA,
                  weight:
                  double.infinity,
                ),
              ],
            ),
            throwsArgumentError,
          );
        },
      );
    },
  );
}