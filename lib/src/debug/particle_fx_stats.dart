import 'package:flutter/foundation.dart';

/// A snapshot of the current ParticleFx runtime statistics.
///
/// Statistics are intended for diagnostics and development tooling.
/// They are periodically sampled rather than updated every frame.
@immutable
class ParticleFxStats {
  /// Creates a snapshot of particle runtime statistics.
  ///
  /// All counters and timing values default to zero.
  const ParticleFxStats({
    this.activeParticles = 0,
    this.maxParticles = 0,
    this.emittedParticles = 0,
    this.droppedParticles = 0,
    this.trailSamples = 0,
    this.estimatedDrawCalls = 0,
    this.fps = 0,
    this.frameTimeMs = 0,
  });

  /// Particles currently alive in the simulation.
  final int activeParticles;

  /// Maximum particle capacity of the engine.
  final int maxParticles;

  /// Total number of particles successfully emitted.
  final int emittedParticles;

  /// Particles that could not be emitted because capacity was full.
  final int droppedParticles;

  /// Historical trail samples currently stored by active particles.
  final int trailSamples;

  /// Approximate number of particle image draws required per frame.
  ///
  /// This is calculated as active particles plus their trail samples.
  final int estimatedDrawCalls;

  /// Observed ticker frame rate during the latest sampling window.
  final double fps;

  /// Average time between frames during the latest sampling window.
  final double frameTimeMs;

  /// Current engine capacity usage from 0 to 1.
  double get capacityUsage {
    if (maxParticles <= 0) {
      return 0;
    }

    return activeParticles /
        maxParticles;
  }
}