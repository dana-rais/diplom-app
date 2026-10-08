import 'package:flutter/services.dart';

import '../audio/asset_catalog.dart';
import '../audio/audio_backend.dart';
import '../audio/audioplayers_backend.dart';
import '../audio/feedback_service.dart';
import '../audio/voice_service.dart';
import '../progress/progress_controller.dart';
import '../progress/progress_repository.dart';
import '../settings/app_settings.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_repository.dart';
import '../storage/key_value_store.dart';

/// Long-lived app services.
class AppServices {
  AppServices({
    required this.store,
    required this.assets,
    required this.settings,
    required this.progress,
    required this.voice,
    required this.feedback,
  });

  /// Production wiring: shared_preferences + audioplayers + bundled assets.
  static Future<AppServices> create() async {
    final store = await SharedPrefsStore.open();
    final assets = await AssetCatalog.load(rootBundle);
    return _wire(store, assets, AudioplayersBackend(), AudioplayersBackend());
  }

  /// Test wiring: in-memory store, silent (or fake) backends, no real assets.
  factory AppServices.forTest({
    KeyValueStore? store,
    AppSettings? settings,
    AudioBackend? backend,
    AudioBackend? sfxBackend,
    Set<String> audioAssets = const {},
    Future<void> Function()? haptic,
  }) {
    final s = store ?? InMemoryStore();
    return _wire(
      s,
      AssetCatalog.fromSet(audioAssets),
      backend ?? NullAudioBackend(),
      sfxBackend ?? NullAudioBackend(),
      initialSettings: settings,
      haptic: haptic ?? () async {},
    );
  }

  static AppServices _wire(
    KeyValueStore store,
    AssetCatalog assets,
    AudioBackend backend,
    AudioBackend sfxBackend, {
    AppSettings? initialSettings,
    Future<void> Function()? haptic,
  }) {
    final settings = SettingsController(
      SettingsRepository(store),
      initial: initialSettings,
    );
    return AppServices(
      store: store,
      assets: assets,
      settings: settings,
      progress: ProgressController(ProgressRepository(store)),
      voice: VoiceService(
        backend: backend,
        catalog: assets,
        settings: settings,
      ),
      feedback: FeedbackService(
        settings: settings,
        catalog: assets,
        sfx: sfxBackend,
        haptic: haptic,
      ),
    );
  }

  final KeyValueStore store;
  final AssetCatalog assets;
  final SettingsController settings;
  final ProgressController progress;
  final VoiceService voice;
  final FeedbackService feedback;

  void dispose() {
    voice.dispose();
    feedback.dispose();
    progress.dispose();
    settings.dispose();
  }
}
