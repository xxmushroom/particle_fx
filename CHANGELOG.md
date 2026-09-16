## 0.1.2

### Fixed

- Fixed the animated showcase image not rendering on pub.dev by using an absolute GitHub-hosted image URL.
- Excluded the showcase GIF from the published package archive to reduce package size.

## 0.1.1

### Changed

- Improved the README with package badges, a visual showcase, and a clearer quick-start guide.
- Added an animated particle effects showcase.
- Added bundled particle artwork to the example application for fire, snow, smoke, sparks, fireworks, confetti, rain, bubbles, magic, galaxy, hearts, and leaves.
- Updated the example playground to automatically use matching textures with built-in presets.
- Added quick showcase textures for hearts and leaves while preserving custom texture selection.
- Improved the example experience for demonstrating particle presets and custom effects.

## 0.1.0

Initial public release of `particle_fx`.

### Added

- High-performance image-based particle rendering using a single `CustomPainter`.
- `ParticleFxController` for controlling particle effects.
- One-shot particle bursts.
- Continuous particle streams.
- Timed particle streams.
- Looping streams with configurable loop delays.
- Pause, resume, and stop controls.
- Configurable maximum active particle capacity.
- Particle ranges for:
    - speed
    - size
    - lifetime
    - rotation
    - angular velocity
- Six built-in emitters:
    - `PointEmitter`
    - `LineEmitter`
    - `RectangleEmitter`
    - `CircleEmitter`
    - `DiscEmitter`
    - `ConeEmitter`
- Extensible particle force system.
- Built-in forces:
    - gravity
    - wind
    - drag
    - attractor
    - repulsor
    - vortex
    - turbulence
    - shockwave
    - spring
    - bounce
    - buoyancy
    - curl noise
- Distance-based force falloff modes.
- Dynamic force targets through `ParticleForceTargetController`.
- Pointer-driven attractor, repulsor, and vortex effects.
- Appearance-over-lifetime support.
- Opacity interpolation over particle lifetime.
- Scale interpolation over particle lifetime.
- Color interpolation over particle lifetime.
- Custom Flutter animation curves.
- Built-in pulse lifetime curve.
- Flutter `BlendMode` support.
- Particle trails with configurable:
    - maximum points
    - sample interval
    - opacity
    - starting scale
- Reusable decoded `ParticleTexture` objects.
- Multiple particle textures.
- Weighted random texture selection through `ParticleTextureSet`.
- Reusable `ParticlePreset` API.
- Twelve built-in presets:
    - fire
    - snow
    - confetti
    - magic
    - smoke
    - sparks
    - fireworks
    - fountain
    - rain
    - galaxy
    - explosion
    - bubbles
- Layered `ParticleCompositeEffect` support.
- Burst and stream composite layers.
- Per-layer start delays.
- Composite pause and resume behavior.
- Composite cancellation and revision-safe replacement.
- Composite lifecycle callbacks:
    - effect started
    - layer started
    - layer completed
    - effect completed
- Live performance statistics through `ParticleFxStats`.
- Performance metrics for:
    - active particles
    - maximum capacity
    - capacity usage
    - emitted particles
    - dropped particles
    - trail samples
    - estimated draw calls
    - FPS
    - frame time
- Interactive example playground.
- Generated Dart configuration code in the example application.
- Automated tests for controllers, engine behavior, scheduler timing,
  composite effects, appearance interpolation, trails, and weighted textures.