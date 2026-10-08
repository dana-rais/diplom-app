import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/audio/asset_catalog.dart';
import 'package:kadam/core/audio/feedback_service.dart';
import 'package:kadam/core/audio/voice_service.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/settings/app_settings.dart';
import 'package:kadam/core/settings/settings_controller.dart';
import 'package:kadam/core/settings/settings_repository.dart';

import '../support/support.dart';

void main() {
  late FakeAudioBackend backend;
  late SettingsController settings;
  late VoiceService voice;

  VoiceService make(Set<String> files, {AppSettings? s}) {
    backend = FakeAudioBackend();
    settings = SettingsController(
      SettingsRepository(InMemoryStore()),
      initial: s ?? const AppSettings(language: AppLanguage.kk),
    );
    return voice = VoiceService(
      backend: backend,
      catalog: AssetCatalog.fromSet(files),
      settings: settings,
    );
  }

  test('pathFor uses the current language', () async {
    make({});
    expect(voice.pathFor('a.b'), 'assets/audio/kk/a.b.mp3');
    await settings.update((s) => s.copyWith(language: AppLanguage.ru));
    expect(voice.pathFor('a.b'), 'assets/audio/ru/a.b.mp3');
  });

  test('no language yet falls back to ru', () {
    make({}, s: AppSettings.defaults);
    expect(voice.pathFor('x'), 'assets/audio/ru/x.mp3');
  });

  test('zero audio files: everything unavailable, play is a no-op', () async {
    make({});
    expect(voice.isAvailable('a'), isFalse);
    expect(voice.stateOf('a'), VoiceState.unavailable);
    var n = 0;
    voice.addListener(() => n++);
    await voice.play('a');
    await voice.toggle('a');
    expect(backend.played, isEmpty);
    expect(voice.playingKey, isNull);
    expect(n, 0);
  });

  test('play -> playing -> complete -> idle', () async {
    make({'assets/audio/kk/a.mp3'});
    expect(voice.stateOf('a'), VoiceState.idle);
    await voice.play('a');
    expect(voice.stateOf('a'), VoiceState.playing);
    expect(voice.playingKey, 'a');
    expect(backend.lastPath, 'assets/audio/kk/a.mp3');
    backend.complete();
    expect(voice.stateOf('a'), VoiceState.idle);
    expect(voice.playingKey, isNull);
  });

  test('toggle starts then stops', () async {
    make({'assets/audio/kk/a.mp3'});
    await voice.toggle('a');
    expect(voice.stateOf('a'), VoiceState.playing);
    await voice.toggle('a');
    expect(voice.stateOf('a'), VoiceState.idle);
    expect(backend.stopCount, 1);
  });

  test('starting another key replaces the current one', () async {
    make({'assets/audio/kk/a.mp3', 'assets/audio/kk/b.mp3'});
    await voice.play('a');
    await voice.play('b');
    expect(voice.stateOf('a'), VoiceState.idle);
    expect(voice.stateOf('b'), VoiceState.playing);
  });

  test('slow speed plays at rate 0.85', () async {
    make(
      {'assets/audio/kk/a.mp3'},
      s: const AppSettings(
        language: AppLanguage.kk,
        voiceSpeed: VoiceSpeed.slow,
      ),
    );
    await voice.play('a');
    expect(backend.played.single.rate, 0.85);
  });

  test('backend error marks the key unavailable', () async {
    make({'assets/audio/kk/a.mp3', 'assets/audio/kk/b.mp3'});
    backend.failPaths.add('assets/audio/kk/a.mp3');
    await voice.play('a');
    expect(voice.stateOf('a'), VoiceState.unavailable);
    expect(voice.playingKey, isNull);
    expect(voice.stateOf('b'), VoiceState.idle);
  });

  test(
    'language change stops playback and re-evaluates availability',
    () async {
      make({'assets/audio/kk/a.mp3'});
      await voice.play('a');
      await settings.update((s) => s.copyWith(language: AppLanguage.ru));
      expect(voice.playingKey, isNull);
      expect(backend.stopCount, greaterThan(0));
      expect(voice.stateOf('a'), VoiceState.unavailable);
    },
  );

  test('stop when idle does not notify', () async {
    make({});
    var n = 0;
    voice.addListener(() => n++);
    await voice.stop();
    expect(n, 0);
  });

  test('dispose stops and disposes the backend', () async {
    make({});
    voice.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(backend.disposed, isTrue);
  });

  group('FeedbackService', () {
    FeedbackService feedback(
      Set<String> files,
      FakeAudioBackend sfx,
      AppSettings s,
      List<String> log,
    ) => FeedbackService(
      settings: SettingsController(
        SettingsRepository(InMemoryStore()),
        initial: s,
      ),
      catalog: AssetCatalog.fromSet(files),
      sfx: sfx,
      haptic: () async => log.add('haptic'),
    );

    test('haptic + sound when enabled and file present', () async {
      final sfx = FakeAudioBackend();
      final log = <String>[];
      await feedback(
        {kSuccessSfxPath},
        sfx,
        AppSettings.defaults,
        log,
      ).success();
      expect(log, ['haptic']);
      expect(sfx.lastPath, kSuccessSfxPath);
    });
    test('haptic only when the sound file is missing', () async {
      final sfx = FakeAudioBackend();
      final log = <String>[];
      await feedback({}, sfx, AppSettings.defaults, log).success();
      expect(log, ['haptic']);
      expect(sfx.played, isEmpty);
    });
    test('nothing when soundAndHaptics is off', () async {
      final sfx = FakeAudioBackend();
      final log = <String>[];
      await feedback(
        {kSuccessSfxPath},
        sfx,
        const AppSettings(soundAndHaptics: false),
        log,
      ).success();
      expect(log, isEmpty);
      expect(sfx.played, isEmpty);
    });
  });

  test(
    'superseded play failure does not mark the old file unavailable',
    () async {
      make({'assets/audio/kk/a.mp3', 'assets/audio/kk/b.mp3'});
      final gate = Completer<void>();
      backend.gates['assets/audio/kk/a.mp3'] = gate;
      final first = voice.play('a');
      await voice.play('b');
      gate.completeError(StateError('late failure'));
      await first;
      expect(voice.isAvailable('a'), isTrue);
      expect(voice.playingKey, 'b');
      expect(voice.stateOf('b'), VoiceState.playing);
    },
  );

  test('current play failure still marks the file unavailable', () async {
    make({'assets/audio/kk/a.mp3'});
    backend.failPaths.add('assets/audio/kk/a.mp3');
    await voice.play('a');
    expect(voice.stateOf('a'), VoiceState.unavailable);
    expect(voice.playingKey, isNull);
  });
}
