import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';

void main() {
  group(
    'ParticleLifetimeValue',
        () {
      test(
        'linear value evaluates begin and end',
            () {
          const ParticleLifetimeValue value =
          ParticleLifetimeValue(
            begin: 10,
            end: 20,
          );

          expect(
            value.evaluate(0),
            10,
          );

          expect(
            value.evaluate(1),
            20,
          );
        },
      );

      test(
        'linear value interpolates midpoint',
            () {
          const ParticleLifetimeValue value =
          ParticleLifetimeValue(
            begin: 10,
            end: 20,
          );

          expect(
            value.evaluate(0.5),
            15,
          );
        },
      );

      test(
        'progress is clamped to valid range',
            () {
          const ParticleLifetimeValue value =
          ParticleLifetimeValue(
            begin: 10,
            end: 20,
          );

          expect(
            value.evaluate(-10),
            10,
          );

          expect(
            value.evaluate(10),
            20,
          );
        },
      );

      test(
        'constant value never changes',
            () {
          const ParticleLifetimeValue value =
          ParticleLifetimeValue.constant(
            4.5,
          );

          expect(
            value.evaluate(0),
            4.5,
          );

          expect(
            value.evaluate(0.5),
            4.5,
          );

          expect(
            value.evaluate(1),
            4.5,
          );
        },
      );

      test(
        'curve transforms interpolation progress',
            () {
          const ParticleLifetimeValue value =
          ParticleLifetimeValue(
            begin: 0,
            end: 100,
            curve: Curves.easeIn,
          );

          final double expected =
              Curves.easeIn.transform(
                0.5,
              ) *
                  100;

          expect(
            value.evaluate(0.5),
            closeTo(
              expected,
              0.000001,
            ),
          );
        },
      );

      test(
        'pulse curve returns to beginning at end',
            () {
          const ParticleLifetimeValue value =
          ParticleLifetimeValue(
            begin: 0,
            end: 1,
            curve:
            ParticleLifetimeCurves
                .pulse,
          );

          expect(
            value.evaluate(0),
            closeTo(
              0,
              0.000001,
            ),
          );

          expect(
            value.evaluate(0.5),
            closeTo(
              1,
              0.000001,
            ),
          );

          expect(
            value.evaluate(1),
            closeTo(
              0,
              0.000001,
            ),
          );
        },
      );
    },
  );

  group(
    'ParticleColorOverLifetime',
        () {
      const Color begin =
      Color(0xFFFF0000);

      const Color end =
      Color(0xFF0000FF);

      test(
        'returns begin color at zero',
            () {
          const ParticleColorOverLifetime
          color =
          ParticleColorOverLifetime(
            begin: begin,
            end: end,
          );

          expect(
            color.evaluate(0),
            begin,
          );
        },
      );

      test(
        'returns end color at one',
            () {
          const ParticleColorOverLifetime
          color =
          ParticleColorOverLifetime(
            begin: begin,
            end: end,
          );

          expect(
            color.evaluate(1),
            end,
          );
        },
      );

      test(
        'linearly interpolates color',
            () {
          const ParticleColorOverLifetime
          color =
          ParticleColorOverLifetime(
            begin: begin,
            end: end,
          );

          expect(
            color.evaluate(0.5),
            Color.lerp(
              begin,
              end,
              0.5,
            ),
          );
        },
      );

      test(
        'color progress is clamped',
            () {
          const ParticleColorOverLifetime
          color =
          ParticleColorOverLifetime(
            begin: begin,
            end: end,
          );

          expect(
            color.evaluate(-5),
            begin,
          );

          expect(
            color.evaluate(5),
            end,
          );
        },
      );

      test(
        'constant color never changes',
            () {
          const Color fixed =
          Color(0xFF42A5F5);

          const ParticleColorOverLifetime
          color =
          ParticleColorOverLifetime
              .constant(
            fixed,
          );

          expect(
            color.evaluate(0),
            fixed,
          );

          expect(
            color.evaluate(0.5),
            fixed,
          );

          expect(
            color.evaluate(1),
            fixed,
          );
        },
      );

      test(
        'curve affects color interpolation',
            () {
          const ParticleColorOverLifetime
          color =
          ParticleColorOverLifetime(
            begin: begin,
            end: end,
            curve: Curves.easeIn,
          );

          final double transformed =
          Curves.easeIn.transform(
            0.5,
          );

          expect(
            color.evaluate(0.5),
            Color.lerp(
              begin,
              end,
              transformed,
            ),
          );
        },
      );
    },
  );
}