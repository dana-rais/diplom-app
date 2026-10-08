import 'dart:async';

import 'package:flutter/foundation.dart';

import '../content/localized_text.dart';
import '../settings/settings_controller.dart';
import 'asset_catalog.dart';
import 'audio_backend.dart';

enum VoiceState { idle, playing, unavailable }

/// Plays pre-recorded `assets/audio/<lang>/<key>.mp3`. Works with zero files:
/// every key is then [VoiceState.unavailable] and nothing else changes.
class VoiceService extends ChangeNotifier {
  VoiceService({
    required this._backend,
    required this._catalog,
    required this._settings,
  }) : _lang = _settings.value.language ?? AppLanguage.ru {
    _completeSub = _backend.onComplete.listen((_) => _finish());
    _settings.addListener(_onSettings);
  }

  final AudioBackend _backend;
  final AssetCatalog _catalog;
  final SettingsController _settings;
  late final StreamSubscription<void> _completeSub;
  AppLanguage _lang;
  String? _playingKey;
  String? _playingPath;
  final Set<String> _failedPaths = {};
  bool _disposed = false;

  AppLanguage get _language => _settings.value.language ?? AppLanguage.ru;

  String pathFor(String key) => 'assets/audio/${_language.name}/$key.mp3';

  /// Key currently playing, or null.
  String? get playingKey => _playingKey;

  bool isAvailable(String key) {
    final path = pathFor(key);
    return _catalog.has(path) && !_failedPaths.contains(path);
  }

  VoiceState stateOf(String key) {
    if (_playingKey == key) return VoiceState.playing;
    return isAvailable(key) ? VoiceState.idle : VoiceState.unavailable;
  }

  /// Starts [key] (stopping anything else). No-op when unavailable.
  Future<void> play(String key) async {
    if (!isAvailable(key)) return;
    final path = pathFor(key);
    _playingKey = key;
    _playingPath = path;
    notifyListeners();
    try {
      await _backend.play(path, rate: _settings.value.voiceSpeed.rate);
    } catch (_) {
      // A superseded (or stopped) call must not poison its file or state.
      if (_playingKey != key || _playingPath != path) return;
      _failedPaths.add(path);
      _playingKey = null;
      _playingPath = null;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> stop() async {
    final wasPlaying = _playingKey != null;
    _playingKey = null;
    _playingPath = null;
    try {
      await _backend.stop();
    } catch (_) {
      // nothing to stop
    }
    if (wasPlaying && !_disposed) notifyListeners();
  }

  Future<void> toggle(String key) => _playingKey == key ? stop() : play(key);

  void _finish() {
    if (_playingKey == null) return;
    _playingKey = null;
    _playingPath = null;
    notifyListeners();
  }

  void _onSettings() {
    final lang = _language;
    if (lang == _lang) return;
    _lang = lang;
    stop();
  }

  @override
  void dispose() {
    _disposed = true;
    _settings.removeListener(_onSettings);
    _completeSub.cancel();
    _backend.stop().catchError((Object _) {});
    _backend.dispose().catchError((Object _) {});
    super.dispose();
  }
}
