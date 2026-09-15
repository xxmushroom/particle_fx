import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:particle_fx/particle_fx.dart';

class _TestParticleForceState
    implements ParticleForceState {
  _TestParticleForceState();

  @override
  Offset position = Offset.zero;

  @override
  Offset velocity = Offset.zero;

  @override
  double size = 20;

  @override
  double rotation = 0;

  @override
  double angularVelocity = 0;

  @override
  double age = 0;

  @override
  double lifetime = 2;

  @override
  double get progress {
    if (lifetime <= 0) {
      return 1;
    }

    return (age / lifetime)
        .clamp(
      0.0,
      1.0,
    )
        .toDouble();
  }
}

class _CustomWindForce extends ParticleForce {
  const _CustomWindForce({
    this.acceleration = 100,
  });

  final double acceleration;

  @override
  void apply(
      ParticleForceState particle,
      double deltaTime,
      Size canvasSize,
      ) {
    particle.velocity += Offset(
      acceleration * deltaTime,
      0,
    );
  }
}

void main() {
  test(
    'custom ParticleForce can use only the public particle_fx API',
        () {
      final _TestParticleForceState particle =
      _TestParticleForceState();

      const ParticleForce force =
      _CustomWindForce(
        acceleration: 120,
      );

      force.apply(
        particle,
        0.5,
        const Size(
          800,
          600,
        ),
      );

      expect(
        particle.velocity,
        const Offset(
          60,
          0,
        ),
      );
    },
  );
}