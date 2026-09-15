import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../appearance/particle_appearance.dart';
import '../appearance/particle_color_over_lifetime.dart';
import '../appearance/particle_lifetime_value.dart';
import '../appearance/particle_trail.dart';
import '../core/particle_range.dart';
import '../emitters/cone_emitter.dart';
import '../emitters/disc_emitter.dart';
import '../emitters/line_emitter.dart';
import '../emitters/point_emitter.dart';

import '../forces/buoyancy_force.dart';
import '../forces/drag_force.dart';
import '../forces/gravity_force.dart';
import '../forces/particle_force.dart';
import '../forces/particle_force_target.dart';
import '../forces/shockwave_force.dart';
import '../forces/turbulence_force.dart';
import '../forces/vortex_force.dart';
import '../forces/wind_force.dart';
import 'particle_preset.dart';

/// Ready-to-use particle effect presets.
///
/// Presets only describe particle behavior. Textures and emission scheduling
/// are supplied when calling [ParticlePreset.burst] or [ParticlePreset.stream].
abstract final class ParticlePresets {
  /// Rising flame-like particles.
  static ParticlePreset get fire {
    return ParticlePreset(
      emitter: const ConeEmitter(
        position: Alignment(
          0,
          0.8,
        ),
        direction:
        -math.pi / 2,
        spread:
        math.pi / 3,
      ),
      speed: const ParticleRange(
        80,
        220,
      ),
      size: const ParticleRange(
        18,
        42,
      ),
      lifetime:
      const ParticleRange(
        0.8,
        1.8,
      ),
      angularVelocity:
      const ParticleRange(
        -1.5,
        1.5,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 0.6,
          end: 1.35,
          curve: Curves.easeOut,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFFFF59D,
          ),
          end: Color(
            0xFFFF3D00,
          ),
          curve: Curves.easeIn,
        ),
        blendMode:
        BlendMode.plus,
      ),
      forces: <ParticleForce>[
        BuoyancyForce(
          acceleration: 260,
        ),
        TurbulenceForce(
          strength: 70,
          scale: 0.025,
          speed: 1.4,
        ),
        const DragForce(
          coefficient: 0.25,
        ),
      ],
    );
  }

  /// Slowly falling snow-like particles.
  static ParticlePreset get snow {
    return ParticlePreset(
      emitter: const LineEmitter(
        start:
        Alignment.topLeft,
        end:
        Alignment.topRight,
        direction:
        ParticleRange(
          1.35,
          1.79,
        ),
      ),
      speed: const ParticleRange(
        30,
        80,
      ),
      size: const ParticleRange(
        8,
        20,
      ),
      lifetime:
      const ParticleRange(
        5,
        9,
      ),
      angularVelocity:
      const ParticleRange(
        -1,
        1,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 0.9,
          end: 0.25,
          curve: Curves.easeInOut,
        ),
        scale:
        ParticleLifetimeValue
            .constant(
          1,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFFFFFFF,
          ),
          end: Color(
            0xFFBBDEFB,
          ),
          curve: Curves.easeOut,
        ),
      ),
      forces: <ParticleForce>[
        const GravityForce(
          acceleration: 22,
        ),
        TurbulenceForce(
          strength: 28,
          scale: 0.018,
          speed: 0.6,
        ),
        const DragForce(
          coefficient: 0.08,
        ),
      ],
    );
  }

  /// Colorful upward burst suitable for confetti textures.
  static ParticlePreset get confetti {
    return ParticlePreset(
      emitter: const ConeEmitter(
        position: Alignment(
          0,
          0.8,
        ),
        direction:
        -math.pi / 2,
        spread:
        math.pi * 0.8,
      ),
      speed: const ParticleRange(
        300,
        700,
      ),
      size: const ParticleRange(
        10,
        24,
      ),
      lifetime:
      const ParticleRange(
        2.5,
        4.5,
      ),
      angularVelocity:
      const ParticleRange(
        -8,
        8,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue
            .constant(
          1,
        ),
      ),
      forces:
      const <ParticleForce>[
        GravityForce(
          acceleration: 650,
        ),
        DragForce(
          coefficient: 0.08,
        ),
      ],
    );
  }

  /// Swirling glowing particles around the center.
  static ParticlePreset get magic {
    return ParticlePreset(
      emitter:
      const PointEmitter(
        position:
        Alignment.center,
      ),
      speed: const ParticleRange(
        80,
        220,
      ),
      size: const ParticleRange(
        12,
        28,
      ),
      lifetime:
      const ParticleRange(
        2,
        4,
      ),
      angularVelocity:
      const ParticleRange(
        -4,
        4,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeOut,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 0.6,
          end: 1.15,
          curve: Curves.easeOut,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFE1BEE7,
          ),
          end: Color(
            0xFF7C4DFF,
          ),
          curve: Curves.easeInOut,
        ),
        blendMode:
        BlendMode.plus,
        trail: ParticleTrail(
          maxPoints: 5,
          sampleInterval:
          Duration(
            milliseconds: 45,
          ),
          opacity: 0.3,
          startScale: 0.6,
        ),
      ),
      forces: <ParticleForce>[
        VortexForce(
          target:
          const ParticleForceTarget
              .alignment(
            Alignment.center,
          ),
          strength: 520,
          inwardStrength: 90,
        ),
        TurbulenceForce(
          strength: 70,
          scale: 0.018,
          speed: 1,
        ),
        const DragForce(
          coefficient: 0.18,
        ),
      ],
    );
  }

  /// Slow expanding smoke drifting upward.
  static ParticlePreset get smoke {
    return ParticlePreset(
      emitter: const ConeEmitter(
        position: Alignment(
          0,
          0.65,
        ),
        direction:
        -math.pi / 2,
        spread:
        math.pi / 4,
      ),
      speed: const ParticleRange(
        25,
        90,
      ),
      size: const ParticleRange(
        30,
        72,
      ),
      lifetime:
      const ParticleRange(
        3,
        6,
      ),
      angularVelocity:
      const ParticleRange(
        -0.8,
        0.8,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 0.55,
          end: 0,
          curve: Curves.easeOut,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 0.55,
          end: 1.8,
          curve: Curves.easeOut,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFE0E0E0,
          ),
          end: Color(
            0xFF757575,
          ),
          curve: Curves.easeIn,
        ),
      ),
      forces: <ParticleForce>[
        BuoyancyForce(
          acceleration: 85,
        ),
        TurbulenceForce(
          strength: 42,
          scale: 0.02,
          speed: 0.7,
        ),
        const DragForce(
          coefficient: 0.25,
        ),
      ],
    );
  }

  /// Fast glowing sparks with a short trail.
  static ParticlePreset get sparks {
    return ParticlePreset(
      emitter:
      const PointEmitter(
        position:
        Alignment.center,
      ),
      speed: const ParticleRange(
        320,
        800,
      ),
      size: const ParticleRange(
        6,
        16,
      ),
      lifetime:
      const ParticleRange(
        0.45,
        1.2,
      ),
      angularVelocity:
      const ParticleRange(
        -6,
        6,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 1,
          end: 0.25,
          curve: Curves.easeIn,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFFFFFFF,
          ),
          end: Color(
            0xFFFF6D00,
          ),
          curve: Curves.easeIn,
        ),
        blendMode:
        BlendMode.plus,
        trail: ParticleTrail(
          maxPoints: 5,
          sampleInterval:
          Duration(
            milliseconds: 32,
          ),
          opacity: 0.4,
          startScale: 0.45,
        ),
      ),
      forces:
      const <ParticleForce>[
        GravityForce(
          acceleration: 700,
        ),
        DragForce(
          coefficient: 0.1,
        ),
      ],
    );
  }
  /// Fast radial burst with gravity and bright glowing trails.
  static ParticlePreset get fireworks {
    return ParticlePreset(
      emitter: const PointEmitter(
        position: Alignment.center,
      ),
      speed: const ParticleRange(
        380,
        900,
      ),
      size: const ParticleRange(
        6,
        16,
      ),
      lifetime: const ParticleRange(
        0.9,
        1.8,
      ),
      angularVelocity:
      const ParticleRange(
        -6,
        6,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 1,
          end: 0.2,
          curve: Curves.easeIn,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFFFFFFF,
          ),
          end: Color(
            0xFFFF9100,
          ),
          curve: Curves.easeIn,
        ),
        blendMode:
        BlendMode.plus,
        trail: ParticleTrail(
          maxPoints: 8,
          sampleInterval:
          Duration(
            milliseconds: 28,
          ),
          opacity: 0.38,
          startScale: 0.25,
        ),
      ),
      forces:
      const <ParticleForce>[
        GravityForce(
          acceleration: 480,
        ),
        DragForce(
          coefficient: 0.06,
        ),
      ],
    );
  }
  /// Upward fountain with gravity pulling particles back down.
  static ParticlePreset get fountain {
    return ParticlePreset(
      emitter: const ConeEmitter(
        position: Alignment(
          0,
          0.85,
        ),
        direction:
        -math.pi / 2,
        spread:
        math.pi / 5,
      ),
      speed: const ParticleRange(
        350,
        700,
      ),
      size: const ParticleRange(
        7,
        18,
      ),
      lifetime:
      const ParticleRange(
        1.8,
        3.5,
      ),
      angularVelocity:
      const ParticleRange(
        -3,
        3,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 0.7,
          end: 1,
          curve: Curves.easeOut,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFE1F5FE,
          ),
          end: Color(
            0xFF0288D1,
          ),
          curve: Curves.easeOut,
        ),
        blendMode:
        BlendMode.plus,
        trail: ParticleTrail(
          maxPoints: 6,
          sampleInterval:
          Duration(
            milliseconds: 35,
          ),
          opacity: 0.25,
          startScale: 0.4,
        ),
      ),
      forces:
      const <ParticleForce>[
        GravityForce(
          acceleration: 650,
        ),
        DragForce(
          coefficient: 0.05,
        ),
      ],
    );
  }
  /// Fast rain emitted across the top of the canvas.
  static ParticlePreset get rain {
    return ParticlePreset(
      emitter: const LineEmitter(
        start:
        Alignment.topLeft,
        end:
        Alignment.topRight,
        direction:
        ParticleRange(
          1.42,
          1.62,
        ),
      ),
      speed: const ParticleRange(
        500,
        850,
      ),
      size: const ParticleRange(
        4,
        10,
      ),
      lifetime:
      const ParticleRange(
        1.4,
        2.4,
      ),
      angularVelocity:
      const ParticleRange.fixed(
        0,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 0.85,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue
            .constant(
          1,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFE3F2FD,
          ),
          end: Color(
            0xFF42A5F5,
          ),
          curve: Curves.easeOut,
        ),
        trail: ParticleTrail(
          maxPoints: 4,
          sampleInterval:
          Duration(
            milliseconds: 24,
          ),
          opacity: 0.22,
          startScale: 0.35,
        ),
      ),
      forces:
      const <ParticleForce>[
        GravityForce(
          acceleration: 120,
        ),
        WindForce(
          x: 60,
        ),
        DragForce(
          coefficient: 0.02,
        ),
      ],
    );
  }
  /// Long-lived glowing particles orbiting around the center.
  static ParticlePreset get galaxy {
    return ParticlePreset(
      emitter: const DiscEmitter(
        center:
        Alignment.center,
        radius: 140,
        directionOffset:
        ParticleRange(
          -0.2,
          0.2,
        ),
      ),
      speed: const ParticleRange(
        20,
        90,
      ),
      size: const ParticleRange(
        7,
        20,
      ),
      lifetime:
      const ParticleRange(
        4,
        7,
      ),
      angularVelocity:
      const ParticleRange(
        -2,
        2,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 0.9,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 0.6,
          end: 1,
          curve: Curves.easeOut,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFFFFFFF,
          ),
          end: Color(
            0xFF7C4DFF,
          ),
          curve: Curves.easeInOut,
        ),
        blendMode:
        BlendMode.plus,
        trail: ParticleTrail(
          maxPoints: 6,
          sampleInterval:
          Duration(
            milliseconds: 50,
          ),
          opacity: 0.28,
          startScale: 0.45,
        ),
      ),
      forces: <ParticleForce>[
        VortexForce(
          target:
          const ParticleForceTarget
              .alignment(
            Alignment.center,
          ),
          strength: 720,
          inwardStrength: 130,
        ),
        TurbulenceForce(
          strength: 35,
          scale: 0.015,
          speed: 0.6,
        ),
        const DragForce(
          coefficient: 0.12,
        ),
      ],
    );
  }
  /// Violent glowing explosion with a short shockwave impulse.
  static ParticlePreset get explosion {
    return ParticlePreset(
      emitter: const PointEmitter(
        position:
        Alignment.center,
      ),
      speed: const ParticleRange(
        250,
        700,
      ),
      size: const ParticleRange(
        12,
        30,
      ),
      lifetime:
      const ParticleRange(
        0.7,
        1.5,
      ),
      angularVelocity:
      const ParticleRange(
        -8,
        8,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 1,
          end: 0,
          curve: Curves.easeIn,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 1,
          end: 0.2,
          curve: Curves.easeIn,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFFFFFFF,
          ),
          end: Color(
            0xFFFF3D00,
          ),
          curve: Curves.easeIn,
        ),
        blendMode:
        BlendMode.plus,
        trail: ParticleTrail(
          maxPoints: 4,
          sampleInterval:
          Duration(
            milliseconds: 28,
          ),
          opacity: 0.3,
          startScale: 0.35,
        ),
      ),
      forces: <ParticleForce>[
        ShockwaveForce(
          strength: 1600,
          radius: 420,
          duration: 0.35,
        ),
        const DragForce(
          coefficient: 0.15,
        ),
      ],
    );
  }
  /// Soft particles floating upward with gentle chaotic movement.
  static ParticlePreset get bubbles {
    return ParticlePreset(
      emitter: const ConeEmitter(
        position: Alignment(
          0,
          0.9,
        ),
        direction:
        -math.pi / 2,
        spread:
        math.pi / 2.5,
      ),
      speed: const ParticleRange(
        20,
        90,
      ),
      size: const ParticleRange(
        18,
        48,
      ),
      lifetime:
      const ParticleRange(
        3,
        6,
      ),
      angularVelocity:
      const ParticleRange(
        -0.6,
        0.6,
      ),
      appearance:
      const ParticleAppearance(
        opacity:
        ParticleLifetimeValue(
          begin: 0.75,
          end: 0,
          curve: Curves.easeOut,
        ),
        scale:
        ParticleLifetimeValue(
          begin: 0.45,
          end: 1.2,
          curve: Curves.easeOut,
        ),
        color:
        ParticleColorOverLifetime(
          begin: Color(
            0xFFE1F5FE,
          ),
          end: Color(
            0xFF81D4FA,
          ),
          curve: Curves.easeOut,
        ),
      ),
      forces: <ParticleForce>[
        BuoyancyForce(
          acceleration: 90,
        ),
        TurbulenceForce(
          strength: 35,
          scale: 0.018,
          speed: 0.7,
        ),
        const DragForce(
          coefficient: 0.16,
        ),
      ],
    );
  }

}