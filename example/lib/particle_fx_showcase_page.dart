import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:particle_fx/particle_fx.dart';

enum ShowcaseEffect {
  burst,
  gravity,
  wind,
  drag,
  attractor,
  repulsor,
  vortex,
  turbulence,
  curlNoise,
  shockwave,
  spring,
  bounce,
  buoyancy,

  pointerAttractor,
  pointerRepulsor,
  pointerVortex,

  vortexGravity,
}
enum ShowcaseEmitter {
  point,
  topLine,
  rectangle,
  circle,
  disc,
  cone,
}
enum ShowcaseTextureMode {
  single,
  weighted,
}

class _ShowcaseTextureEntry {
  _ShowcaseTextureEntry({
    required this.texture,
    required this.bytes,
  });

  final ParticleTexture texture;
  final Uint8List bytes;

  double weight = 1;
}

extension ShowcaseTextureModeInfo
on ShowcaseTextureMode {
  String get title {
    switch (this) {
      case ShowcaseTextureMode.single:
        return 'Single';

      case ShowcaseTextureMode.weighted:
        return 'Weighted';
    }
  }

  String get description {
    switch (this) {
      case ShowcaseTextureMode.single:
        return 'Use one image for every particle.';

      case ShowcaseTextureMode.weighted:
        return 'Randomly choose between several images using relative weights.';
    }
  }
}
enum ShowcasePreset {
  custom,
  fire,
  snow,
  confetti,
  magic,
  smoke,
  sparks,
  fireworks,
  fountain,
  rain,
  galaxy,
  explosion,
  bubbles,
}

extension ShowcasePresetInfo
on ShowcasePreset {
  String get title {
    switch (this) {
      case ShowcasePreset.custom:
        return 'Custom';

      case ShowcasePreset.fire:
        return 'Fire';

      case ShowcasePreset.snow:
        return 'Snow';

      case ShowcasePreset.confetti:
        return 'Confetti';

      case ShowcasePreset.magic:
        return 'Magic';

      case ShowcasePreset.smoke:
        return 'Smoke';

      case ShowcasePreset.sparks:
        return 'Sparks';

      case ShowcasePreset.fireworks:
        return 'Fireworks';

      case ShowcasePreset.fountain:
        return 'Fountain';

      case ShowcasePreset.rain:
        return 'Rain';

      case ShowcasePreset.galaxy:
        return 'Galaxy';

      case ShowcasePreset.explosion:
        return 'Explosion';

      case ShowcasePreset.bubbles:
        return 'Bubbles';
    }
  }

  String get description {
    switch (this) {
      case ShowcasePreset.custom:
        return 'Build the effect manually using the playground controls.';

      case ShowcasePreset.fire:
        return 'Rising flame particles with warm color, turbulence, buoyancy, and drag.';

      case ShowcasePreset.snow:
        return 'Soft particles falling from the top with gentle turbulence.';

      case ShowcasePreset.confetti:
        return 'Fast upward burst with gravity and strong particle rotation.';

      case ShowcasePreset.magic:
        return 'Glowing particles swirling around the center with short trails.';

      case ShowcasePreset.smoke:
        return 'Slow expanding particles drifting upward with turbulence.';

      case ShowcasePreset.sparks:
        return 'Fast glowing particles with gravity and short bright trails.';

      case ShowcasePreset.fireworks:
        return 'Bright radial burst with gravity and long glowing trails.';

      case ShowcasePreset.fountain:
        return 'A focused upward stream that arcs back down under gravity.';

      case ShowcasePreset.rain:
        return 'Fast particles emitted across the top with gravity, wind, and short trails.';

      case ShowcasePreset.galaxy:
        return 'Long-lived glowing particles orbiting through a vortex and turbulent field.';

      case ShowcasePreset.explosion:
        return 'A violent additive burst driven by a short shockwave impulse.';

      case ShowcasePreset.bubbles:
        return 'Soft expanding particles floating upward through gentle turbulence.';


    }
  }

  String? get codeName {
    switch (this) {
      case ShowcasePreset.custom:
        return null;

      case ShowcasePreset.fire:
        return 'fire';

      case ShowcasePreset.snow:
        return 'snow';

      case ShowcasePreset.confetti:
        return 'confetti';

      case ShowcasePreset.magic:
        return 'magic';

      case ShowcasePreset.smoke:
        return 'smoke';

      case ShowcasePreset.sparks:
        return 'sparks';

      case ShowcasePreset.fireworks:
        return 'fireworks';

      case ShowcasePreset.fountain:
        return 'fountain';

      case ShowcasePreset.rain:
        return 'rain';

      case ShowcasePreset.galaxy:
        return 'galaxy';

      case ShowcasePreset.explosion:
        return 'explosion';

      case ShowcasePreset.bubbles:
        return 'bubbles';
    }
  }

  String? get assetPath {
    switch (this) {
      case ShowcasePreset.custom:
        return null;

      case ShowcasePreset.fire:
        return 'assets/particles/fire.png';

      case ShowcasePreset.snow:
        return 'assets/particles/snow.png';

      case ShowcasePreset.confetti:
        return 'assets/particles/confetti.png';

      case ShowcasePreset.magic:
        return 'assets/particles/magic.png';

      case ShowcasePreset.smoke:
        return 'assets/particles/smoke.png';

      case ShowcasePreset.sparks:
        return 'assets/particles/sparks.png';

      case ShowcasePreset.fireworks:
        return 'assets/particles/fireworks.png';

      case ShowcasePreset.fountain:
        return 'assets/particles/sparks.png';

      case ShowcasePreset.rain:
        return 'assets/particles/rain.png';

      case ShowcasePreset.galaxy:
        return 'assets/particles/galaxy.png';

      case ShowcasePreset.explosion:
        return 'assets/particles/fireworks.png';

      case ShowcasePreset.bubbles:
        return 'assets/particles/bubbles.png';
    }
  }

  ParticlePreset? get preset {
    switch (this) {
      case ShowcasePreset.custom:
        return null;

      case ShowcasePreset.fire:
        return ParticlePresets.fire;

      case ShowcasePreset.snow:
        return ParticlePresets.snow;

      case ShowcasePreset.confetti:
        return ParticlePresets.confetti;

      case ShowcasePreset.magic:
        return ParticlePresets.magic;

      case ShowcasePreset.smoke:
        return ParticlePresets.smoke;

      case ShowcasePreset.sparks:
        return ParticlePresets.sparks;

      case ShowcasePreset.fireworks:
        return ParticlePresets.fireworks;

      case ShowcasePreset.fountain:
        return ParticlePresets.fountain;

      case ShowcasePreset.rain:
        return ParticlePresets.rain;

      case ShowcasePreset.galaxy:
        return ParticlePresets.galaxy;

      case ShowcasePreset.explosion:
        return ParticlePresets.explosion;

      case ShowcasePreset.bubbles:
        return ParticlePresets.bubbles;

    }
  }
}
enum ShowcaseComposite {
  megaExplosion,
  magicPortal,
  fireworkFinale,
  elementalStorm,
}

extension ShowcaseCompositeInfo
on ShowcaseComposite {
  String get title {
    switch (this) {
      case ShowcaseComposite.megaExplosion:
        return 'Mega Explosion';

      case ShowcaseComposite.magicPortal:
        return 'Magic Portal';

      case ShowcaseComposite.fireworkFinale:
        return 'Firework Finale';

      case ShowcaseComposite.elementalStorm:
        return 'Elemental Storm';
    }
  }

  String get description {
    switch (this) {
      case ShowcaseComposite.megaExplosion:
        return 'Explosion first, sparks 80 ms later, then lingering smoke after 250 ms.';

      case ShowcaseComposite.magicPortal:
        return 'Magic begins first, then a galaxy vortex joins after a short buildup.';

      case ShowcaseComposite.fireworkFinale:
        return 'Fireworks burst first, followed by delayed sparks and trailing smoke.';

      case ShowcaseComposite.elementalStorm:
        return 'Rain begins first, followed by fire and then a delayed magic layer.';
    }
  }
}
enum ShowcaseEmissionMode {
  burst,
  continuous,
}
enum ShowcaseStreamTiming {
  unlimited,
  timed,
}
enum ShowcaseOpacity {
  constant,
  fadeOut,
  fadeIn,
  fadeInOut,
}

enum ShowcaseScale {
  constant,
  shrink,
  grow,
  pulse,
}
enum ShowcaseColor {
  original,
  fire,
  ice,
  purple,
  green,
  sunset,
}

enum ShowcaseBlendMode {
  normal,
  additive,
}
enum ShowcaseTrail {
  none,
  short,
  medium,
  long,
}

extension ShowcaseTrailInfo on ShowcaseTrail {
  String get title {
    switch (this) {
      case ShowcaseTrail.none:
        return 'None';

      case ShowcaseTrail.short:
        return 'Short';

      case ShowcaseTrail.medium:
        return 'Medium';

      case ShowcaseTrail.long:
        return 'Long';
    }
  }
}
extension ShowcaseColorInfo
on ShowcaseColor {
  String get title {
    switch (this) {
      case ShowcaseColor.original:
        return 'Original';

      case ShowcaseColor.fire:
        return 'Fire';

      case ShowcaseColor.ice:
        return 'Ice';

      case ShowcaseColor.purple:
        return 'Purple';

      case ShowcaseColor.green:
        return 'Green';

      case ShowcaseColor.sunset:
        return 'Sunset';
    }
  }
}

extension ShowcaseBlendModeInfo
on ShowcaseBlendMode {
  String get title {
    switch (this) {
      case ShowcaseBlendMode.normal:
        return 'Normal';

      case ShowcaseBlendMode.additive:
        return 'Add';
    }
  }
}
extension ShowcaseOpacityInfo
on ShowcaseOpacity {
  String get title {
    switch (this) {
      case ShowcaseOpacity.constant:
        return 'Constant';

      case ShowcaseOpacity.fadeOut:
        return 'Fade out';

      case ShowcaseOpacity.fadeIn:
        return 'Fade in';

      case ShowcaseOpacity.fadeInOut:
        return 'Fade in/out';
    }
  }
}

extension ShowcaseScaleInfo
on ShowcaseScale {
  String get title {
    switch (this) {
      case ShowcaseScale.constant:
        return 'Constant';

      case ShowcaseScale.shrink:
        return 'Shrink';

      case ShowcaseScale.grow:
        return 'Grow';

      case ShowcaseScale.pulse:
        return 'Pulse';
    }
  }
}
extension ShowcaseEmissionModeInfo
on ShowcaseEmissionMode {
  String get title {
    switch (this) {
      case ShowcaseEmissionMode.burst:
        return 'Burst';

      case ShowcaseEmissionMode.continuous:
        return 'Continuous';
    }
  }

  String get description {
    switch (this) {
      case ShowcaseEmissionMode.burst:
        return 'Emit a fixed number of particles once.';

      case ShowcaseEmissionMode.continuous:
        return 'Keep emitting particles at a fixed rate.';
    }
  }
}
extension ShowcaseEmitterInfo
on ShowcaseEmitter {
  String get title {
    switch (this) {
      case ShowcaseEmitter.point:
        return 'Point';

      case ShowcaseEmitter.topLine:
        return 'Top line';

      case ShowcaseEmitter.rectangle:
        return 'Rectangle';

      case ShowcaseEmitter.circle:
        return 'Circle';

      case ShowcaseEmitter.cone:
        return 'Cone';
      case ShowcaseEmitter.disc:
        return 'Disc';
    }
  }

  String get description {
    switch (this) {
      case ShowcaseEmitter.point:
        return 'All particles start from the center.';

      case ShowcaseEmitter.topLine:
        return 'Particles spawn across the top edge.';

      case ShowcaseEmitter.rectangle:
        return 'Particles spawn throughout a rectangular area.';

      case ShowcaseEmitter.circle:
        return 'Particles spawn around a circle and launch outward.';

      case ShowcaseEmitter.cone:
        return 'Particles launch upward from a directional cone.';
      case ShowcaseEmitter.disc:
        return 'Particles spawn throughout a circular area.';
    }
  }
}
extension ShowcaseEffectInfo on ShowcaseEffect {
  String get title {
    switch (this) {
      case ShowcaseEffect.burst:
        return 'Burst';
      case ShowcaseEffect.gravity:
        return 'Gravity';
      case ShowcaseEffect.wind:
        return 'Wind';
      case ShowcaseEffect.drag:
        return 'Drag';
      case ShowcaseEffect.attractor:
        return 'Attractor';
      case ShowcaseEffect.repulsor:
        return 'Repulsor';
      case ShowcaseEffect.vortex:
        return 'Vortex';
      case ShowcaseEffect.vortexGravity:
        return 'Vortex + Gravity';
      case ShowcaseEffect.turbulence:
        return 'Turbulence';
      case ShowcaseEffect.shockwave:
        return 'Shockwave';
      case ShowcaseEffect.spring:
        return 'Spring';
      case ShowcaseEffect.bounce:
        return 'Bounce';
      case ShowcaseEffect.buoyancy:
        return 'Buoyancy';
      case ShowcaseEffect.curlNoise:
        return 'Curl Noise';
      case ShowcaseEffect.pointerAttractor:
        return 'Follow Attractor';
      case ShowcaseEffect.pointerRepulsor:
        return 'Follow Repulsor';
      case ShowcaseEffect.pointerVortex:
        return 'Follow Vortex';
    }
  }

