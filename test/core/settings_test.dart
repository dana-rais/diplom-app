import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/settings/app_settings.dart';
import 'package:kadam/core/settings/settings_controller.dart';
import 'package:kadam/core/settings/settings_repository.dart';
import 'package:kadam/core/storage/key_value_store.dart';

void main() {
  test('defaults', () {
    const d = AppSettings.defaults;
    expect(d.language, isNull);
    expect(d.textScale, TextScaleStep.s100);
    expect(d.theme, AppThemeMode.light);
    expect(d.voiceAutoPlay, isFalse);
    expect(d.voiceSpeed, VoiceSpeed.normal);
    expect(d.soundAndHaptics, isTrue);
    expect(d.onboardingCompleted, isFalse);
    expect(VoiceSpeed.slow.rate, 0.85);
  });

  test('toJson/fromJson round trip', () {
    const s = AppSettings(
      language: AppLanguage.kk,
      textScale: TextScaleStep.s150,
      theme: AppThemeMode.highContrast,
      voiceAutoPlay: true,
      voiceSpeed: VoiceSpeed.slow,
      soundAndHaptics: false,
      onboardingCompleted: true,
    );
    final back = AppSettings.fromJson(
      jsonDecode(jsonEncode(s.toJson())) as Map<String, Object?>,
    );
    expect(back, s);
    expect(s.toJson()['v'], 1);
  });

  test('copyWith can clear the language', () {
    const s = AppSettings(language: AppLanguage.ru);
    expect(s.copyWith(clearLanguage: true).language, isNull);
    expect(s.copyWith(textScale: TextScaleStep.s200).language, AppLanguage.ru);
  });

  test('fromJson tolerates unknown values', () {
    final s = AppSettings.fromJson({
      'v': 1,
      'language': 'de',
      'textScale': 'huge',
      'theme': 7,
      'voiceAutoPlay': 'yes',
    });
    expect(s, AppSettings.defaults);
  });

  group('repository', () {
    test('missing data gives defaults', () {
      expect(SettingsRepository(InMemoryStore()).load(), AppSettings.defaults);
    });
    test('save then load, stored under settings.v1', () async {
      final store = InMemoryStore();
      const s = AppSettings(
        language: AppLanguage.ru,
        onboardingCompleted: true,
      );
      await SettingsRepository(store).save(s);
      expect(store.values.keys, ['settings.v1']);
      expect(SettingsRepository(store).load(), s);
    });
    for (final bad in [
      'not json',
      '[]',
      '{"v":2,"theme":"highContrast"}',
      '{}',
    ]) {
      test('corrupt/unknown data "$bad" gives defaults', () {
        final store = InMemoryStore({'settings.v1': bad});
        expect(SettingsRepository(store).load(), AppSettings.defaults);
      });
    }
  });

  group('controller', () {
    test('update notifies immediately and persists', () async {
      final store = InMemoryStore();
      final c = SettingsController(SettingsRepository(store));
      var notified = 0;
      c.addListener(() => notified++);
      final f = c.update((s) => s.copyWith(theme: AppThemeMode.highContrast));
      expect(c.value.theme, AppThemeMode.highContrast);
      expect(notified, 1);
      await f;
      expect(SettingsRepository(store).load().theme, AppThemeMode.highContrast);
    });
    test('no-op update does not notify', () async {
      final c = SettingsController(SettingsRepository(InMemoryStore()));
      var notified = 0;
      c.addListener(() => notified++);
      await c.update((s) => s);
      expect(notified, 0);
    });
    test('loads persisted value on creation', () async {
      final store = InMemoryStore();
      await SettingsRepository(store)
          .save(const AppSettings(textScale: TextScaleStep.s125));
      expect(
        SettingsController(SettingsRepository(store)).value.textScale,
        TextScaleStep.s125,
      );
    });
  });
}
