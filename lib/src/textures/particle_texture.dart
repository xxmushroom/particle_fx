import 'dart:typed_data';
import 'dart:ui' as ui;

/// An image texture that can be rendered by particles.
///
/// A [ParticleTexture] stores a decoded [ui.Image], allowing many particles
/// to share the same image without decoding it repeatedly.
class ParticleTexture {
  ParticleTexture._(
      this.image, {
        required bool ownsImage,
      }) : _ownsImage = ownsImage;

  /// The decoded image used for rendering.
  final ui.Image image;

  final bool _ownsImage;

  bool _isDisposed = false;

  /// Width of the texture in physical pixels.
  int get width => image.width;

  /// Height of the texture in physical pixels.
  int get height => image.height;

  /// Width divided by height.
  double get aspectRatio => width / height;

  /// Whether this texture has already been disposed.
  bool get isDisposed => _isDisposed;

  /// Creates a particle texture from encoded image bytes.
  ///
  /// Supports image formats understood by Flutter such as PNG, JPEG and WebP.
  static Future<ParticleTexture> fromBytes(
      Uint8List bytes,
      ) async {
    if (bytes.isEmpty) {
      throw ArgumentError.value(
        bytes,
        'bytes',
        'Image data cannot be empty.',
      );
    }

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    try {
      final ui.FrameInfo frame = await codec.getNextFrame();

      return ParticleTexture._(
        frame.image,
        ownsImage: true,
      );
    } finally {
      codec.dispose();
    }
  }

  /// Creates a particle texture from an already decoded [ui.Image].
  ///
  /// Set [takeOwnership] to `true` if this texture should dispose the image
  /// when [dispose] is called.
  factory ParticleTexture.fromImage(
      ui.Image image, {
        bool takeOwnership = false,
      }) {
    return ParticleTexture._(
      image,
      ownsImage: takeOwnership,
    );
  }

  /// Releases resources owned by this texture.
  ///
  /// Calling this more than once is safe.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    if (_ownsImage) {
      image.dispose();
    }
  }
}