  String get description {
    switch (this) {
      case ShowcaseEffect.burst:
        return 'Particles move outward in all directions.';
      case ShowcaseEffect.gravity:
        return 'Particles burst outward and then fall downward.';
      case ShowcaseEffect.wind:
        return 'Particles are continuously pushed to the right.';
      case ShowcaseEffect.drag:
        return 'Particles gradually lose speed after the burst.';
      case ShowcaseEffect.attractor:
        return 'Particles are pulled toward the center.';
      case ShowcaseEffect.repulsor:
        return 'Particles are pushed away from the center.';
      case ShowcaseEffect.vortex:
        return 'Particles spiral around the center.';
      case ShowcaseEffect.vortexGravity:
        return 'Particles spiral while gravity pulls them downward.';
      case ShowcaseEffect.turbulence:
        return 'Particles move through a smooth chaotic force field.';
      case ShowcaseEffect.shockwave:
        return 'A short pulse pushes particles away from the center.';
      case ShowcaseEffect.spring:
        return 'Particles are pulled toward the center like a spring.';
      case ShowcaseEffect.bounce:
        return 'Particles collide with and bounce off the preview edges.';
      case ShowcaseEffect.buoyancy:
        return 'Particles continuously float upward.';
      case ShowcaseEffect.curlNoise:
        return 'Particles flow through smooth swirling currents.';
      case ShowcaseEffect.pointerAttractor:
        return 'Move your finger in the preview and particles follow it.';
      case ShowcaseEffect.pointerRepulsor:
        return 'Move your finger to push nearby particles away.';
      case ShowcaseEffect.pointerVortex:
        return 'Move your finger to control the center of the vortex.';
    }
  }
}
extension ForceFalloffLabel on ForceFalloff {
  String get label {
    switch (this) {
      case ForceFalloff.constant:
        return 'Constant';

      case ForceFalloff.linear:
        return 'Linear';

      case ForceFalloff.inverse:
        return 'Inverse';

      case ForceFalloff.inverseSquare:
        return 'Inverse square';
    }
  }

  String get description {
    switch (this) {
      case ForceFalloff.constant:
        return 'Same force strength at every distance.';

      case ForceFalloff.linear:
        return 'Force gradually weakens with distance.';

      case ForceFalloff.inverse:
        return 'Strong nearby and smoothly weaker farther away.';

      case ForceFalloff.inverseSquare:
        return 'Very strong nearby and rapidly weaker with distance.';
    }
  }
}
class ParticleFxShowcasePage extends StatefulWidget {
  const ParticleFxShowcasePage({
    super.key,
  });

  @override
  State<ParticleFxShowcasePage> createState() =>
      _ParticleFxShowcasePageState();
}

class _ParticleFxShowcasePageState extends State<ParticleFxShowcasePage> {

  final ParticleFxController _controller = ParticleFxController();
  final ParticleForceTargetController _pointerTargetController = ParticleForceTargetController();
  ShowcaseEmitter _selectedEmitter = ShowcaseEmitter.point;
  ShowcaseEmissionMode _emissionMode = ShowcaseEmissionMode.burst;
  ShowcaseOpacity _opacityMode = ShowcaseOpacity.fadeOut;
  ShowcaseScale _scaleMode = ShowcaseScale.shrink;
  ShowcaseColor _colorMode = ShowcaseColor.original;
  ShowcaseBlendMode _selectedBlendMode = ShowcaseBlendMode.normal;
  ShowcaseTrail _trailMode = ShowcaseTrail.none;
  double _trailOpacity = 0.45;
  double _trailSampleIntervalMs = 40;
  double _particlesPerSecond = 60;

  ShowcaseStreamTiming _streamTiming = ShowcaseStreamTiming.unlimited;
  double _streamDurationSeconds = 2;
  bool _loopStream = false;
  double _loopDelaySeconds = 0.5;

  Offset? _pointerPosition;
  final ImagePicker _imagePicker =
  ImagePicker();
  final List<ParticleTexture> _ownedTextures =
  <ParticleTexture>[];

  final Map<String, _ShowcaseTextureEntry>
  _assetTextures =
  <String, _ShowcaseTextureEntry>{};

  final List<_ShowcaseTextureEntry> _weightedTextures =
  <_ShowcaseTextureEntry>[];
  ShowcaseTextureMode _textureMode = ShowcaseTextureMode.single;
  ParticleTexture? _selectedTexture;
  Uint8List? _selectedImageBytes;
  ShowcaseEffect _selectedEffect = ShowcaseEffect.gravity;
  ShowcasePreset _selectedPreset = ShowcasePreset.custom;
  ShowcaseComposite
  _selectedComposite =
      ShowcaseComposite
          .megaExplosion;

  final List<String>
  _compositeLifecycleLog =
  <String>[];
  double _particleCount = 200;
  double _effectStrength = 1;
  ForceFalloff _forceFalloff = ForceFalloff.constant;

  double _referenceDistance = 300;
  bool _loadingImage = false;

  bool get _hasTextureSelection {
    switch (_textureMode) {
      case ShowcaseTextureMode.single:
        return _selectedTexture != null;

      case ShowcaseTextureMode.weighted:
        return _weightedTextures.isNotEmpty;
    }
  }

  Uint8List? get _previewImageBytes {
    switch (_textureMode) {
      case ShowcaseTextureMode.single:
        return _selectedImageBytes;

      case ShowcaseTextureMode.weighted:
        if (_weightedTextures.isEmpty) {
          return null;
        }

        return _weightedTextures.first.bytes;
    }
  }

  double get _totalTextureWeight {
    double total = 0;

    for (final _ShowcaseTextureEntry entry
    in _weightedTextures) {
      total += entry.weight;
    }

    return total;
  }

  double _textureProbability(
      _ShowcaseTextureEntry entry,
      ) {
    final double total =
        _totalTextureWeight;

    if (total <= 0) {
      return 0;
    }

    return entry.weight / total;
  }

  ParticleTextureSet? _buildTextureSet() {
    if (_weightedTextures.isEmpty) {
      return null;
    }

    return ParticleTextureSet(
      variants: _weightedTextures
          .map(
            (_ShowcaseTextureEntry entry) =>
            ParticleTextureVariant(
              texture: entry.texture,
              weight: entry.weight,
            ),
      )
          .toList(),
    );
  }

  void _setTextureMode(
      ShowcaseTextureMode mode,
      ) {
    if (_textureMode == mode) {
      return;
    }

    if (_controller.isStreaming) {
      _controller.stop();
    }

    setState(() {
      if (mode ==
          ShowcaseTextureMode.weighted &&
          _weightedTextures.isEmpty &&
          _selectedTexture != null &&
          _selectedImageBytes != null) {
        _weightedTextures.add(
          _ShowcaseTextureEntry(
            texture: _selectedTexture!,
            bytes: _selectedImageBytes!,
          ),
        );
      }

      if (mode ==
          ShowcaseTextureMode.single &&
          _selectedTexture == null &&
          _weightedTextures.isNotEmpty) {
        _selectedTexture =
            _weightedTextures.first.texture;

        _selectedImageBytes =
            _weightedTextures.first.bytes;
      }

      _textureMode = mode;
    });
  }
  int get _trailMaxPoints {
    switch (_trailMode) {
      case ShowcaseTrail.none:
        return 0;

      case ShowcaseTrail.short:
        return 4;

      case ShowcaseTrail.medium:
        return 8;

      case ShowcaseTrail.long:
        return 12;
    }
  }

  double get _trailStartScale {
    switch (_trailMode) {
      case ShowcaseTrail.none:
        return 1;

      case ShowcaseTrail.short:
        return 0.75;

      case ShowcaseTrail.medium:
        return 0.55;

      case ShowcaseTrail.long:
        return 0.35;
    }
  }

  ParticleTrail? _buildTrail() {
    if (_trailMode ==
        ShowcaseTrail.none) {
      return null;
    }

    return ParticleTrail(
      maxPoints: _trailMaxPoints,
      sampleInterval: Duration(
        milliseconds:
        _trailSampleIntervalMs.round(),
      ),
      opacity: _trailOpacity,
      startScale: _trailStartScale,
    );
  }
  ParticleColorOverLifetime _buildColorOverLifetime() {
    switch (_colorMode) {
      case ShowcaseColor.original:
        return const ParticleColorOverLifetime
            .constant(
          Color(0xFFFFFFFF),
        );

      case ShowcaseColor.fire:
        return const ParticleColorOverLifetime(
          begin: Color(0xFFFFF59D),
          end: Color(0xFFFF3D00),
          curve: Curves.easeIn,
        );

      case ShowcaseColor.ice:
        return const ParticleColorOverLifetime(
          begin: Color(0xFFE3F2FD),
          end: Color(0xFF2196F3),
          curve: Curves.easeOut,
        );

      case ShowcaseColor.purple:
        return const ParticleColorOverLifetime(
          begin: Color(0xFFF3E5F5),
          end: Color(0xFF8E24AA),
          curve: Curves.easeInOut,
        );

      case ShowcaseColor.green:
        return const ParticleColorOverLifetime(
          begin: Color(0xFFE8F5E9),
          end: Color(0xFF43A047),
          curve: Curves.easeOut,
        );

      case ShowcaseColor.sunset:
        return const ParticleColorOverLifetime(
          begin: Color(0xFFFFF176),
          end: Color(0xFFE91E63),
          curve: Curves.easeInOut,
        );
    }
  }

  BlendMode _buildBlendMode() {
    switch (_selectedBlendMode) {
      case ShowcaseBlendMode.normal:
        return BlendMode.srcOver;

      case ShowcaseBlendMode.additive:
        return BlendMode.plus;
    }
  }
  ParticleAppearance _buildAppearance() {
    final ParticleLifetimeValue opacity;

    switch (_opacityMode) {
      case ShowcaseOpacity.constant:
        opacity =
        const ParticleLifetimeValue
            .constant(
          1,
        );

      case ShowcaseOpacity.fadeOut:
        opacity =
        const ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeOut,
        );

      case ShowcaseOpacity.fadeIn:
        opacity =
        const ParticleLifetimeValue(
          begin: 0,
          end: 1,
          curve: Curves.easeOut,
        );

      case ShowcaseOpacity.fadeInOut:
        opacity =
        const ParticleLifetimeValue(
          begin: 0,
          end: 1,
          curve:
          ParticleLifetimeCurves
              .pulse,
        );
    }

    final ParticleLifetimeValue scale;

    switch (_scaleMode) {
      case ShowcaseScale.constant:
        scale =
        const ParticleLifetimeValue
            .constant(
          1,
        );

      case ShowcaseScale.shrink:
        scale =
        const ParticleLifetimeValue(
          begin: 1,
          end: 0.35,
          curve: Curves.easeIn,
        );

      case ShowcaseScale.grow:
        scale =
        const ParticleLifetimeValue(
          begin: 0.35,
          end: 1.4,
          curve: Curves.easeOut,
        );

      case ShowcaseScale.pulse:
        scale =
        const ParticleLifetimeValue(
          begin: 0.65,
          end: 1.35,
          curve:
          ParticleLifetimeCurves
              .pulse,
        );
    }

