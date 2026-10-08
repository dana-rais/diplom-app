import 'package:flutter/services.dart';

import '../settings/settings_controller.dart';
import 'asset_catalog.dart';
import 'audio_backend.dart';

const kSuccessSfxPath = 'assets/audio/sfx/success.mp3';

/// Success feedback: light haptic + soft sound (if the file is bundled), only
/// when «Звук и вибрация» is on. A miss produces no feedback at all.
class FeedbackService {
  FeedbackService({
    required this._settings,
    required this._catalog,
    required this._sfx,
    Future<void> Function()? haptic,
  }) : _haptic = haptic ?? HapticFeedback.lightImpact;

  final SettingsController _settings;
  final AssetCatalog _catalog;
  final AudioBackend _sfx;
  final Future<void> Function() _haptic;

  Future<void> success() async {
    if (!_settings.value.soundAndHaptics) return;
    try {
      await _haptic();
    } catch (_) {
      // haptics are optional
    }
    if (!_catalog.has(kSuccessSfxPath)) return;
    try {
      await _sfx.play(kSuccessSfxPath);
    } catch (_) {
      // sound is optional
    }
  }

  Future<void> dispose() => _sfx.dispose();
}
