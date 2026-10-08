/// Plays one asset at a time. Implementations may throw from [play] when the
/// asset cannot be played; [VoiceService] then marks the key unavailable.
abstract interface class AudioBackend {
  /// [assetPath] is the full asset path, e.g. `assets/audio/kk/x.mp3`.
  Future<void> play(String assetPath, {double rate = 1.0});
  Future<void> stop();

  /// Fires when the current playback finished by itself.
  Stream<void> get onComplete;
  Future<void> dispose();
}

/// Silent backend (tests, unsupported platforms).
class NullAudioBackend implements AudioBackend {
  @override
  Future<void> play(String assetPath, {double rate = 1.0}) async {}

  @override
  Future<void> stop() async {}

  @override
  Stream<void> get onComplete => const Stream<void>.empty();

  @override
  Future<void> dispose() async {}
}