    return ParticleAppearance(
      opacity: opacity,
      scale: scale,
      color: _buildColorOverLifetime(),
      blendMode: _buildBlendMode(),
      trail: _buildTrail(),
    );
  }
  ParticleEmitter _buildEmitter() {
    switch (_selectedEmitter) {
      case ShowcaseEmitter.point:
        return const PointEmitter(
          position: Alignment.center,
        );

      case ShowcaseEmitter.topLine:
        return const LineEmitter(
          start: Alignment.topLeft,
          end: Alignment.topRight,
          direction: ParticleRange(
            1.39,
            1.75,
          ),
        );

      case ShowcaseEmitter.rectangle:
        return const RectangleEmitter(
          topLeft: Alignment(
            -0.75,
            -0.65,
          ),
          bottomRight: Alignment(
            0.75,
            0.25,
          ),
        );

      case ShowcaseEmitter.circle:
        return const CircleEmitter(
          center: Alignment.center,
          radius: 90,
        );

      case ShowcaseEmitter.cone:
        return const ConeEmitter(
          position: Alignment(
            0,
            0.75,
          ),
          direction:
          -math.pi / 2,
          spread:
          math.pi / 3,
        );

      case ShowcaseEmitter.disc:
        return const DiscEmitter(
          center: Alignment.center,
          radius: 100,
          directionOffset:
          ParticleRange(
            -0.25,
            0.25,
          ),
        );
    }
  }
  Duration _durationFromSeconds(
      double seconds,
      ) {
    return Duration(
      milliseconds:
      (seconds * 1000).round(),
    );
  }

  String _durationCode(
      double seconds,
      ) {
    final int milliseconds =
    (seconds * 1000).round();

    if (milliseconds % 1000 == 0) {
      return 'const Duration(seconds: ${milliseconds ~/ 1000})';
    }

    return 'const Duration(milliseconds: $milliseconds)';
  }
  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }

    return value.toStringAsFixed(2);
  }

  String get _falloffCode {
    switch (_forceFalloff) {
      case ForceFalloff.constant:
        return 'ForceFalloff.constant';

      case ForceFalloff.linear:
        return 'ForceFalloff.linear';

      case ForceFalloff.inverse:
        return 'ForceFalloff.inverse';

      case ForceFalloff.inverseSquare:
        return 'ForceFalloff.inverseSquare';
    }
  }
  List<String> _buildForceCode() {
    switch (_selectedEffect) {
      case ShowcaseEffect.burst:
        return const <String>[];

      case ShowcaseEffect.gravity:
        return <String>[
                    '''
          GravityForce(
            acceleration: ${_formatNumber(700 * _effectStrength)},
          )''',
                  ];

                case ShowcaseEffect.wind:
                  return <String>[
                    '''
          WindForce(
            x: ${_formatNumber(350 * _effectStrength)},
          )''',
                  ];

                case ShowcaseEffect.drag:
                  return <String>[
                    '''
          DragForce(
            coefficient: ${_formatNumber(1.5 * _effectStrength)},
          )''',
        ];

      case ShowcaseEffect.attractor:
        return <String>[
                    '''
          AttractorForce(
            target: const ParticleForceTarget.alignment(
              Alignment.center,
            ),
            strength: ${_formatNumber(900 * _effectStrength)},
            falloff: $_falloffCode,
            referenceDistance: ${_formatNumber(_referenceDistance)},
          )''',
        ];

      case ShowcaseEffect.repulsor:
        return <String>[
                  '''
        RepulsorForce(
          target: const ParticleForceTarget.alignment(
            Alignment.center,
          ),
          strength: ${_formatNumber(1000 * _effectStrength)},
          falloff: $_falloffCode,
          referenceDistance: ${_formatNumber(_referenceDistance)},
        )''',
        ];

      case ShowcaseEffect.vortex:
        return <String>[
                  '''
        VortexForce(
          target: const ParticleForceTarget.alignment(
            Alignment.center,
          ),
          strength: ${_formatNumber(850 * _effectStrength)},
          inwardStrength: ${_formatNumber(120 * _effectStrength)},
          falloff: $_falloffCode,
          referenceDistance: ${_formatNumber(_referenceDistance)},
        )''',
        ];

      case ShowcaseEffect.turbulence:
        return <String>[
                  '''
        TurbulenceForce(
          strength: ${_formatNumber(220 * _effectStrength)},
          scale: 0.025,
          speed: 2.5,
        )''',
                  '''
        const DragForce(
          coefficient: 0.15,
        )''',
        ];

      case ShowcaseEffect.curlNoise:
        return <String>[
                  '''
        CurlNoiseForce(
          strength: ${_formatNumber(600 * _effectStrength)},
          scale: 0.012,
          speed: 1.2,
          octaves: 4,
          seed: 42,
        )''',
                  '''
        const DragForce(
          coefficient: 0.18,
        )''',
        ];

      case ShowcaseEffect.shockwave:
        return <String>[
                  '''
        ShockwaveForce(
          strength: ${_formatNumber(2200 * _effectStrength)},
          radius: 350,
          duration: 0.5,
        )''',
                  '''
        const DragForce(
          coefficient: 0.2,
        )''',
        ];

      case ShowcaseEffect.spring:
        return <String>[
                  '''
        SpringForce(
          stiffness: ${_formatNumber(4 * _effectStrength)},
          damping: 1.5,
        )''',
        ];

      case ShowcaseEffect.bounce:
        return <String>[
                  '''
        GravityForce(
          acceleration: ${_formatNumber(550 * _effectStrength)},
        )''',
                  '''
        const BounceForce(
          restitution: 0.8,
          padding: 4,
        )''',
                  '''
        const DragForce(
          coefficient: 0.08,
        )''',
        ];

      case ShowcaseEffect.buoyancy:
        return <String>[
                  '''
        BuoyancyForce(
          acceleration: ${_formatNumber(400 * _effectStrength)},
        )''',
                  '''
        TurbulenceForce(
          strength: ${_formatNumber(80 * _effectStrength)},
          scale: 0.02,
        )''',
                  '''
        const DragForce(
          coefficient: 0.2,
        )''',
        ];

      case ShowcaseEffect.pointerAttractor:
        return <String>[
                  '''
        AttractorForce(
          target: ParticleForceTarget.controller(
            targetController,
          ),
          strength: ${_formatNumber(1300 * _effectStrength)},
          deadZone: 12,
          falloff: $_falloffCode,
          referenceDistance: ${_formatNumber(_referenceDistance)},
        )''',
                  '''
        const DragForce(
          coefficient: 0.2,
        )''',
        ];

      case ShowcaseEffect.pointerRepulsor:
        return <String>[
                  '''
        RepulsorForce(
          target: ParticleForceTarget.controller(
            targetController,
          ),
          strength: ${_formatNumber(1600 * _effectStrength)},
          deadZone: 12,
          falloff: $_falloffCode,
          referenceDistance: ${_formatNumber(_referenceDistance)},
        )''',
                  '''
        const DragForce(
          coefficient: 0.12,
        )''',
        ];

      case ShowcaseEffect.pointerVortex:
        return <String>[
                  '''
        VortexForce(
          target: ParticleForceTarget.controller(
            targetController,
          ),
          strength: ${_formatNumber(1100 * _effectStrength)},
          inwardStrength: ${_formatNumber(220 * _effectStrength)},
          deadZone: 12,
          falloff: $_falloffCode,
          referenceDistance: ${_formatNumber(_referenceDistance)},
        )''',
                  '''
        const DragForce(
          coefficient: 0.12,
        )''',
        ];

      case ShowcaseEffect.vortexGravity:
        return <String>[
                    '''
          VortexForce(
            target: const ParticleForceTarget.alignment(
              Alignment.center,
            ),
            strength: ${_formatNumber(850 * _effectStrength)},
            inwardStrength: ${_formatNumber(120 * _effectStrength)},
            falloff: $_falloffCode,
            referenceDistance: ${_formatNumber(_referenceDistance)},
          )''',
                    '''
          GravityForce(
            acceleration: ${_formatNumber(350 * _effectStrength)},
          )''',
                    '''
          const DragForce(
            coefficient: 0.15,
          )''',
        ];
    }
  }
  String _buildEmitterCode() {
    switch (_selectedEmitter) {
      case ShowcaseEmitter.point:
        return '''
const PointEmitter(
  position: Alignment.center,
)''';

      case ShowcaseEmitter.topLine:
        return '''
const LineEmitter(
  start: Alignment.topLeft,
  end: Alignment.topRight,
  direction: ParticleRange(
    1.39,
    1.75,
  ),
)''';

      case ShowcaseEmitter.rectangle:
        return '''
const RectangleEmitter(
  topLeft: Alignment(
    -0.75,
    -0.65,
  ),
  bottomRight: Alignment(
    0.75,
    0.25,
  ),
)''';

      case ShowcaseEmitter.circle:
        return '''
const CircleEmitter(
  center: Alignment.center,
  radius: 90,
)''';

      case ShowcaseEmitter.disc:
        return '''
const DiscEmitter(
  center: Alignment.center,
  radius: 100,
  directionOffset: ParticleRange(
    -0.25,
    0.25,
  ),
)''';

      case ShowcaseEmitter.cone:
        return '''
const ConeEmitter(
  position: Alignment(
    0,
    0.75,
  ),
  direction: -math.pi / 2,
  spread: math.pi / 3,
)''';
    }
  }

  String _normalizeGeneratedCode(
      String code,
      ) {
    final List<String> lines =
    code.split('\n');

    while (lines.isNotEmpty &&
        lines.first.trim().isEmpty) {
      lines.removeAt(0);
    }

    while (lines.isNotEmpty &&
        lines.last.trim().isEmpty) {
      lines.removeLast();
    }

    if (lines.isEmpty) {
      return '';
    }

    int? minimumIndent;

    for (final String line in lines) {
      if (line.trim().isEmpty) {
        continue;
      }

      final int indent =
          line.length -
              line.trimLeft().length;

      if (minimumIndent == null ||
          indent < minimumIndent) {
        minimumIndent = indent;
      }
    }

    final int removeIndent =
        minimumIndent ?? 0;

    return lines.map(
          (String line) {
        if (line.trim().isEmpty) {
          return '';
        }

        return line.substring(
          removeIndent,
        );
      },
    ).join('\n');
  }

  String _formatNamedArgument(
      String name,
      String expression, {
        int indent = 4,
      }) {
    final String normalized =
    _normalizeGeneratedCode(
      expression,
    );

    final List<String> lines =
    normalized.split('\n');

    final String prefix =
    List<String>.filled(
      indent,
      ' ',
    ).join();

    if (lines.length == 1) {
      return '$prefix$name: ${lines.first},';
    }

    final StringBuffer buffer =
    StringBuffer(
      '$prefix$name: ${lines.first}',
    );

    for (int i = 1;
    i < lines.length;
    i++) {
      buffer.write(
        '\n$prefix${lines[i]}',
      );
    }

    buffer.write(',');

    return buffer.toString();
  }
  String _buildColorCode() {
    switch (_colorMode) {
      case ShowcaseColor.original:
        return '''
  ParticleColorOverLifetime.constant(
  Color(0xFFFFFFFF),
)''';

      case ShowcaseColor.fire:
        return '''
  ParticleColorOverLifetime(
  begin: Color(0xFFFFF59D),
  end: Color(0xFFFF3D00),
  curve: Curves.easeIn,
)''';

      case ShowcaseColor.ice:
        return '''
  ParticleColorOverLifetime(
  begin: Color(0xFFE3F2FD),
  end: Color(0xFF2196F3),
  curve: Curves.easeOut,
)''';

      case ShowcaseColor.purple:
        return '''
  ParticleColorOverLifetime(
  begin: Color(0xFFF3E5F5),
  end: Color(0xFF8E24AA),
  curve: Curves.easeInOut,
)''';

      case ShowcaseColor.green:
        return '''
  ParticleColorOverLifetime(
  begin: Color(0xFFE8F5E9),
  end: Color(0xFF43A047),
  curve: Curves.easeOut,
)''';

      case ShowcaseColor.sunset:
        return '''
  ParticleColorOverLifetime(
  begin: Color(0xFFFFF176),
  end: Color(0xFFE91E63),
  curve: Curves.easeInOut,
)''';
    }
  }

  String get _blendModeCode {
    switch (_selectedBlendMode) {
      case ShowcaseBlendMode.normal:
        return 'BlendMode.srcOver';

      case ShowcaseBlendMode.additive:
        return 'BlendMode.plus';
    }
  }
  String _buildTrailCode() {
    if (_trailMode ==
        ShowcaseTrail.none) {
      return '';
    }

    return '''
ParticleTrail(
  maxPoints: $_trailMaxPoints,
  sampleInterval: Duration(
    milliseconds: ${_trailSampleIntervalMs.round()},
  ),
  opacity: ${_formatNumber(_trailOpacity)},
  startScale: ${_formatNumber(_trailStartScale)},
)''';
  }
  String _buildAppearanceCode() {
    final String opacityCode;

    switch (_opacityMode) {
      case ShowcaseOpacity.constant:
        opacityCode = '''
ParticleLifetimeValue.constant(
  1,
)''';

      case ShowcaseOpacity.fadeOut:
        opacityCode = '''
ParticleLifetimeValue(
  begin: 1,
  end: 0,
  curve: Curves.easeOut,
)''';

      case ShowcaseOpacity.fadeIn:
        opacityCode = '''
ParticleLifetimeValue(
  begin: 0,
  end: 1,
  curve: Curves.easeOut,
)''';

      case ShowcaseOpacity.fadeInOut:
        opacityCode = '''
ParticleLifetimeValue(
  begin: 0,
  end: 1,
  curve: ParticleLifetimeCurves.pulse,
)''';
    }

    final String scaleCode;

    switch (_scaleMode) {
      case ShowcaseScale.constant:
        scaleCode = '''
ParticleLifetimeValue.constant(
  1,
)''';

      case ShowcaseScale.shrink:
        scaleCode = '''
ParticleLifetimeValue(
  begin: 1,
  end: 0.35,
  curve: Curves.easeIn,
)''';

      case ShowcaseScale.grow:
        scaleCode = '''
ParticleLifetimeValue(
  begin: 0.35,
  end: 1.4,
  curve: Curves.easeOut,
)''';

      case ShowcaseScale.pulse:
        scaleCode = '''
ParticleLifetimeValue(
  begin: 0.65,
  end: 1.35,
  curve: ParticleLifetimeCurves.pulse,
)''';
    }

    final String opacity =
    _formatNamedArgument(
      'opacity',
      opacityCode,
      indent: 2,
    );

    final String scale =
    _formatNamedArgument(
      'scale',
      scaleCode,
      indent: 2,
    );

    final String color =
    _formatNamedArgument(
      'color',
      _buildColorCode(),
      indent: 2,
    );

    final StringBuffer buffer =
    StringBuffer();

    buffer.writeln(
      'const ParticleAppearance(',
    );

    buffer.writeln(
      opacity,
    );

    buffer.writeln(
      scale,
    );

    buffer.writeln(
      color,
    );

    buffer.writeln(
      '  blendMode: $_blendModeCode,',
    );

    if (_trailMode !=
        ShowcaseTrail.none) {
      buffer.writeln(
        _formatNamedArgument(
          'trail',
          _buildTrailCode(),
          indent: 2,
        ),
      );
    }

    buffer.write(
      ')',
    );

    return buffer.toString();
  }

  String _buildForceListCode() {
    final List<String> forces =
    _buildForceCode();

    if (forces.isEmpty) {
      return 'const <ParticleForce>[]';
    }

    final StringBuffer buffer =
    StringBuffer(
      '<ParticleForce>[\n',
    );

    for (final String force in forces) {
      final List<String> lines =
      _normalizeGeneratedCode(
        force,
      ).split('\n');

      for (int i = 0;
      i < lines.length;
      i++) {
        final bool isLastLine =
            i == lines.length - 1;

        buffer.write(
          '  ${lines[i]}',
        );

        if (isLastLine) {
          buffer.write(',');
        }

        buffer.write('\n');
      }
    }

    buffer.write(']');

    return buffer.toString();
  }
  String _buildTextureSetCode() {
    final StringBuffer buffer =
    StringBuffer(
      'ParticleTextureSet(\n',
    );

    buffer.writeln(
      '  variants: <ParticleTextureVariant>[',
    );

    if (_weightedTextures.isEmpty) {
      buffer.writeln(
        '    // Add at least one texture.',
      );
    } else {
      for (
      int index = 0;
      index < _weightedTextures.length;
      index++
      ) {
        final _ShowcaseTextureEntry entry =
        _weightedTextures[index];

        buffer.writeln(
          '    ParticleTextureVariant(',
        );

        buffer.writeln(
          '      texture: textures[$index],',
        );

        buffer.writeln(
          '      weight: ${_formatNumber(entry.weight)},',
        );

        buffer.writeln(
          '    ),',
        );
      }
    }

    buffer.writeln(
      '  ],',
    );

    buffer.write(
      ')',
    );

    return buffer.toString();
  }
  String _buildStreamTimingCode() {
    if (_streamTiming ==
        ShowcaseStreamTiming.unlimited) {
      return '';
    }

    final StringBuffer buffer =
    StringBuffer();

    buffer.writeln(
      '    duration: ${_durationCode(_streamDurationSeconds)},',
    );

    if (_loopStream) {
      buffer.writeln(
        '    loop: true,',
      );

      buffer.writeln(
        '    loopDelay: ${_durationCode(_loopDelaySeconds)},',
      );
    }

    return buffer.toString();
  }
  String _buildCompositeGeneratedCode() {
    final String layers;

    switch (_selectedComposite) {
      case ShowcaseComposite
          .megaExplosion:
        layers = '''
    ParticleEffectLayer.burst(
      preset: ParticlePresets.explosion,
      count: 90,
    ),
    ParticleEffectLayer.burst(
  preset: ParticlePresets.sparks,
  count: 180,
  delay: const Duration(
    milliseconds: 80,
  ),
),
ParticleEffectLayer.stream(
  preset: ParticlePresets.smoke,
  particlesPerSecond: 35,
  duration: const Duration(
    seconds: 2,
  ),
  delay: const Duration(
    milliseconds: 250,
  ),
),''';

      case ShowcaseComposite
          .magicPortal:
        layers = '''
    ParticleEffectLayer.stream(
      preset: ParticlePresets.magic,
      particlesPerSecond: 65,
      duration: const Duration(
        seconds: 4,
      ),
    ),
    ParticleEffectLayer.stream(
  preset: ParticlePresets.galaxy,
  particlesPerSecond: 35,
  duration: const Duration(
    seconds: 3,
  ),
  delay: const Duration(
    milliseconds: 500,
  ),
),''';

      case ShowcaseComposite
          .fireworkFinale:
        layers = '''
    ParticleEffectLayer.burst(
      preset: ParticlePresets.fireworks,
      count: 220,
    ),
    ParticleEffectLayer.burst(
  preset: ParticlePresets.sparks,
  count: 120,
  delay: const Duration(
    milliseconds: 120,
  ),
),
ParticleEffectLayer.stream(
  preset: ParticlePresets.smoke,
  particlesPerSecond: 20,
  duration: const Duration(
    seconds: 2,
  ),
  delay: const Duration(
    milliseconds: 350,
  ),
),''';

      case ShowcaseComposite
          .elementalStorm:
        layers = '''
    ParticleEffectLayer.stream(
      preset: ParticlePresets.rain,
      particlesPerSecond: 75,
      duration: const Duration(
        seconds: 3,
      ),
    ),
    ParticleEffectLayer.stream(
      preset: ParticlePresets.fire,
      particlesPerSecond: 45,
      duration: const Duration(
        milliseconds: 2600,
      ),
      delay: const Duration(
        milliseconds: 400,
      ),
    ),
    ParticleEffectLayer.stream(
      preset: ParticlePresets.magic,
      particlesPerSecond: 30,
      duration: const Duration(
        seconds: 2,
      ),
      delay: const Duration(
        milliseconds: 900,
      ),
    ),''';
    }

    final String textureCode;

    if (_textureMode ==
        ShowcaseTextureMode.single) {
      textureCode =
      '  texture: texture,';
    } else {
      textureCode =
          _formatNamedArgument(
            'textureSet',
            _buildTextureSetCode(),
            indent: 2,
          );
    }

    return '''
final ParticleCompositeEffect effect =
    ParticleCompositeEffect(
  layers: <ParticleEffectLayer>[
$layers
  ],
);

controller.play(
  effect,
$textureCode
);''';
  }
  String _buildPresetGeneratedCode() {
    final String? presetName =
        _selectedPreset.codeName;

    if (presetName == null) {
      return '';
    }

    final String textureArgument;

    if (_textureMode ==
        ShowcaseTextureMode.single) {
      textureArgument =
      '    texture: texture,';
    } else {
      textureArgument =
          _formatNamedArgument(
            'textureSet',
            _buildTextureSetCode(),
          );
    }

    if (_isContinuous) {
      final String timingCode =
      _buildStreamTimingCode();

      return '''
controller.start(
  ParticlePresets.$presetName.stream(
$textureArgument
    particlesPerSecond: ${_formatNumber(_particlesPerSecond)},
$timingCode  ),
);''';
    }

    return '''
controller.burst(
  ParticlePresets.$presetName.burst(
$textureArgument
    count: ${_particleCount.round()},
  ),
);''';
  }
  String _buildGeneratedCode() {
    if (!_isCustomPreset) {
      return _buildPresetGeneratedCode();
    }

    final ParticleRange speed = _buildSpeedRange();
    final ParticleRange lifetime = _buildLifetimeRange();
    final String textureArgument;

    if (_textureMode ==
        ShowcaseTextureMode.single) {
      textureArgument =
      '    texture: texture,';
    } else {
      textureArgument =
          _formatNamedArgument(
            'textureSet',
            _buildTextureSetCode(),
          );
    }

    final String emitterArgument =
    _formatNamedArgument(
      'emitter',
      _buildEmitterCode(),
    );

    final String appearanceArgument =
    _formatNamedArgument(
      'appearance',
      _buildAppearanceCode(),
    );

    final String forcesArgument =
    _formatNamedArgument(
      'forces',
      _buildForceListCode(),
    );

    if (_isContinuous) {
      final String timingCode =
      _buildStreamTimingCode();

      return '''
controller.start(
  ParticleStreamConfig(
$textureArgument
    particlesPerSecond: ${_formatNumber(_particlesPerSecond)},
$timingCode$emitterArgument
    speed: const ParticleRange(
      ${_formatNumber(speed.min)},
      ${_formatNumber(speed.max)},
    ),
    size: const ParticleRange(
      24,
      58,
    ),
    lifetime: const ParticleRange(
      ${_formatNumber(lifetime.min)},
      ${_formatNumber(lifetime.max)},
    ),
$appearanceArgument
$forcesArgument
  ),
);''';
    }

    return '''
controller.burst(
  ParticleBurstConfig(
$textureArgument
    count: ${_particleCount.round()},
$emitterArgument
    speed: const ParticleRange(
      ${_formatNumber(speed.min)},
      ${_formatNumber(speed.max)},
    ),
    size: const ParticleRange(
      24,
      58,
    ),
    lifetime: const ParticleRange(
      ${_formatNumber(lifetime.min)},
      ${_formatNumber(lifetime.max)},
    ),
$appearanceArgument
$forcesArgument
  ),
);''';
  }
  Future<void>
  _copyCompositeGeneratedCode()
  async {
    await Clipboard.setData(
      ClipboardData(
        text:
        _buildCompositeGeneratedCode(),
      ),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Composite Dart code copied.',
        ),
        duration: Duration(
          seconds: 1,
        ),
      ),
    );
  }
  Future<void> _copyGeneratedCode() async {
    await Clipboard.setData(
      ClipboardData(
        text: _buildGeneratedCode(),
      ),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dart code copied.',
        ),
        duration: Duration(
          seconds: 1,
        ),
      ),
    );
  }
  bool get _isCustomPreset =>
      _selectedPreset ==
          ShowcasePreset.custom;

  ParticlePreset? get _activePreset =>
      _selectedPreset.preset;

  Future<void> _selectPreset(
      ShowcasePreset preset,
      ) async {
    _controller.stop();

    setState(() {
      _selectedPreset = preset;

      switch (preset) {
        case ShowcasePreset.custom:
          break;

        case ShowcasePreset.fire:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 80;

        case ShowcasePreset.snow:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 45;

        case ShowcasePreset.confetti:
          _emissionMode =
              ShowcaseEmissionMode.burst;
          _particleCount = 250;

        case ShowcasePreset.magic:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 70;

        case ShowcasePreset.smoke:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 45;

        case ShowcasePreset.sparks:
          _emissionMode =
              ShowcaseEmissionMode.burst;
          _particleCount = 160;

        case ShowcasePreset.fireworks:
          _emissionMode =
              ShowcaseEmissionMode.burst;
          _particleCount = 180;

        case ShowcasePreset.fountain:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 70;

        case ShowcasePreset.rain:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 110;

        case ShowcasePreset.galaxy:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 55;

        case ShowcasePreset.explosion:
          _emissionMode =
              ShowcaseEmissionMode.burst;
          _particleCount = 140;

        case ShowcasePreset.bubbles:
          _emissionMode =
              ShowcaseEmissionMode.continuous;
          _particlesPerSecond = 45;
      }
    });

    await _loadPresetTexture(
      preset,
    );
  }
  bool get _isContinuous =>
      _emissionMode ==
          ShowcaseEmissionMode.continuous;

  bool get _isStreamRunning =>
      _controller.isStreaming &&
          !_controller.isStreamPaused;

  bool get _isStreamPaused =>
      _controller.isStreaming &&
          _controller.isStreamPaused;

  bool get _supportsFalloff {
    return _selectedEffect ==
        ShowcaseEffect.attractor ||
        _selectedEffect ==
            ShowcaseEffect.repulsor ||
        _selectedEffect ==
            ShowcaseEffect.vortex ||
        _selectedEffect ==
            ShowcaseEffect.pointerAttractor ||
        _selectedEffect ==
            ShowcaseEffect.pointerRepulsor ||
        _selectedEffect ==
            ShowcaseEffect.pointerVortex ||
        _selectedEffect ==
            ShowcaseEffect.vortexGravity;
  }
  List<String> get _activeForceNames {
    switch (_selectedEffect) {
      case ShowcaseEffect.burst:
        return const [];

      case ShowcaseEffect.gravity:
        return const [
          'GravityForce',
        ];

      case ShowcaseEffect.wind:
        return const [
          'WindForce',
        ];

      case ShowcaseEffect.drag:
        return const [
          'DragForce',
        ];

      case ShowcaseEffect.attractor:
        return const [
          'AttractorForce',
        ];

      case ShowcaseEffect.repulsor:
        return const [
          'RepulsorForce',
        ];

      case ShowcaseEffect.vortex:
        return const [
          'VortexForce',
        ];

      case ShowcaseEffect.turbulence:
        return const [
          'TurbulenceForce',
          'DragForce',
        ];

      case ShowcaseEffect.curlNoise:
        return const [
          'CurlNoiseForce',
          'DragForce',
        ];

      case ShowcaseEffect.shockwave:
        return const [
          'ShockwaveForce',
          'DragForce',
        ];

      case ShowcaseEffect.spring:
        return const [
          'SpringForce',
        ];

      case ShowcaseEffect.bounce:
        return const [
          'GravityForce',
          'BounceForce',
          'DragForce',
        ];

      case ShowcaseEffect.buoyancy:
        return const [
          'BuoyancyForce',
          'TurbulenceForce',
          'DragForce',
        ];

      case ShowcaseEffect.pointerAttractor:
        return const [
          'AttractorForce',
          'DragForce',
        ];

      case ShowcaseEffect.pointerRepulsor:
        return const [
          'RepulsorForce',
          'DragForce',
        ];

      case ShowcaseEffect.pointerVortex:
        return const [
          'VortexForce',
          'DragForce',
        ];

      case ShowcaseEffect.vortexGravity:
        return const [
          'VortexForce',
          'GravityForce',
          'DragForce',
        ];
    }
  }
  bool get _usesPointerTarget {
    return _selectedEffect ==
        ShowcaseEffect.pointerAttractor ||
        _selectedEffect ==
            ShowcaseEffect.pointerRepulsor ||
        _selectedEffect ==
            ShowcaseEffect.pointerVortex;
  }
  void _updatePointerTarget(
      Offset position,
      ) {
    _pointerTargetController.update(
      position,
    );

    setState(() {
      _pointerPosition = position;
    });
  }
  Future<_ShowcaseTextureEntry> _loadAssetTexture(
      String assetPath,
      ) async {
    final _ShowcaseTextureEntry? cachedEntry =
    _assetTextures[assetPath];

    if (cachedEntry != null) {
      return cachedEntry;
    }

    final ByteData data =
    await rootBundle.load(
      assetPath,
    );

    final Uint8List bytes =
    data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    final ParticleTexture texture =
    await ParticleTexture.fromBytes(
      bytes,
    );

    if (!mounted) {
      texture.dispose();

      throw StateError(
        'Showcase was disposed while loading $assetPath.',
      );
    }

    final _ShowcaseTextureEntry entry =
    _ShowcaseTextureEntry(
      texture: texture,
      bytes: bytes,
    );

    _ownedTextures.add(
      texture,
    );

    _assetTextures[assetPath] =
        entry;

    return entry;
  }
  Future<void> _loadPresetTexture(
      ShowcasePreset preset,
      ) async {
    final String? assetPath =
        preset.assetPath;

    if (assetPath == null) {
      return;
    }

    if (mounted) {
      setState(() {
        _loadingImage = true;
      });
    }

    try {
      final _ShowcaseTextureEntry entry =
      await _loadAssetTexture(
        assetPath,
      );

      if (!mounted ||
          _selectedPreset != preset) {
        return;
      }

      setState(() {
        _textureMode =
            ShowcaseTextureMode.single;

        _selectedTexture =
            entry.texture;

        _selectedImageBytes =
            entry.bytes;
      });
    } catch (error) {
      if (!mounted ||
          _selectedPreset != preset) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not load preset image: $error',
          ),
        ),
      );
    } finally {
      if (mounted &&
          _selectedPreset == preset) {
        setState(() {
          _loadingImage = false;
        });
      }
    }
  }
  Future<void> _loadShowcaseTexture(
      String assetPath,
      ) async {
    if (_loadingImage) {
      return;
    }

    if (_controller.isStreaming) {
      _controller.stop();
    }

    setState(() {
      _loadingImage = true;
    });

    try {
      final _ShowcaseTextureEntry entry =
      await _loadAssetTexture(
        assetPath,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _textureMode =
            ShowcaseTextureMode.single;

        _selectedTexture =
            entry.texture;

        _selectedImageBytes =
            entry.bytes;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not load showcase image: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingImage = false;
        });
      }
    }
  }
  Future<void> _pickImage() async {
    if (_loadingImage) {
      return;
    }

    setState(() {
      _loadingImage = true;
    });

    try {
      final XFile? file =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (file == null) {
        return;
      }

      final Uint8List bytes =
      await file.readAsBytes();

      final ParticleTexture texture =
      await ParticleTexture.fromBytes(
        bytes,
      );

      if (!mounted) {
        texture.dispose();
        return;
      }

      _ownedTextures.add(texture);

      setState(() {
        _selectedTexture = texture;
        _selectedImageBytes = bytes;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not load image: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingImage = false;
        });
      }
    }
  }
  Future<void> _addWeightedImages() async {
    if (_loadingImage) {
      return;
    }

    setState(() {
      _loadingImage = true;
    });

    try {
      final List<XFile> files =
      await _imagePicker.pickMultiImage();

      if (files.isEmpty) {
        return;
      }

      final List<_ShowcaseTextureEntry>
      newEntries =
      <_ShowcaseTextureEntry>[];

      for (final XFile file in files) {
        try {
          final Uint8List bytes =
          await file.readAsBytes();

          final ParticleTexture texture =
          await ParticleTexture.fromBytes(
            bytes,
          );

          if (!mounted) {
            texture.dispose();
            continue;
          }

          _ownedTextures.add(
            texture,
          );

          newEntries.add(
            _ShowcaseTextureEntry(
              texture: texture,
              bytes: bytes,
            ),
          );
        } catch (_) {
          // Skip individual files that cannot be decoded.
        }
      }

      if (!mounted) {
        return;
      }

      if (newEntries.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'No valid images could be loaded.',
            ),
          ),
        );

        return;
      }

      setState(() {
        _weightedTextures.addAll(
          newEntries,
        );
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not load images: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingImage = false;
        });
      }
    }
  }
  List<ParticleForce> _buildForces() {
    switch (_selectedEffect) {
      case ShowcaseEffect.burst:
        return const <ParticleForce>[];

      case ShowcaseEffect.gravity:
        return <ParticleForce>[
          GravityForce(
            acceleration:
            700 * _effectStrength,
          ),
        ];

      case ShowcaseEffect.wind:
        return <ParticleForce>[
          WindForce(
            x: 350 * _effectStrength,
          ),
        ];

      case ShowcaseEffect.drag:
        return <ParticleForce>[
          DragForce(
            coefficient:
            1.5 * _effectStrength,
          ),
        ];

      case ShowcaseEffect.attractor:
        return <ParticleForce>[
          AttractorForce(
            target:
            const ParticleForceTarget.alignment(
              Alignment.center,
            ),
            strength:
            900 * _effectStrength,
            falloff: _forceFalloff,
            referenceDistance:
            _referenceDistance,
          ),
        ];

      case ShowcaseEffect.repulsor:
        return <ParticleForce>[
          RepulsorForce(
            target:
            const ParticleForceTarget.alignment(
              Alignment.center,
            ),
            strength:
            1000 * _effectStrength,
            falloff: _forceFalloff,
            referenceDistance:
            _referenceDistance,
          ),
        ];

      case ShowcaseEffect.vortex:
        return <ParticleForce>[
          VortexForce(
            target:
            const ParticleForceTarget.alignment(
              Alignment.center,
            ),
            strength:
            850 * _effectStrength,
            inwardStrength:
            120 * _effectStrength,
            falloff: _forceFalloff,
            referenceDistance:
            _referenceDistance,
          ),
        ];

      case ShowcaseEffect.vortexGravity:
        return <ParticleForce>[
          VortexForce(
            target:
            const ParticleForceTarget.alignment(
              Alignment.center,
            ),
            strength:
            850 * _effectStrength,
            inwardStrength:
            120 * _effectStrength,
            falloff: _forceFalloff,
            referenceDistance:
            _referenceDistance,
          ),
          GravityForce(
            acceleration:
            350 * _effectStrength,
          ),
          const DragForce(
            coefficient: 0.15,
          ),
        ];
      case ShowcaseEffect.turbulence:
        return <ParticleForce>[
          TurbulenceForce(
            strength:
            220 * _effectStrength,
            scale: 0.025,
            speed: 2.5,
          ),
          const DragForce(
            coefficient: 0.15,
          ),
        ];

      case ShowcaseEffect.shockwave:
        return <ParticleForce>[
          ShockwaveForce(
            strength:
            2200 * _effectStrength,
            radius: 350,
            duration: 0.5,
          ),
          const DragForce(
            coefficient: 0.2,
          ),
        ];

      case ShowcaseEffect.spring:
        return <ParticleForce>[
          SpringForce(
            stiffness:
            4 * _effectStrength,
            damping: 1.5,
          ),
        ];

      case ShowcaseEffect.bounce:
        return <ParticleForce>[
          GravityForce(
            acceleration:
            550 * _effectStrength,
          ),
          const BounceForce(
            restitution: 0.8,
            padding: 4,
          ),
          const DragForce(
            coefficient: 0.08,
          ),
        ];

      case ShowcaseEffect.buoyancy:
        return <ParticleForce>[
          BuoyancyForce(
            acceleration:
            400 * _effectStrength,
          ),
          TurbulenceForce(
            strength:
            80 * _effectStrength,
            scale: 0.02,
          ),
          const DragForce(
            coefficient: 0.2,
          ),
        ];
      case ShowcaseEffect.curlNoise:
        return <ParticleForce>[
          CurlNoiseForce(
            strength:
            600 * _effectStrength,
            scale: 0.012,
            speed: 1.2,
            octaves: 4,
            seed: 42,
          ),
          const DragForce(
            coefficient: 0.18,
          ),
        ];
      case ShowcaseEffect.pointerAttractor:
        return <ParticleForce>[
          AttractorForce(
            target:
            ParticleForceTarget.controller(
              _pointerTargetController,
            ),
            strength:
            1300 * _effectStrength,
            deadZone: 12,
            falloff: _forceFalloff,
            referenceDistance:
            _referenceDistance,
          ),
          const DragForce(
            coefficient: 0.2,
          ),
        ];

      case ShowcaseEffect.pointerRepulsor:
        return <ParticleForce>[
          RepulsorForce(
            target:
            ParticleForceTarget.controller(
              _pointerTargetController,
            ),
            strength:
            1600 * _effectStrength,
            deadZone: 12,
            falloff: _forceFalloff,
            referenceDistance:
            _referenceDistance,
          ),
          const DragForce(
            coefficient: 0.12,
          ),
        ];

      case ShowcaseEffect.pointerVortex:
        return <ParticleForce>[
          VortexForce(
            target:
            ParticleForceTarget.controller(
              _pointerTargetController,
            ),
            strength:
            1100 * _effectStrength,
            inwardStrength:
            220 * _effectStrength,
            deadZone: 12,
            falloff: _forceFalloff,
            referenceDistance:
            _referenceDistance,
          ),
          const DragForce(
            coefficient: 0.12,
          ),
        ];
    }
  }
  ParticleRange _buildLifetimeRange() {
    switch (_selectedEffect) {
      case ShowcaseEffect.curlNoise:
        return const ParticleRange(
          4,
          7,
        );

      case ShowcaseEffect.turbulence:
        return const ParticleRange(
          3,
          6,
        );

      default:
        return const ParticleRange(
          2,
          4,
        );
    }
  }
  ParticleRange _buildSpeedRange() {
    switch (_selectedEffect) {
      case ShowcaseEffect.curlNoise:
        return ParticleRange(
          80 * _effectStrength,
          220 * _effectStrength,
        );

      case ShowcaseEffect.turbulence:
        return ParticleRange(
          100 * _effectStrength,
          300 * _effectStrength,
        );

      case ShowcaseEffect.spring:
        return ParticleRange(
          250 * _effectStrength,
          550 * _effectStrength,
        );

      default:
        return ParticleRange(
          180 * _effectStrength,
          650 * _effectStrength,
        );
    }
  }
  void _addCompositeLifecycleLog(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    setState(() {
      _compositeLifecycleLog.add(
        message,
      );

      if (_compositeLifecycleLog.length >
          12) {
        _compositeLifecycleLog
            .removeAt(0);
      }
    });
  }
  ParticleCompositeEffect
  _buildCompositeEffect() {
    switch (_selectedComposite) {
      case ShowcaseComposite
          .megaExplosion:
        return ParticleCompositeEffect(
          layers: <ParticleEffectLayer>[
            ParticleEffectLayer.burst(
              preset:
              ParticlePresets
                  .explosion,
              count: 90,
            ),
            ParticleEffectLayer.burst(
              preset:
              ParticlePresets
                  .sparks,
              count: 180,
              delay:
              const Duration(
                milliseconds: 80,
              ),
            ),
            ParticleEffectLayer.stream(
              preset:
              ParticlePresets
                  .smoke,
              particlesPerSecond: 35,
              duration:
              const Duration(
                seconds: 2,
              ),
              delay:
              const Duration(
                milliseconds: 250,
              ),
            ),
          ],
        );

      case ShowcaseComposite
          .magicPortal:
        return ParticleCompositeEffect(
          layers: <ParticleEffectLayer>[
            ParticleEffectLayer.stream(
              preset:
              ParticlePresets
                  .magic,
              particlesPerSecond: 65,
              duration:
              const Duration(
                seconds: 4,
              ),
            ),
            ParticleEffectLayer.stream(
              preset:
              ParticlePresets
                  .galaxy,
              particlesPerSecond: 35,
              duration:
              const Duration(
                seconds: 3,
              ),
              delay:
              const Duration(
                milliseconds: 500,
              ),
            ),
          ],
        );

      case ShowcaseComposite
          .fireworkFinale:
        return ParticleCompositeEffect(
          layers: <ParticleEffectLayer>[
            ParticleEffectLayer.burst(
              preset:
              ParticlePresets
                  .fireworks,
              count: 220,
            ),
            ParticleEffectLayer.burst(
              preset:
              ParticlePresets
                  .sparks,
              count: 120,
              delay:
              const Duration(
                milliseconds: 120,
              ),
            ),
            ParticleEffectLayer.stream(
              preset:
              ParticlePresets
                  .smoke,
              particlesPerSecond: 20,
              duration:
              const Duration(
                seconds: 2,
              ),
              delay:
              const Duration(
                milliseconds: 350,
              ),
            ),
          ],
        );

      case ShowcaseComposite
          .elementalStorm:
        return ParticleCompositeEffect(
          layers: <ParticleEffectLayer>[
            ParticleEffectLayer.stream(
              preset:
              ParticlePresets
                  .rain,
              particlesPerSecond: 75,
              duration:
              const Duration(
                seconds: 3,
              ),
            ),
            ParticleEffectLayer.stream(
              preset:
              ParticlePresets
                  .fire,
              particlesPerSecond: 45,
              duration:
              const Duration(
                milliseconds: 2600,
              ),
              delay:
              const Duration(
                milliseconds: 400,
              ),
            ),
            ParticleEffectLayer.stream(
              preset:
              ParticlePresets
                  .magic,
              particlesPerSecond: 30,
              duration:
              const Duration(
                seconds: 2,
              ),
              delay:
              const Duration(
                milliseconds: 900,
              ),
            ),
          ],
        );
    }
  }
  void _runCompositeEffect() {
    final ParticleTexture? texture =
    _textureMode ==
        ShowcaseTextureMode.single
        ? _selectedTexture
        : null;

    final ParticleTextureSet? textureSet =
    _textureMode ==
        ShowcaseTextureMode.weighted
        ? _buildTextureSet()
        : null;

    if (texture == null &&
        textureSet == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _textureMode ==
                ShowcaseTextureMode.single
                ? 'Choose an image first.'
                : 'Add at least one weighted image first.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _compositeLifecycleLog.clear();
    });

    _controller.play(
      _buildCompositeEffect(),
      texture: texture,
      textureSet: textureSet,
      callbacks:
      ParticleCompositeCallbacks(
        onStarted: () {
          _addCompositeLifecycleLog(
            'Effect started',
          );
        },
        onLayerStarted: (
            int index,
            ParticleEffectLayer layer,
            ) {
          _addCompositeLifecycleLog(
            'Layer ${index + 1} started • '
                '${layer.isBurst ? 'Burst' : 'Stream'}',
          );
        },
        onLayerCompleted: (
            int index,
            ParticleEffectLayer layer,
            ) {
          _addCompositeLifecycleLog(
            'Layer ${index + 1} completed • '
                '${layer.isBurst ? 'Burst' : 'Stream'}',
          );
        },
        onCompleted: () {
          _addCompositeLifecycleLog(
            'Effect completed',
          );
        },
      ),
    );
  }
  void _runEffect() {
    final ParticleTexture? texture =
    _textureMode ==
        ShowcaseTextureMode.single
        ? _selectedTexture
        : null;

    final ParticleTextureSet? textureSet =
    _textureMode ==
        ShowcaseTextureMode.weighted
        ? _buildTextureSet()
        : null;

    if (texture == null &&
        textureSet == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _textureMode ==
                ShowcaseTextureMode.single
                ? 'Choose an image first.'
                : 'Add at least one weighted image first.',
          ),
        ),
      );

      return;
    }

    final ParticlePreset? preset =
        _activePreset;

    if (preset != null) {
      if (_isContinuous) {
        _controller.start(
          preset.stream(
            texture: texture,
            textureSet: textureSet,
            particlesPerSecond:
            _particlesPerSecond,
            duration:
            _streamTiming ==
                ShowcaseStreamTiming.timed
                ? _durationFromSeconds(
              _streamDurationSeconds,
            )
                : null,
            loop:
            _streamTiming ==
                ShowcaseStreamTiming.timed &&
                _loopStream,
            loopDelay:
            _streamTiming ==
                ShowcaseStreamTiming.timed &&
                _loopStream
                ? _durationFromSeconds(
              _loopDelaySeconds,
            )
                : Duration.zero,
          ),
        );

        setState(() {});

        return;
      }

      _controller.burst(
        preset.burst(
          texture: texture,
          textureSet: textureSet,
          count:
          _particleCount.round(),
        ),
      );

      return;
    }

    if (_isContinuous) {
      _controller.start(
        ParticleStreamConfig(
          texture: texture,
          textureSet: textureSet,
          particlesPerSecond:
          _particlesPerSecond,
          duration:
          _streamTiming ==
              ShowcaseStreamTiming.timed
              ? _durationFromSeconds(
            _streamDurationSeconds,
          )
              : null,
          loop:
          _streamTiming ==
              ShowcaseStreamTiming.timed &&
              _loopStream,
          loopDelay:
          _streamTiming ==
              ShowcaseStreamTiming.timed &&
              _loopStream
              ? _durationFromSeconds(
            _loopDelaySeconds,
          )
              : Duration.zero,
          emitter: _buildEmitter(),
          speed: _buildSpeedRange(),
          size: const ParticleRange(
            24,
            58,
          ),
          lifetime:
          _buildLifetimeRange(),
          appearance:
          _buildAppearance(),
          forces: _buildForces(),
        ),
      );

      setState(() {});

      return;
    }

    _controller.burst(
      ParticleBurstConfig(
        texture: texture,
        textureSet: textureSet,
        count:
        _particleCount.round(),
        emitter: _buildEmitter(),
        speed: _buildSpeedRange(),
        size: const ParticleRange(
          24,
          58,
        ),
        lifetime:
        _buildLifetimeRange(),
        appearance:
        _buildAppearance(),
        forces: _buildForces(),
      ),
    );
  }
  void _pauseStream() {
    _controller.pause();

    setState(() {});
  }

  void _resumeStream() {
    _controller.resume();

    setState(() {});
  }

  void _stopStream() {
    _controller.stop();

    setState(() {});
  }
  @override
  void dispose() {
    _controller.dispose();

    for (final ParticleTexture texture
    in _ownedTextures) {
      texture.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Particle FX Playground',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  12,
                ),
                child: _buildFixedPreview(),
              ),
            ),

            const Divider(
              height: 1,
            ),

            Expanded(
              flex: 6,
              child: _buildControls(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAppearanceControls() {
    final bool hasTrail =
        _trailMode != ShowcaseTrail.none;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Opacity',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseOpacity.values.map(
                (ShowcaseOpacity mode) {
              return ChoiceChip(
                label: Text(
                  mode.title,
                ),
                selected:
                _opacityMode == mode,
                onSelected: (_) {
                  setState(() {
                    _opacityMode = mode;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 20),

        const Text(
          'Scale',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseScale.values.map(
                (ShowcaseScale mode) {
              return ChoiceChip(
                label: Text(
                  mode.title,
                ),
                selected:
                _scaleMode == mode,
                onSelected: (_) {
                  setState(() {
                    _scaleMode = mode;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 20),

        const Text(
          'Color',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseColor.values.map(
                (ShowcaseColor mode) {
              return ChoiceChip(
                label: Text(
                  mode.title,
                ),
                selected:
                _colorMode == mode,
                onSelected: (_) {
                  setState(() {
                    _colorMode = mode;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 20),

        const Text(
          'Blend mode',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseBlendMode.values.map(
                (ShowcaseBlendMode mode) {
              return ChoiceChip(
                label: Text(
                  mode.title,
                ),
                selected:
                _selectedBlendMode ==
                    mode,
                onSelected: (_) {
                  setState(() {
                    _selectedBlendMode =
                        mode;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 8),

        Text(
          _selectedBlendMode ==
              ShowcaseBlendMode.additive
              ? 'Adds particle light to the background. Best for sparks and glow effects.'
              : 'Standard alpha compositing.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Trail',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseTrail.values.map(
                (ShowcaseTrail mode) {
              return ChoiceChip(
                label: Text(
                  mode.title,
                ),
                selected:
                _trailMode == mode,
                onSelected: (_) {
                  setState(() {
                    _trailMode = mode;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 8),

        Text(
          hasTrail
              ? 'Stores a small position history and renders it behind each particle.'
              : 'No additional trail samples are stored or rendered.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),

        if (hasTrail) ...[
          const SizedBox(height: 16),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Trail points',
                ),
              ),

              Text(
                _trailMaxPoints.toString(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Trail opacity',
                ),
              ),

              Text(
                _trailOpacity
                    .toStringAsFixed(2),
              ),
            ],
          ),

          Slider(
            value: _trailOpacity,
            min: 0.1,
            max: 0.8,
            divisions: 14,
            onChanged:
                (double value) {
              setState(() {
                _trailOpacity = value;
              });
            },
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Sample interval',
                ),
              ),

              Text(
                '${_trailSampleIntervalMs.round()} ms',
              ),
            ],
          ),

          Slider(
            value:
            _trailSampleIntervalMs,
            min: 16,
            max: 100,
            divisions: 21,
            onChanged:
                (double value) {
              setState(() {
                _trailSampleIntervalMs =
                    value;
              });
            },
          ),

          Text(
            'Lower intervals create denser trails but require more trail updates.',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
  Widget _buildEmissionModeSelector() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children:
          ShowcaseEmissionMode.values.map(
                (
                ShowcaseEmissionMode mode,
                ) {
              return ChoiceChip(
                label: Text(
                  mode.title,
                ),
                selected:
                _emissionMode == mode,
                onSelected: (_) {
                  if (_emissionMode == mode) {
                    return;
                  }

                  if (_controller.isStreaming) {
                    _controller.stop();
                  }

                  setState(() {
                    _emissionMode = mode;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 8),

        Text(
          _emissionMode.description,
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  Widget _buildParticlesPerSecondControl() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Particles per second',
              ),
            ),
            Text(
              _particlesPerSecond
                  .round()
                  .toString(),
            ),
          ],
        ),

        Slider(
          value: _particlesPerSecond,
          min: 10,
          max: 500,
          divisions: 49,
          onChanged: (double value) {
            setState(() {
              _particlesPerSecond = value;
            });
          },
        ),
      ],
    );
  }
  Widget _buildStreamTimingControls() {
    final bool isTimed =
        _streamTiming ==
            ShowcaseStreamTiming.timed;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Stream duration',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text(
                'Unlimited',
              ),
              selected:
              _streamTiming ==
                  ShowcaseStreamTiming
                      .unlimited,
              onSelected: (_) {
                setState(() {
                  _streamTiming =
                      ShowcaseStreamTiming
                          .unlimited;
                });
              },
            ),

            ChoiceChip(
              label: const Text(
                'Timed',
              ),
              selected:
              _streamTiming ==
                  ShowcaseStreamTiming
                      .timed,
              onSelected: (_) {
                setState(() {
                  _streamTiming =
                      ShowcaseStreamTiming
                          .timed;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          isTimed
              ? 'Emit particles for a fixed amount of time.'
              : 'Keep emitting until the stream is stopped manually.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),

        if (isTimed) ...[
          const SizedBox(height: 16),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Duration',
                ),
              ),

              Text(
                '${_streamDurationSeconds.toStringAsFixed(1)} s',
              ),
            ],
          ),

          Slider(
            value:
            _streamDurationSeconds,
            min: 0.5,
            max: 10,
            divisions: 19,
            onChanged:
                (double value) {
              setState(() {
                _streamDurationSeconds =
                    value;
              });
            },
          ),

          const SizedBox(height: 8),

          SwitchListTile(
            contentPadding:
            EdgeInsets.zero,
            title: const Text(
              'Loop',
            ),
            subtitle: const Text(
              'Restart the timed stream after it finishes.',
            ),
            value: _loopStream,
            onChanged:
                (bool value) {
              setState(() {
                _loopStream =
                    value;
              });
            },
          ),

          if (_loopStream) ...[
            const SizedBox(height: 8),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Loop delay',
                  ),
                ),

                Text(
                  '${_loopDelaySeconds.toStringAsFixed(1)} s',
                ),
              ],
            ),

            Slider(
              value:
              _loopDelaySeconds,
              min: 0,
              max: 5,
              divisions: 20,
              onChanged:
                  (double value) {
                setState(() {
                  _loopDelaySeconds =
                      value;
                });
              },
            ),
          ],
        ],
      ],
    );
  }
  Widget _buildStreamControls() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          onPressed:
          !_hasTextureSelection
              ? null
              : _runEffect,
          icon: const Icon(
            Icons.play_arrow,
          ),
          label: Text(
            _controller.isStreaming
                ? 'Restart'
                : 'Start',
          ),
        ),

        OutlinedButton.icon(
          onPressed:
          _isStreamRunning
              ? _pauseStream
              : null,
          icon: const Icon(
            Icons.pause,
          ),
          label: const Text(
            'Pause',
          ),
        ),

        OutlinedButton.icon(
          onPressed:
          _isStreamPaused
              ? _resumeStream
              : null,
          icon: const Icon(
            Icons.play_circle_outline,
          ),
          label: const Text(
            'Resume',
          ),
        ),

        OutlinedButton.icon(
          onPressed:
          _controller.isStreaming
              ? _stopStream
              : null,
          icon: const Icon(
            Icons.stop,
          ),
          label: const Text(
            'Stop',
          ),
        ),
      ],
    );
  }
  Widget _buildStreamStatus() {
    final String status;

    if (!_controller.isStreaming) {
      status = 'Stopped';
    } else if (_controller.isStreamPaused) {
      status = 'Paused';
    } else {
      status = 'Running';
    }

    return Row(
      children: [
        const Text(
          'Stream status:',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          status,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  Widget _buildEmitterSelector() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseEmitter.values.map(
                (ShowcaseEmitter emitter) {
              return ChoiceChip(
                label: Text(
                  emitter.title,
                ),
                selected:
                emitter ==
                    _selectedEmitter,
                onSelected: (_) {
                  setState(() {
                    _selectedEmitter =
                        emitter;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 8),

        Text(
          _selectedEmitter.description,
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  Widget _buildCodeSection() {
    final String code =
    _buildGeneratedCode();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
        borderRadius:
        BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        tilePadding:
        const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        childrenPadding:
        const EdgeInsets.fromLTRB(
          12,
          0,
          12,
          12,
        ),
        leading: const Icon(
          Icons.code,
          size: 20,
        ),
        title: const Text(
          'Dart code',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text(
          'Configuration for this effect',
        ),
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed:
                _copyGeneratedCode,
                icon: const Icon(
                  Icons.copy,
                  size: 17,
                ),
                label: const Text(
                  'Copy',
                ),
              ),
            ],
          ),

          Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 260,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectionArea(
                  child: Text(
                    code,
                    softWrap: false,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_textureMode ==
              ShowcaseTextureMode.weighted) ...[
            const SizedBox(height: 10),

            const Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                'Weighted code expects a List<ParticleTexture> named textures in the same order as the selected images.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ),
          ],
          if (_usesPointerTarget) ...[
            const SizedBox(height: 10),
            const Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                'This example expects a ParticleForceTargetController named targetController.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildActiveForces() {
    final List<String> forces =
        _activeForceNames;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Active forces',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        if (forces.isEmpty)
          Text(
            'None — particles only use their initial velocity.',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: forces.map(
                  (String force) {
                return Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(6),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant,
                    ),
                  ),
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.functions,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        force,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily:
                          'monospace',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
      ],
    );
  }
  Widget _buildFixedPreview() {
    final Widget preview = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ParticleFx(
                controller: _controller,
              ),
            ),
          ),

          if (_previewImageBytes == null)
            const Center(
              child: Text(
                'Choose an image below to start',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),

          if (_previewImageBytes != null)
            Center(
              child: Opacity(
                opacity: 0.12,
                child: Image.memory(
                  _previewImageBytes!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          Positioned(
            top: 12,
            left: 14,
            child: Text(
              _selectedEffect.title,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          if (_usesPointerTarget)
            const Positioned(
              top: 36,
              left: 14,
              child: Text(
                'Drag inside the preview',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ),

          if (_usesPointerTarget &&
              _pointerPosition != null)
            Positioned(
              left:
              _pointerPosition!.dx - 8,
              top:
              _pointerPosition!.dy - 8,
              child: IgnorePointer(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration:
                  BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                    Colors.white,
                    border: Border.all(
                      color:
                      Colors.black,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 12,
            right: 12,
            child: FilledButton.icon(
              onPressed:
              !_hasTextureSelection
                  ? null
                  : _runEffect,
              icon: Icon(
                _isContinuous
                    ? Icons.play_arrow
                    : Icons.auto_awesome,
              ),
              label: Text(
                _isContinuous
                    ? (
                    _controller.isStreaming
                        ? 'Restart'
                        : 'Start'
                )
                    : 'Run',
              ),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onHover: _usesPointerTarget
          ? (PointerHoverEvent event) {
        _updatePointerTarget(
          event.localPosition,
        );
      }
          : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTapDown: _usesPointerTarget
            ? (TapDownDetails details) {
          _updatePointerTarget(
            details.localPosition,
          );
        }
            : null,

        onPanDown: _usesPointerTarget
            ? (DragDownDetails details) {
          _updatePointerTarget(
            details.localPosition,
          );
        }
            : null,

        onPanUpdate: _usesPointerTarget
            ? (DragUpdateDetails details) {
          _updatePointerTarget(
            details.localPosition,
          );
        }
            : null,

        child: preview,
      ),
    );
  }
  Widget _buildCompositeLifecycleLog() {
    final ColorScheme colors =
        Theme.of(context)
            .colorScheme;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(
        14,
      ),
      decoration: BoxDecoration(
        color: colors
            .surfaceContainerHighest
            .withValues(
          alpha: 0.35,
        ),
        borderRadius:
        BorderRadius.circular(
          12,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Lifecycle log',
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

              if (_compositeLifecycleLog
                  .isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _compositeLifecycleLog
                          .clear();
                    });
                  },
                  child:
                  const Text(
                    'Clear',
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          if (_compositeLifecycleLog
              .isEmpty)
            Text(
              'Play a composite effect to see its lifecycle events.',
              style: TextStyle(
                fontSize: 12,
                color: colors
                    .onSurfaceVariant,
              ),
            )
          else
            ..._compositeLifecycleLog
                .asMap()
                .entries
                .map(
                  (
                  MapEntry<int, String>
                  entry,
                  ) {
                final bool isLatest =
                    entry.key ==
                        _compositeLifecycleLog
                            .length -
                            1;

                return Padding(
                  padding:
                  const EdgeInsets
                      .only(
                    bottom: 6,
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text(
                          '${entry.key + 1}.',
                          style:
                          TextStyle(
                            fontSize: 11,
                            color: colors
                                .onSurfaceVariant,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Text(
                          entry.value,
                          style:
                          TextStyle(
                            fontSize: 12,
                            fontWeight:
                            isLatest
                                ? FontWeight
                                .w600
                                : FontWeight
                                .normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
  Widget _buildCompositeSelector() {
    final ParticleCompositeEffect effect =
    _buildCompositeEffect();

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseComposite.values.map(
                (
                ShowcaseComposite composite,
                ) {
              return ChoiceChip(
                label: Text(
                  composite.title,
                ),
                selected:
                _selectedComposite ==
                    composite,
                onSelected: (_) {
                  setState(() {
                    _selectedComposite =
                        composite;
                  });
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 10),

        Text(
          _selectedComposite.description,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(
            14,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(
              alpha: 0.45,
            ),
            borderRadius:
            BorderRadius.circular(
              12,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    const Text(
                      'Composite layers',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      '${effect.length} sequenced layers',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        )
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  FilledButton.icon(
                    onPressed:
                    _runCompositeEffect,
                    icon: const Icon(
                      Icons.play_arrow,
                    ),
                    label:
                    const Text(
                      'Play',
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextButton.icon(
                    onPressed:
                    _copyCompositeGeneratedCode,
                    icon: const Icon(
                      Icons.copy,
                      size: 18,
                    ),
                    label:
                    const Text(
                      'Copy',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _buildCompositeLifecycleLog(),
      ],
    );
  }
  Widget _buildPresetSelector() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcasePreset.values.map(
                (ShowcasePreset preset) {
              return ChoiceChip(
                label: Text(
                  preset.title,
                ),
                selected:
                _selectedPreset ==
                    preset,
                onSelected: (_) {
                  _selectPreset(
                    preset,
                  );
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 10),

        Text(
          _selectedPreset.description,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),

        if (!_isCustomPreset) ...[
          const SizedBox(height: 14),
          _buildPresetDetails(),
        ],
      ],
    );
  }

  Widget _buildPresetDetails() {
    final ParticlePreset? preset =
        _activePreset;

    if (preset == null) {
      return const SizedBox.shrink();
    }

    final ParticleTrail? trail =
        preset.appearance.trail;

    final String forces =
    preset.forces.isEmpty
        ? 'None'
        : preset.forces
        .map(
          (ParticleForce force) =>
          force.runtimeType
              .toString(),
    )
        .join(', ');

    final String blendMode =
    preset.appearance.blendMode ==
        BlendMode.plus
        ? 'Add'
        : 'Normal';

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(
        14,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(
          alpha: 0.45,
        ),
        borderRadius:
        BorderRadius.circular(
          12,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Preset configuration',
            style: TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          _buildPresetDetailRow(
            'Emitter',
            preset.emitter.runtimeType
                .toString(),
          ),

          _buildPresetDetailRow(
            'Speed',
            '${_formatNumber(preset.speed.min)} – '
                '${_formatNumber(preset.speed.max)} px/s',
          ),

          _buildPresetDetailRow(
            'Size',
            '${_formatNumber(preset.size.min)} – '
                '${_formatNumber(preset.size.max)} px',
          ),

          _buildPresetDetailRow(
            'Lifetime',
            '${_formatNumber(preset.lifetime.min)} – '
                '${_formatNumber(preset.lifetime.max)} s',
          ),

          _buildPresetDetailRow(
            'Blend',
            blendMode,
          ),

          _buildPresetDetailRow(
            'Forces',
            forces,
          ),

          if (trail != null)
            _buildPresetDetailRow(
              'Trail',
              '${trail.maxPoints} points / '
                  '${trail.sampleInterval.inMilliseconds} ms',
            ),
        ],
      ),
    );
  }

  Widget _buildPresetDetailRow(
      String label,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style:
              const TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPerformancePanel() {
    return ValueListenableBuilder<
        ParticleFxStats>(
      valueListenable:
      _controller.statsListenable,
      builder: (
          BuildContext context,
          ParticleFxStats stats,
          Widget? child,
          ) {
        final double capacity =
        stats.capacityUsage
            .clamp(
          0.0,
          1.0,
        )
            .toDouble();

        return Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(
            16,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(
              alpha: 0.45,
            ),
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Live performance',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Theme.of(
                        context,
                      )
                          .colorScheme
                          .surface,
                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),
                    ),
                    child: const Text(
                      '250 ms sample',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label: 'FPS',
                      value: stats.fps <= 0
                          ? '—'
                          : stats.fps
                          .toStringAsFixed(
                        1,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label: 'Frame time',
                      value:
                      stats.frameTimeMs <=
                          0
                          ? '—'
                          : '${stats.frameTimeMs.toStringAsFixed(1)} ms',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label: 'Particles',
                      value:
                      '${stats.activeParticles}',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label: 'Capacity',
                      value:
                      stats.maxParticles <=
                          0
                          ? '—'
                          : '${stats.activeParticles} / ${stats.maxParticles}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
                child:
                LinearProgressIndicator(
                  value: capacity,
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 6),

              Align(
                alignment:
                Alignment.centerRight,
                child: Text(
                  stats.maxParticles <= 0
                      ? 'Capacity unavailable'
                      : '${(capacity * 100).toStringAsFixed(1)}% used',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label:
                      'Trail samples',
                      value:
                      '${stats.trailSamples}',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label:
                      'Est. draw calls',
                      value:
                      '${stats.estimatedDrawCalls}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label:
                      'Total emitted',
                      value:
                      '${stats.emittedParticles}',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child:
                    _buildPerformanceMetric(
                      label: 'Dropped',
                      value:
                      '${stats.droppedParticles}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                'Estimated draw calls include active particles and their stored trail samples.',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceMetric({
    required String label,
    required String value,
  }) {
    return Container(
      padding:
      const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,
        borderRadius:
        BorderRadius.circular(
          10,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w600,
              fontFeatures: [
                FontFeature
                    .tabularFigures(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildControls() {
    return ListView(
      padding:
      const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        32,
      ),
      children: [
        const Text(
          'Particle textures',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        _buildImageSelector(),

        const SizedBox(height: 24),

        const Text(
          'Preset',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        _buildPresetSelector(),

        const SizedBox(height: 28),

        const Text(
          'Composite effects',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Layer multiple presets and emission modes into one effect.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 12),

        _buildCompositeSelector(),

        if (_isCustomPreset) ...[
          const SizedBox(height: 24),

          const Text(
            'Emitter',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          _buildEmitterSelector(),
        ],

        const SizedBox(height: 24),

        const Text(
          'Emission',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        _buildEmissionModeSelector(),

        if (_isContinuous) ...[
          const SizedBox(height: 16),

          _buildParticlesPerSecondControl(),

          const SizedBox(height: 20),

          _buildStreamTimingControls(),

          const SizedBox(height: 16),

          _buildStreamControls(),

          const SizedBox(height: 10),

          _buildStreamStatus(),
        ],

        if (!_isContinuous &&
            !_isCustomPreset) ...[
          const SizedBox(height: 16),

          _buildParticleCountControl(),
        ],

        if (_isCustomPreset) ...[
          const SizedBox(height: 24),

          const Text(
            'Effect',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          _buildEffectButtons(),

          const SizedBox(height: 24),

          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          _buildAppearanceControls(),

          const SizedBox(height: 10),

          Text(
            _selectedEffect.description,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          _buildActiveForces(),

          const SizedBox(height: 24),

          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          if (!_isContinuous) ...[
            _buildParticleCountControl(),
            const SizedBox(height: 12),
          ],

          _buildStrengthControl(),

          if (_supportsFalloff) ...[
            const SizedBox(height: 20),

            _buildFalloffControl(),

            const SizedBox(height: 16),

            _buildReferenceDistanceControl(),
          ],
        ],

        const SizedBox(height: 24),

        const Text(
          'Performance',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(height: 12),

        _buildPerformancePanel(),

        const SizedBox(height: 24),

        _buildCodeSection(),
      ],
    );
  }
  Widget _buildFalloffControl() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Distance falloff',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<ForceFalloff>(
          initialValue: _forceFalloff,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: ForceFalloff.values.map(
                (ForceFalloff falloff) {
              return DropdownMenuItem(
                value: falloff,
                child: Text(
                  falloff.label,
                ),
              );
            },
          ).toList(),
          onChanged: (ForceFalloff? value) {
            if (value == null) {
              return;
            }

            setState(() {
              _forceFalloff = value;
            });
          },
        ),

        const SizedBox(height: 8),

        Text(
          _forceFalloff.description,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  Widget _buildReferenceDistanceControl() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Reference distance',
              ),
            ),
            Text(
              '${_referenceDistance.round()} px',
            ),
          ],
        ),

        Slider(
          value: _referenceDistance,
          min: 50,
          max: 600,
          divisions: 22,
          onChanged: (double value) {
            setState(() {
              _referenceDistance = value;
            });
          },
        ),
      ],
    );
  }
  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _buildTextureModeSelector(),

        const SizedBox(height: 16),

        if (_textureMode ==
            ShowcaseTextureMode.single)
          _buildSingleImageSelector()
        else
          _buildWeightedImageSelector(),

        const SizedBox(height: 16),

        const Text(
          'Quick showcase textures',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(
                Icons.favorite,
                size: 18,
              ),
              label: const Text(
                'Hearts',
              ),
              onPressed: _loadingImage
                  ? null
                  : () {
                _loadShowcaseTexture(
                  'assets/particles/hearts.png',
                );
              },
            ),
            ActionChip(
              avatar: const Icon(
                Icons.eco,
                size: 18,
              ),
              label: const Text(
                'Leaves',
              ),
              onPressed: _loadingImage
                  ? null
                  : () {
                _loadShowcaseTexture(
                  'assets/particles/leaves.png',
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          'Use these images with any preset or custom effect.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTextureModeSelector() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
          ShowcaseTextureMode.values.map(
                (ShowcaseTextureMode mode) {
              return ChoiceChip(
                label: Text(
                  mode.title,
                ),
                selected:
                _textureMode == mode,
                onSelected: (_) {
                  _setTextureMode(
                    mode,
                  );
                },
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 8),

        Text(
          _textureMode.description,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleImageSelector() {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white12,
            ),
            borderRadius:
            BorderRadius.circular(
              8,
            ),
          ),
          child:
          _selectedImageBytes == null
              ? const Icon(
            Icons.image_outlined,
          )
              : Padding(
            padding:
            const EdgeInsets
                .all(
              6,
            ),
            child: Image.memory(
              _selectedImageBytes!,
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: OutlinedButton.icon(
            onPressed:
            _loadingImage
                ? null
                : _pickImage,
            icon: _loadingImage
                ? const SizedBox(
              width: 18,
              height: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(
              Icons.folder_open,
            ),
            label: Text(
              _selectedImageBytes == null
                  ? 'Choose image'
                  : 'Change image',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightedImageSelector() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed:
            _loadingImage
                ? null
                : _addWeightedImages,
            icon: _loadingImage
                ? const SizedBox(
              width: 18,
              height: 18,
              child:
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(
              Icons.add_photo_alternate_outlined,
            ),
            label: const Text(
              'Add images',
            ),
          ),
        ),

        if (_weightedTextures.isEmpty) ...[
          const SizedBox(height: 12),

          Text(
            'No weighted textures added yet.',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],

        if (_weightedTextures.isNotEmpty) ...[
          const SizedBox(height: 12),

          Text(
            '${_weightedTextures.length} texture'
                '${_weightedTextures.length == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 10),

          for (
          int index = 0;
          index < _weightedTextures.length;
          index++
          )
            _buildWeightedTextureCard(
              _weightedTextures[index],
              index,
            ),
        ],
      ],
    );
  }

  Widget _buildWeightedTextureCard(
      _ShowcaseTextureEntry entry,
      int index,
      ) {
    final double probability =
    _textureProbability(
      entry,
    );

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(
          8,
        ),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                padding:
                const EdgeInsets.all(
                  5,
                ),
                decoration:
                BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(
                    6,
                  ),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                ),
                child: Image.memory(
                  entry.bytes,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'Texture ${index + 1}',
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      'Probability '
                          '${(probability * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        )
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'Remove',
                onPressed: () {
                  setState(() {
                    _weightedTextures
                        .removeAt(
                      index,
                    );
                  });
                },
                icon: const Icon(
                  Icons.delete_outline,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const SizedBox(
                width: 52,
                child: Text(
                  'Weight',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),

              Expanded(
                child: Slider(
                  value: entry.weight,
                  min: 0.25,
                  max: 10,
                  divisions: 39,
                  onChanged:
                      (double value) {
                    setState(() {
                      entry.weight =
                          value;
                    });
                  },
                ),
              ),

              SizedBox(
                width: 42,
                child: Text(
                  entry.weight
                      .toStringAsFixed(
                    2,
                  ),
                  textAlign:
                  TextAlign.end,
                  style:
                  const TextStyle(
                    fontSize: 12,
                    fontFamily:
                    'monospace',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ShowcaseEffect.values.map(
            (ShowcaseEffect effect) {
          final bool selected =
              effect == _selectedEffect;

          return ChoiceChip(
            label: Text(
              effect.title,
            ),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedEffect = effect;
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget _buildParticleCountControl() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Particle count',
              ),
            ),
            Text(
              _particleCount
                  .round()
                  .toString(),
            ),
          ],
        ),
        Slider(
          value: _particleCount,
          min: 50,
          max: 1000,
          divisions: 19,
          onChanged: (double value) {
            setState(() {
              _particleCount = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStrengthControl() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Effect strength',
              ),
            ),
            Text(
              '${_effectStrength.toStringAsFixed(1)}×',
            ),
          ],
        ),
        Slider(
          value: _effectStrength,
          min: 0.25,
          max: 2,
          divisions: 7,
          onChanged: (double value) {
            setState(() {
              _effectStrength = value;
            });
          },
        ),
      ],
    );
  }
}