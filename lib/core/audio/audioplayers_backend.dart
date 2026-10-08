import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'audio_backend.dart';

/// [AudioBackend] on top of `audioplayers`. The player is created lazily so
/// that apps without any audio never touch the platform plugin.
class AudioplayersBackend implements AudioBackend {
  AudioPlayer? _player;
  StreamSubscription<void>? _sub;
  final StreamController<void> _complete = StreamController<void>.broadcast();

  AudioPlayer _ensure() {
    final existing = _player;
    if (existing != null) return existing;
    final p = AudioPlayer();
    _sub = p.onPlayerComplete.listen((_) => _complete.add(null));
    return _player = p;
  }

  @override
  Future<void> play(String assetPath, {double rate = 1.0}) async {
    final p = _ensure();
    // AssetSource paths are relative to the `assets/` directory.
    final rel = assetPath.startsWith('assets/')
        ? assetPath.substring('assets/'.length)
        : assetPath;
    await p.stop();
    await p.setPlaybackRate(rate);
    await p.play(AssetSource(rel));
  }

  @override
  Future<void> stop() async {
    await _player?.stop();
  }

  @override
  Stream<void> get onComplete => _complete.stream;

  @override
  Future<void> dispose() async {
    await _sub?.cancel();
    await _player?.dispose();
    _player = null;
    await _complete.close();
  }
}
