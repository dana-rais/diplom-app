import 'dart:convert';

import '../storage/key_value_store.dart';
import 'app_settings.dart';

const kSettingsKey = 'settings.v1';

class SettingsRepository {
  SettingsRepository(this._store);

  final KeyValueStore _store;

  /// Corrupt, unknown-version or missing data gives [AppSettings.defaults].
  AppSettings load() {
    final raw = _store.getString(kSettingsKey);
    if (raw == null) return AppSettings.defaults;
    try {
      final j = jsonDecode(raw);
      if (j is Map<String, Object?> && j['v'] == 1) {
        return AppSettings.fromJson(j);
      }
    } catch (_) {
      // fall through to defaults
    }
    return AppSettings.defaults;
  }

  Future<void> save(AppSettings s) =>
      _store.setString(kSettingsKey, jsonEncode(s.toJson()));
}
