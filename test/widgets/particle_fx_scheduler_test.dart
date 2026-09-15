import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ParticleTexture texture;
  late ParticleFxController controller;

  setUp(() async {
    final Uint8List bytes =
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );

    texture =
    await ParticleTexture.fromBytes(
      bytes,
    );

    controller =
        ParticleFxController();
  });

  tearDown(() {
    if (!controller.isDisposed) {
      controller.dispose();
    }

    if (!texture.isDisposed) {
      texture.dispose();
    }
  });

  Future<void> mountParticleFx(
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: ParticleFx(
              controller: controller,
            ),
          ),
        ),
      ),
    );

    // Prime the ticker so the next pump has a previous frame timestamp.
    await tester.pump();
  }

  ParticleCompositeEffect
  buildDelayedBurstEffect() {
    return ParticleCompositeEffect(
      layers: const <
          ParticleEffectLayer>[
        ParticleEffectLayer.burst(
          preset: ParticlePreset(),
          count: 10,
        ),
        ParticleEffectLayer.burst(
          preset: ParticlePreset(),
          count: 10,
          delay: Duration(
            milliseconds: 80,
          ),
        ),
        ParticleEffectLayer.burst(
          preset: ParticlePreset(),
          count: 10,
          delay: Duration(
            milliseconds: 250,
          ),
        ),
      ],
    );
  }

  group(
    'ParticleFx composite scheduler',
        () {
      testWidgets(
        'starts zero-delay layer immediately',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<String> events =
          <String>[];

          controller.play(
            buildDelayedBurstEffect(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onStarted: () {
                events.add(
                  'effect-started',
                );
              },
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  'layer-$index-started',
                );
              },
              onLayerCompleted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  'layer-$index-completed',
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 1,
            ),
          );

          expect(
            events,
            <String>[
              'effect-started',
              'layer-0-started',
              'layer-0-completed',
            ],
          );

          expect(
            controller
                .isCompositeActive,
            isTrue,
          );
        },
      );

      testWidgets(
        'delayed layer does not start before its delay',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<int> started =
          <int>[];

          controller.play(
            buildDelayedBurstEffect(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                started.add(
                  index,
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 79,
            ),
          );

          expect(
            started,
            <int>[
              0,
            ],
          );
        },
      );

      testWidgets(
        'delayed layer starts when delay is reached',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<int> started =
          <int>[];

          controller.play(
            buildDelayedBurstEffect(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                started.add(
                  index,
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 80,
            ),
          );

          expect(
            started,
            <int>[
              0,
              1,
            ],
          );
        },
      );

      testWidgets(
        'later delayed layer waits for its own delay',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<int> started =
          <int>[];

          controller.play(
            buildDelayedBurstEffect(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                started.add(
                  index,
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 80,
            ),
          );

          expect(
            started,
            <int>[
              0,
              1,
            ],
          );

          await tester.pump(
            const Duration(
              milliseconds: 100,
            ),
          );

          expect(
            started,
            <int>[
              0,
              1,
            ],
          );

          await tester.pump(
            const Duration(
              milliseconds: 70,
            ),
          );

          expect(
            started,
            <int>[
              0,
              1,
              2,
            ],
          );
        },
      );

      testWidgets(
        'pause freezes delayed layer countdown',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<int> started =
          <int>[];

          controller.play(
            ParticleCompositeEffect(
              layers: const <
                  ParticleEffectLayer>[
                ParticleEffectLayer.burst(
                  preset:
                  ParticlePreset(),
                  count: 10,
                  delay: Duration(
                    milliseconds: 100,
                  ),
                ),
              ],
            ),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                started.add(
                  index,
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 40,
            ),
          );

          expect(
            started,
            isEmpty,
          );

          controller.pause();

          await tester.pump(
            const Duration(
              milliseconds: 200,
            ),
          );

          expect(
            started,
            isEmpty,
          );

          controller.resume();

          await tester.pump(
            const Duration(
              milliseconds: 59,
            ),
          );

          expect(
            started,
            isEmpty,
          );

          await tester.pump(
            const Duration(
              milliseconds: 1,
            ),
          );

          expect(
            started,
            <int>[
              0,
            ],
          );
        },
      );

      testWidgets(
        'stop prevents delayed layers from starting',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<int> started =
          <int>[];

          controller.play(
            ParticleCompositeEffect(
              layers: const <
                  ParticleEffectLayer>[
                ParticleEffectLayer.burst(
                  preset:
                  ParticlePreset(),
                  count: 10,
                  delay: Duration(
                    milliseconds: 100,
                  ),
                ),
              ],
            ),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                started.add(
                  index,
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 40,
            ),
          );

          controller.stop();

          await tester.pump(
            const Duration(
              milliseconds: 200,
            ),
          );

          expect(
            started,
            isEmpty,
          );

          expect(
            controller
                .isCompositeActive,
            isFalse,
          );
        },
      );

      testWidgets(
        'finite stream completes its layer and composite',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<String> events =
          <String>[];

          controller.play(
            ParticleCompositeEffect(
              layers: const <
                  ParticleEffectLayer>[
                ParticleEffectLayer.stream(
                  preset:
                  ParticlePreset(),
                  particlesPerSecond:
                  30,
                  duration: Duration(
                    milliseconds: 100,
                  ),
                ),
              ],
            ),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onStarted: () {
                events.add(
                  'effect-started',
                );
              },
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  'layer-started',
                );
              },
              onLayerCompleted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  'layer-completed',
                );
              },
              onCompleted: () {
                events.add(
                  'effect-completed',
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 50,
            ),
          );

          expect(
            events,
            <String>[
              'effect-started',
              'layer-started',
            ],
          );

          await tester.pump(
            const Duration(
              milliseconds: 50,
            ),
          );

          expect(
            events,
            <String>[
              'effect-started',
              'layer-started',
              'layer-completed',
              'effect-completed',
            ],
          );

          expect(
            controller
                .isCompositeActive,
            isFalse,
          );
        },
      );

      testWidgets(
        'callback order follows delayed composite sequence',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<String> events =
          <String>[];

          controller.play(
            buildDelayedBurstEffect(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onStarted: () {
                events.add(
                  'effect-started',
                );
              },
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  '$index-start',
                );
              },
              onLayerCompleted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  '$index-complete',
                );
              },
              onCompleted: () {
                events.add(
                  'effect-completed',
                );
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 80,
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 100,
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 70,
            ),
          );

          expect(
            events,
            <String>[
              'effect-started',
              '0-start',
              '0-complete',
              '1-start',
              '1-complete',
              '2-start',
              '2-complete',
              'effect-completed',
            ],
          );

          expect(
            controller
                .isCompositeActive,
            isFalse,
          );
        },
      );

      testWidgets(
        'callback may stop composite safely',
            (
            WidgetTester tester,
            ) async {
          await mountParticleFx(
            tester,
          );

          final List<String> events =
          <String>[];

          controller.play(
            buildDelayedBurstEffect(),
            texture: texture,
            callbacks:
            ParticleCompositeCallbacks(
              onLayerStarted: (
                  int index,
                  ParticleEffectLayer layer,
                  ) {
                events.add(
                  'layer-$index',
                );

                if (index == 0) {
                  controller.stop();
                }
              },
            ),
          );

          await tester.pump(
            const Duration(
              milliseconds: 300,
            ),
          );

          expect(
            events,
            <String>[
              'layer-0',
            ],
          );

          expect(
            controller
                .isCompositeActive,
            isFalse,
          );
        },
      );
    },
  );
}