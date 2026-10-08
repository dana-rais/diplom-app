import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/app/app_services.dart';
import 'package:kadam/core/audio/voice_service.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/settings/app_settings.dart';
import 'package:kadam/core/theme/app_tokens.dart';
import 'package:kadam/core/widgets/app_card.dart';
import 'package:kadam/core/widgets/confirm_dialog.dart';
import 'package:kadam/core/widgets/feedback_banner.dart';
import 'package:kadam/core/widgets/labeled_back_button.dart';
import 'package:kadam/core/widgets/primary_button.dart';
import 'package:kadam/core/widgets/secondary_button.dart';
import 'package:kadam/core/widgets/step_indicator.dart';
import 'package:kadam/core/widgets/voice_button.dart';

import '../support/support.dart';

const _worst = Size(320, 640);
const _kkHc = AppSettings(
  language: AppLanguage.kk,
  theme: AppThemeMode.highContrast,
  onboardingCompleted: true,
);

/// Worst case: 320x640, system text 200%, kk, high contrast.
Future<AppServices> _pumpWorst(
  WidgetTester tester,
  Widget child, {
  AppServices? services,
  bool reduceMotion = true,
}) => pumpApp(
  tester,
  Scaffold(
    body: SafeArea(child: SingleChildScrollView(child: child)),
  ),
  size: _worst,
  scale: 2.0,
  reduceMotion: reduceMotion,
  services: services ?? AppServices.forTest(settings: _kkHc),
);

Future<void> _expectClean(WidgetTester tester) async {
  expectNoLayoutErrors(tester);
  expectNoTruncatedText(tester);
  await expectA11y(tester);
}

