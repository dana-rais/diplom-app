import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/l10n/generated/app_localizations.dart';

Map<String, dynamic> _arb(String f) =>
    jsonDecode(File('lib/l10n/$f').readAsStringSync()) as Map<String, dynamic>;

void main() {
  final ru = _arb('app_ru.arb');
  final kk = _arb('app_kk.arb');
  Set<String> keys(Map<String, dynamic> m) =>
      m.keys.where((k) => !k.startsWith('@')).toSet();

  test('kk and ru define exactly the same keys, all non-empty', () {
    expect(keys(kk), keys(ru));
    for (final m in [ru, kk]) {
      for (final k in keys(m)) {
        expect((m[k] as String).trim(), isNotEmpty, reason: k);
      }
    }
  });

  test('plan keys are present', () {
    const required = [
      'appTitle',
      'back',
      'toHome',
      'next',
      'start',
      'voicePlay',
      'voiceStop',
      'voiceUnavailable',
      'hint',
      'repeat',
      'notAvailableYet',
      'on',
      'off',
      'stepOf',
      'situationOf',
      'trainingMode',
      'trainingCall',
      'trainingSms',
      'trainingShort',
      'feedbackSuccessTitle',
      'feedbackSuccessBody',
      'feedbackAlmostTitle',
      'feedbackAlmostBody',
      'exitTitle',
      'exitBody',
      'exitStay',
      'exitLeave',
      'introHeading',
      'summaryTitle',
      'summaryDone',
      'summaryRepeat',
      'summaryRetryNote',
      'summaryAgain',
      'choiceFootnote',
      'navHome',
      'navProgress',
      'navProgressShort',
      'navSettings',
      'greeting',
      'homeSubtitle',
      'continueHere',
      'continueLesson',
      'lessonsHeader',
      'moduleProgress',
      'moduleNotStarted',
      'repeatDifficult',
      'lessonStatusDone',
      'lessonStatusNew',
      'lessonStatusResume',
      'onbWelcome',
      'onbChooseLanguage',
      'onbHelperNote',
      'langKk',
      'langKkSub',
      'langRu',
      'langRuSub',
      'onbSetupOf',
      'onbTextQuestion',
      'onbTextCurrent',
      'onbTextBody',
      'onbTextYes',
      'onbTextSmaller',
      'onbTextBigger',
      'textScaleNormal',
      'textScaleLarge',
      'textScaleXLarge',
      'textScaleMax',
      'onbVoiceQuestion',
      'onbVoiceListen',
      'onbVoiceYes',
      'onbVoiceNo',
      'onbThemeQuestion',
      'themeLight',
      'themeHighContrast',
      'onbSafeTitle',
      'onbSafeBody',
      'onbFirstTapTitle',
      'onbFirstTapButton',
      'onbFirstTapAlmost',
      'progressTitle',
      'progressEmpty',
      'difficultTitle',
      'difficultEmpty',
      'achievementsTitle',
      'achFirstLessonTitle',
      'achFirstLessonBody',
      'achGesturesDoneTitle',
      'achGesturesDoneBody',
      'achFirstCallTitle',
      'achFirstCallBody',
      'achFirstPaymentTitle',
      'achFirstPaymentBody',
      'achScamShieldTitle',
      'achScamShieldBody',
      'settingsTitle',
      'previewLabel',
      'previewText',
      'textSizeLabel',
      'themeLabel',
      'voiceLabel',
      'voiceAuto',
      'voiceSlow',
      'voiceNormal',
      'soundHaptics',
      'languageLabel',
      'helperSection',
      'resetProgress',
      'resetTitle',
      'resetBody',
      'resetConfirm',
      'resetCancel',
      'about',
      'aboutBody',
    ];
    expect(keys(ru).containsAll(required), isTrue);
    expect(required.toSet().difference(keys(ru)), isEmpty);
  });

  test('bilingual onboarding strings are identical in both files', () {
    for (final k in [
      'onbWelcome',
      'onbChooseLanguage',
      'onbHelperNote',
      'langKk',
      'langKkSub',
      'langRu',
      'langRuSub',
    ]) {
      expect(kk[k], ru[k], reason: k);
    }
  });

  test('generated localizations resolve both languages', () {
    final ruL = lookupAppLocalizations(const Locale('ru'));
    final kkL = lookupAppLocalizations(const Locale('kk'));
    expect(ruL.back, 'Назад');
    expect(kkL.back, 'Артқа');
    expect(ruL.stepOf(2, 5), 'Шаг 2 из 5');
    expect(kkL.stepOf(2, 5), '5 қадамның 2-қадамы');
    expect(ruL.moduleProgress(3, 7), '3 из 7 уроков');
    expect(ruL.moduleProgress(1, 1), '1 из 1 урока');
    expect(ruL.moduleNotStarted(1), 'Ещё не начат · 1 урок');
    expect(ruL.moduleNotStarted(3), 'Ещё не начат · 3 урока');
    expect(ruL.moduleNotStarted(5), 'Ещё не начат · 5 уроков');
    expect(ruL.repeatDifficult(2), 'Повторить трудное · 2 урока');
    expect(kkL.repeatDifficult(2), 'Қиынын қайталау · 2 сабақ');
    expect(ruL.textSizeLabel('Крупный'), 'Размер текста · Крупный');
  });

  test('supported locales are kk and ru', () {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      {'kk', 'ru'},
    );
  });
}
