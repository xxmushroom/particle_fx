// ignore_for_file: public_member_api_docs
import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui';

import '../config/particle_burst_config.dart';
import '../config/particle_spawn_config.dart';
import '../emitters/particle_emission.dart';
import '../appearance/particle_trail.dart';
import '../forces/particle_force.dart';
import 'particle.dart';

/// Runs the particle simulation.
class ParticleEngine {
  ParticleEngine({
    this.maxParticles = 5000,
    int? randomSeed,
  })  : assert(
  maxParticles > 0,
  'maxParticles must be greater than zero.',
  ),
        _random =
        math.Random(randomSeed) {
    particles =
        UnmodifiableListView<Particle>(
          _particles,
        );
  }

  final List<Particle> _particles =
  <Particle>[];

  final Map<
      Particle,
      List<ParticleForce>
  > _particleForces =
  <Particle, List<ParticleForce>>{};

  final math.Random _random;

  /// Maximum number of particles allowed at once.
  final int maxParticles;

  /// Read-only view of active particles.
  late final UnmodifiableListView<Particle>
  particles;

  int _emittedParticles = 0;
  int _droppedParticles = 0;

  int get particleCount =>
      _particles.length;

  int get emittedParticles =>
      _emittedParticles;

  int get droppedParticles =>
      _droppedParticles;

  int get trailSampleCount {
    int count = 0;

    for (final Particle particle
    in _particles) {
      count +=
          particle.trailSamples?.length ??
              0;
    }

    return count;
  }

  int get estimatedDrawCalls =>
      particleCount +
          trailSampleCount;

  bool get hasParticles => _particles.isNotEmpty;
  void spawn(
      ParticleSpawnConfig config,
      int count,
      Size canvasSize,
      ) {
    if (count <= 0) {
      return;
    }

    for (final texture
    in config.availableTextures) {
      if (texture.isDisposed) {
        throw StateError(
          'Cannot create particles using a disposed ParticleTexture.',
        );
      }
    }

    if (canvasSize.isEmpty) {
      return;
    }

    final int remainingCapacity =
        maxParticles -
            _particles.length;

    if (remainingCapacity <= 0) {
      _droppedParticles += count;
      return;
    }

    final int particlesToCreate =
    math.min(
      count,
      remainingCapacity,
    );

    final int dropped =
        count -
            particlesToCreate;

    if (dropped > 0) {
      _droppedParticles += dropped;
    }

    final List<ParticleForce> forces =
    List<ParticleForce>.unmodifiable(
      config.forces,
    );

    for (
    int index = 0;
    index < particlesToCreate;
    index++
    ) {
      final ParticleEmission emission =
      config.emitter.emit(
        _random,
        canvasSize,
      );

      final double speed =
      config.speed.sample(
        _random,
      );

      final Particle particle =
      Particle(
        texture:
        config.sampleTexture(
          _random,
        ),
        position:
        emission.position,
        velocity:
        emission.direction *
            speed,
        lifetime:
        config.lifetime.sample(
          _random,
        ),
        size:
        config.size.sample(
          _random,
        ),
        rotation:
        config.rotation.sample(
          _random,
        ),
        angularVelocity:
        config.angularVelocity
            .sample(
          _random,
        ),
        appearance:
        config.appearance,
      );

      _particles.add(
        particle,
      );

      _particleForces[particle] =
          forces;

      _emittedParticles++;
    }
  }
  /// Creates particles from [config].
  void spawnBurst(
      ParticleBurstConfig config,
      Size canvasSize,
      ) {
    spawn(
      config,
      config.count,
      canvasSize,
    );
  }

  /// Advances the simulation.
  bool update(
      double deltaTime,
      Size canvasSize,
      ) {
    if (_particles.isEmpty ||
        deltaTime <= 0) {
      return false;
    }

    final double safeDeltaTime =
    deltaTime.clamp(
      0.0,
      0.05,
    );

    for (
    final Particle particle
    in _particles
    ) {
      final List<ParticleForce>?
      forces =
      _particleForces[
      particle
      ];

      if (forces != null) {
        for (
        final ParticleForce force
        in forces
        ) {
          force.apply(
            particle,
            safeDeltaTime,
            canvasSize,
          );
        }
      }

      particle.age +=
          safeDeltaTime;

      particle.position +=
          particle.velocity *
              safeDeltaTime;

      particle.rotation +=
          particle.angularVelocity *
              safeDeltaTime;

      _updateTrail(
        particle,
        safeDeltaTime,
      );
    }

    _particles.removeWhere(
          (Particle particle) {
        if (!particle.isDead) {
          return false;
        }

        _particleForces.remove(
          particle,
        );

        return true;
      },
    );

    return true;
  }
  void _updateTrail(
      Particle particle,
      double deltaTime,
      ) {
    final ParticleTrail? trail =
        particle.appearance.trail;

    if (trail == null) {
      particle.trailSamples = null;
      particle.trailSampleAccumulator = 0;
      return;
    }

    particle.trailSampleAccumulator +=
        deltaTime;

    final double sampleInterval = trail.sampleInterval.inMicroseconds / Duration.microsecondsPerSecond;

    if (sampleInterval <= 0) {
      throw StateError(
        'ParticleTrail.sampleInterval must be greater than zero.',
      );
    }

    if (particle.trailSampleAccumulator <
        sampleInterval) {
      return;
    }

    particle.trailSampleAccumulator %=
        sampleInterval;

    final List<ParticleTrailSample> samples =
    particle.trailSamples ??=
    <ParticleTrailSample>[];

    samples.add(
      ParticleTrailSample(
        position: particle.position,
        rotation: particle.rotation,
        progress: particle.progress,
      ),
    );

    final int overflow =
        samples.length -
            trail.maxPoints;

    if (overflow > 0) {
      samples.removeRange(
        0,
        overflow,
      );
    }
  }
  /// Removes all active particles.
  void clear() {
    _particles.clear();
    _particleForces.clear();
  }
}