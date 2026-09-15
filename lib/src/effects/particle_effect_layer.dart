import '../config/particle_burst_config.dart';
import '../config/particle_stream_config.dart';
import '../presets/particle_preset.dart';
import '../textures/particle_texture.dart';
import '../textures/particle_texture_set.dart';

/// Identifies the emission type used by a [ParticleEffectLayer].
enum ParticleEffectLayerType {
  /// Emits a fixed number of particles once.
  burst,

  /// Emits particles continuously over time.
  stream,
}

/// One layer inside a [ParticleCompositeEffect].
///
/// Each layer is based on a reusable [ParticlePreset] and may start
/// immediately or after [delay].
class ParticleEffectLayer {
  /// Creates a one-shot burst layer.
  ///
  /// [count] determines how many particles are emitted and must be greater
  /// than zero.
  ///
  /// [delay] controls how long the composite waits before starting this
  /// layer.
  const ParticleEffectLayer.burst({
    required this.preset,
    this.count = 100,
    this.delay = Duration.zero,
  })  : assert(
  count > 0,
  'count must be greater than zero.',
  ),
        type =
            ParticleEffectLayerType.burst,
        particlesPerSecond = 0,
        duration = null,
        loop = false,
        loopDelay = Duration.zero;

  /// Creates a continuously emitting stream layer.
  ///
  /// [particlesPerSecond] must be greater than zero.
  ///
  /// When [loop] is true, [duration] must be provided. [loopDelay] controls
  /// the delay between repeated emission cycles.
  ///
  /// [delay] controls how long the composite waits before starting this
  /// layer.
  const ParticleEffectLayer.stream({
    required this.preset,
    this.particlesPerSecond = 60,
    this.duration,
    this.loop = false,
    this.loopDelay = Duration.zero,
    this.delay = Duration.zero,
  })  : assert(
  particlesPerSecond > 0,
  'particlesPerSecond must be greater than zero.',
  ),
        assert(
        !loop || duration != null,
        'A looping layer requires a duration.',
        ),
        type =
            ParticleEffectLayerType.stream,
        count = 0;

  /// Emission type represented by this layer.
  final ParticleEffectLayerType type;

  /// Preset used to construct this layer's particle configuration.
  final ParticlePreset preset;

  /// Time to wait after the composite starts before this layer begins.
  final Duration delay;

  /// Number of particles emitted by a burst layer.
  ///
  /// This value is zero for stream layers.
  final int count;

  /// Number of particles requested per second by a stream layer.
  ///
  /// This value is zero for burst layers.
  final double particlesPerSecond;

  /// Optional duration of a stream layer.
  ///
  /// When null, a stream continues until the composite is stopped manually.
  final Duration? duration;

  /// Whether a finite stream layer repeats after completing its duration.
  final bool loop;

  /// Delay between emission cycles of a looping stream layer.
  final Duration loopDelay;

  /// Whether this layer represents one burst.
  bool get isBurst =>
      type ==
          ParticleEffectLayerType.burst;

  /// Whether this layer represents continuous stream emission.
  bool get isStream =>
      type ==
          ParticleEffectLayerType.stream;

  /// Builds the burst configuration represented by this layer.
  ///
  /// Exactly one of [texture] or [textureSet] should be supplied.
  ///
  /// Throws a [StateError] when called on a stream layer.
  ParticleBurstConfig buildBurst({
    ParticleTexture? texture,
    ParticleTextureSet? textureSet,
  }) {
    if (!isBurst) {
      throw StateError(
        'Cannot build a burst config from a stream layer.',
      );
    }

    return preset.burst(
      texture: texture,
      textureSet: textureSet,
      count: count,
    );
  }

  /// Builds the stream configuration represented by this layer.
  ///
  /// Exactly one of [texture] or [textureSet] should be supplied.
  ///
  /// Throws a [StateError] when called on a burst layer.
  ParticleStreamConfig buildStream({
    ParticleTexture? texture,
    ParticleTextureSet? textureSet,
  }) {
    if (!isStream) {
      throw StateError(
        'Cannot build a stream config from a burst layer.',
      );
    }

    return preset.stream(
      texture: texture,
      textureSet: textureSet,
      particlesPerSecond:
      particlesPerSecond,
      duration: duration,
      loop: loop,
      loopDelay: loopDelay,
    );
  }
}