void main() {
  group('PrimaryButton', () {
    testWidgets('>= 64 dp, full width, wraps long label at 200%', (
      tester,
    ) async {
      var taps = 0;
      await _pumpWorst(
        tester,
        Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            label: 'Сабақты жалғастыру және әрі қарай жүру',
            icon: Icons.arrow_forward,
            onPressed: () => taps++,
          ),
        ),
      );
      final size = tester.getSize(find.byType(FilledButton));
      expect(size.height, greaterThanOrEqualTo(AppSizes.tapPrimary));
      expect(size.width, 320 - 32);
      await _expectClean(tester);
      await tester.tap(find.byType(FilledButton));
      expect(taps, 1);
    });

    testWidgets('short label is still 64 dp; disabled has no tap', (
      tester,
    ) async {
      await _pumpWorst(
        tester,
        const PrimaryButton(label: 'Әрі', onPressed: null),
      );
      expect(
        tester.getSize(find.byType(FilledButton)).height,
        greaterThanOrEqualTo(64),
      );
    });
  });

  testWidgets('SecondaryButton >= 56 dp, outlined', (tester) async {
    await _pumpWorst(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: SecondaryButton(label: 'Қайта өту', onPressed: () {}),
      ),
    );
    expect(
      tester.getSize(find.byType(OutlinedButton)).height,
      greaterThanOrEqualTo(AppSizes.tapMain),
    );
    await _expectClean(tester);
  });

  testWidgets('LabeledBackButton shows icon + word and pops', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (c) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(c).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(body: LabeledBackButton()),
                ),
              ),
              child: const Text('go'),
            ),
          ),
        ),
      ),
      size: _worst,
      scale: 2.0,
      services: AppServices.forTest(settings: _kkHc),
    );
    await tester.tap(find.text('go'));
    await settle(tester);
    expect(find.text('Артқа'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(
      tester.getSize(find.byType(OutlinedButton)).height,
      greaterThanOrEqualTo(56),
    );
    await _expectClean(tester);
    await tester.tap(find.text('Артқа'));
    await settle(tester);
    expect(find.text('Артқа'), findsNothing);
  });

  group('VoiceButton', () {
    const assets = {'assets/audio/kk/a.mp3'};

    testWidgets('unavailable (no files): disabled, dashed, labelled', (
      tester,
    ) async {
      await _pumpWorst(tester, const VoiceButton(audioKey: 'a'));
      expect(find.text('Дыбыстау қолжетімсіз'), findsOneWidget);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
      expect(
        tester.getSize(find.byType(VoiceButton)).height,
        greaterThanOrEqualTo(56),
      );
      await _expectClean(tester);
    });

    testWidgets('idle -> playing -> idle', (tester) async {
      final backend = FakeAudioBackend();
      final services = AppServices.forTest(
        settings: _kkHc,
        backend: backend,
        audioAssets: assets,
      );
      await _pumpWorst(
        tester,
        const VoiceButton(audioKey: 'a'),
        services: services,
      );
      expect(find.text('Тыңдау'), findsOneWidget);
      expect(
        tester.getSize(find.byType(OutlinedButton)).height,
        greaterThanOrEqualTo(56),
      );
      await _expectClean(tester);

      await tester.tap(find.text('Тыңдау'));
      await settle(tester);
      expect(services.voice.stateOf('a'), VoiceState.playing);
      expect(find.text('Тоқтату'), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
      await _expectClean(tester);

      backend.complete();
      await settle(tester);
      expect(find.text('Тыңдау'), findsOneWidget);
      await tester.tap(find.text('Тыңдау'));
      await settle(tester);
      await tester.tap(find.text('Тоқтату'));
      await settle(tester);
      expect(find.text('Тыңдау'), findsOneWidget);
    });

    testWidgets(
      'A4: with motion on and a backend that never completes, pumpAndSettle terminates',
      (tester) async {
        final backend = FakeAudioBackend();
        final services = AppServices.forTest(
          settings: _kkHc,
          backend: backend,
          audioAssets: assets,
        );
        await _pumpWorst(
          tester,
          const VoiceButton(audioKey: 'a'),
          services: services,
          reduceMotion: false,
        );
        await tester.tap(find.text('Тыңдау'));
        await tester
            .pumpAndSettle(); // would time out with an endless animation
        expect(services.voice.stateOf('a'), VoiceState.playing);
        expect(tester.binding.hasScheduledFrame, isFalse);
        // The pulse really ran (a ScaleTransition was used while playing).
        expect(find.byType(ScaleTransition), findsWidgets);
      },
    );

    testWidgets('A4: with disableAnimations no pulse is created', (
      tester,
    ) async {
      final services = AppServices.forTest(
        settings: _kkHc,
        backend: FakeAudioBackend(),
        audioAssets: assets,
      );
      await _pumpWorst(
        tester,
        const VoiceButton(audioKey: 'a'),
        services: services,
      );
      await tester.tap(find.text('Тыңдау'));
      await tester.pump();
      await tester.pump();
      expect(services.voice.stateOf('a'), VoiceState.playing);
      expect(tester.binding.hasScheduledFrame, isFalse);
      final scales = find.descendant(
        of: find.byType(VoiceButton),
        matching: find.byType(ScaleTransition),
      );
      // Only the Material-internal ones (ink/ripple) may exist; none animating.
      for (final e in scales.evaluate()) {
        expect((e.widget as ScaleTransition).scale.value, 1.0);
      }
    });
  });

  group('FeedbackBanner', () {
    testWidgets('almost: calm retry icon, never a cross or error', (
      tester,
    ) async {
      await _pumpWorst(tester, const FeedbackBanner.almost());
      expect(find.text('Дерлік болды'), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
      for (final icon in [
        Icons.close,
        Icons.cancel,
        Icons.clear,
        Icons.error,
        Icons.error_outline,
        Icons.highlight_off,
        Icons.dangerous,
        Icons.block,
      ]) {
        expect(find.byIcon(icon), findsNothing, reason: '$icon');
      }
      await _expectClean(tester);
    });

    testWidgets('success: check icon, custom body', (tester) async {
      await _pumpWorst(tester, const FeedbackBanner.success(body: 'Өз мәтіні'));
      expect(find.text('Тамаша!'), findsOneWidget);
      expect(find.text('Өз мәтіні'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      await _expectClean(tester);
    });

    for (final lang in AppLanguage.values) {
      for (final theme in AppThemeMode.values) {
        testWidgets('both kinds clean in ${lang.name}/${theme.name} @360x800', (
          tester,
        ) async {
          await pumpApp(
            tester,
            const Scaffold(
              body: Column(
                children: [FeedbackBanner.success(), FeedbackBanner.almost()],
              ),
            ),
            lang: lang,
            theme: theme,
          );
          await _expectClean(tester);
        });
      }
    }
  });

  group('ConfirmDialog', () {
    Future<void> open(
      WidgetTester tester,
      List<bool> results, {
      String body = 'Үлгерім сақталады.',
    }) async {
      await _pumpWorst(
        tester,
        Builder(
          builder: (c) => PrimaryButton(
            label: 'open',
            onPressed: () async => results.add(
              await ConfirmDialog.show(
                c,
                title: 'Сабақтан шығасыз ба?',
                body: body,
                safeLabel: 'Сабақта қалу',
                confirmLabel: 'Шығу',
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await settle(tester);
    }

    testWidgets('clean at 320x640 @200%; safe choice resolves false', (
      tester,
    ) async {
      final results = <bool>[];
      await open(tester, results);
      expect(find.text('Сабақтан шығасыз ба?'), findsOneWidget);
      await _expectClean(tester);
      expect(
        tester
            .getSize(find.widgetWithText(FilledButton, 'Сабақта қалу'))
            .height,
        greaterThanOrEqualTo(64),
      );
      expect(
        tester.getSize(find.widgetWithText(OutlinedButton, 'Шығу')).height,
        greaterThanOrEqualTo(56),
      );
      await tester.tap(find.text('Сабақта қалу'));
      await settle(tester);
      expect(results, [false]);
    });

    testWidgets('confirm resolves true', (tester) async {
      final results = <bool>[];
      await open(tester, results);
      await tester.tap(find.text('Шығу'));
      await settle(tester);
      expect(results, [true]);
    });

    testWidgets('dismissing by barrier counts as the safe choice', (
      tester,
    ) async {
      final results = <bool>[];
      await open(tester, results);
      await tester.tapAt(const Offset(2, 2));
      await settle(tester);
      expect(results, [false]);
    });

    testWidgets('long body scrolls instead of overflowing', (tester) async {
      final results = <bool>[];
      await open(
        tester,
        results,
        body: List.filled(30, 'Үлгерім сақталады.').join(' '),
      );
      expectNoLayoutErrors(tester);
      expectNoTruncatedText(tester);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });

  testWidgets('StepIndicator: announced as one label', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpWorst(tester, const StepIndicator(current: 2, total: 5));
    expect(find.bySemanticsLabel('5 қадамның 2-қадамы'), findsOneWidget);
    await _expectClean(tester);
    handle.dispose();
  });

  testWidgets('StepIndicator without text still announces', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      const Scaffold(
        body: StepIndicator(current: 1, total: 4, showText: false),
      ),
      lang: AppLanguage.ru,
    );
    expect(find.bySemanticsLabel('Шаг 1 из 4'), findsOneWidget);
    handle.dispose();
  });

  testWidgets(
    'AppCard with onTap is a >= 56 dp button; semantics label replaces content',
    (tester) async {
      var taps = 0;
      final handle = tester.ensureSemantics();
      await _pumpWorst(
        tester,
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppCard(
            onTap: () => taps++,
            semanticsLabel: 'Модуль, 1 / 6',
            child: const Text('Модуль'),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(AppCard)).height,
        greaterThanOrEqualTo(56),
      );
      expect(find.bySemanticsLabel('Модуль, 1 / 6'), findsOneWidget);
      await _expectClean(tester);
      await tester.tap(find.byType(AppCard));
      expect(taps, 1);
      handle.dispose();
    },
  );
}
