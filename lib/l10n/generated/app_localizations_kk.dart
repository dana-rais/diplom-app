// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Қадам / Шаг';

  @override
  String get back => 'Артқа';

  @override
  String get toHome => 'Басты бетке';

  @override
  String get next => 'Әрі қарай';

  @override
  String get start => 'Бастау';

  @override
  String get voicePlay => 'Тыңдау';

  @override
  String get voiceStop => 'Тоқтату';

  @override
  String get voiceUnavailable => 'Дыбыстау қолжетімсіз';

  @override
  String get hint => 'Кеңес';

  @override
  String get repeat => 'Қайталау';

  @override
  String get notAvailableYet => 'Әзірге қолжетімсіз';

  @override
  String get on => 'Қосулы';

  @override
  String get off => 'Өшірулі';

  @override
  String stepOf(int current, int total) {
    return '$total қадамның $current-қадамы';
  }

  @override
  String situationOf(int current, int total) {
    return 'Жағдаят $current / $total';
  }

  @override
  String get trainingMode => 'Оқу режимі';

  @override
  String get trainingCall => 'Оқу қоңырауы';

  @override
  String get trainingSms => 'Оқу SMS-і';

  @override
  String get trainingShort => 'Оқу';

  @override
  String get feedbackSuccessTitle => 'Тамаша!';

  @override
  String get feedbackSuccessBody => 'Сіз дұрыс бастыңыз';

  @override
  String get feedbackAlmostTitle => 'Дерлік болды';

  @override
  String get feedbackAlmostBody => 'Тағы бір рет көріңіз — мен көмектесемін';

  @override
  String get exitTitle => 'Сабақтан шығасыз ба?';

  @override
  String get exitBody => 'Үлгерім сақталады. Осы жерден жалғастыра аласыз.';

  @override
  String get exitStay => 'Сабақта қалу';

  @override
  String get exitLeave => 'Шығу';

  @override
  String get introHeading => 'Не үйренеміз?';

  @override
  String get summaryTitle => 'Сабақ өтілді';

  @override
  String get summaryDone => 'Орындалды';

  @override
  String get summaryRepeat => 'Қайталаған жөн';

  @override
  String get summaryRetryNote => 'Кеңес немесе екінші талпыныс қажет болды';

  @override
  String get summaryAgain => 'Қайта өту';

  @override
  String get choiceFootnote =>
      'Мұнда қате жауап жоқ — таңдағаннан кейін жағдайды бірге талдаймыз.';

  @override
  String get navHome => 'Басты бет';

  @override
  String get navProgress => 'Менің үлгерімім';

  @override
  String get navProgressShort => 'Үлгерім';

  @override
  String get navSettings => 'Баптаулар';

  @override
  String get greeting => 'Қайырлы күн!';

  @override
  String get homeSubtitle => 'Не үйренеміз?';

  @override
  String get continueHere => 'Осы жерде тоқтадыңыз';

  @override
  String get continueLesson => 'Сабақты жалғастыру';

  @override
  String get lessonsHeader => 'Сабақтар';

  @override
  String moduleProgress(int done, int total) {
    return 'Өтілді: $done / $total сабақ';
  }

  @override
  String moduleNotStarted(int total) {
    return 'Әлі басталмаған · $total сабақ';
  }

  @override
  String repeatDifficult(int count) {
    return 'Қиынын қайталау · $count сабақ';
  }

  @override
  String get lessonStatusDone => 'Өтілді';

  @override
  String get lessonStatusNew => 'Жаңа';

  @override
  String lessonStatusResume(int step, int total) {
    return 'Жалғастыру: $step / $total қадам';
  }

  @override
  String get onbWelcome => 'Сәлеметсіз бе! Здравствуйте!';

  @override
  String get onbChooseLanguage => 'Тілді таңдаңыз. Выберите язык.';

  @override
  String get onbHelperNote =>
      'Баптауға жақындарыңыз көмектесе алады. Можно попросить близких помочь с настройкой.';

  @override
  String get langKk => 'Қазақша';

  @override
  String get langKkSub => 'Қазақ тілінде жалғастыру';

  @override
  String get langRu => 'Русский';

  @override
  String get langRuSub => 'Продолжить на русском';

  @override
  String onbSetupOf(int current, int total) {
    return 'Баптау $current / $total';
  }

  @override
  String get onbTextQuestion => 'Бұл мәтінді оқу ыңғайлы ма?';

  @override
  String onbTextCurrent(String level) {
    return 'Қазір: $level';
  }

  @override
  String get onbTextBody =>
      'Бұл мәтін жақсы көрінсе, «Иә, ыңғайлы» түймесін басыңыз. Көрінбесе — «Үлкенірек».';

  @override
  String get onbTextYes => 'Иә, ыңғайлы';

  @override
  String get onbTextSmaller => 'Кішірек';

  @override
  String get onbTextBigger => 'Үлкенірек';

  @override
  String get textScaleNormal => 'Қалыпты (100%)';

  @override
  String get textScaleLarge => 'Ірі (125%)';

  @override
  String get textScaleXLarge => 'Өте ірі (150%)';

  @override
  String get textScaleMax => 'Ең ірі (200%)';

  @override
  String get onbVoiceQuestion => 'Тапсырмаларды дауыстап оқу керек пе?';

  @override
  String get onbVoiceListen => 'Мысалды тыңдау';

  @override
  String get onbVoiceYes => 'Иә, оқысын';

  @override
  String get onbVoiceNo => 'Жоқ, керек емес';

  @override
  String get onbThemeQuestion => 'Қай түс схемасы ыңғайлы?';

  @override
  String get themeLight => 'Ашық';

  @override
  String get themeHighContrast => 'Жоғары контраст';

  @override
  String get onbSafeTitle => 'Мұнда қателесуге болады';

  @override
  String get onbSafeBody =>
      'Бұл оқу қосымшасы. Ақша мен деректер жалған, ештеңені бүлдіру мүмкін емес.';

  @override
  String get onbFirstTapTitle => 'Алғашқы басу';

  @override
  String get onbFirstTapButton => 'Осыны басыңыз';

  @override
  String get onbFirstTapAlmost => 'Дерлік! Төмендегі түймені басыңыз.';

  @override
  String get progressTitle => 'Менің үлгерімім';

  @override
  String get progressEmpty =>
      'Әзірге өтілген сабақ жоқ. Басты беттен бастаңыз.';

  @override
  String get difficultTitle => 'Қиынын қайталау';

  @override
  String get difficultEmpty => 'Қиын сабақ жоқ. Тамаша!';

  @override
  String get achievementsTitle => 'Жетістіктер';

  @override
  String get achFirstLessonTitle => 'Алғашқы сабақ';

  @override
  String get achFirstLessonBody => 'Сіз алғашқы сабақты өттіңіз.';

  @override
  String get achGesturesDoneTitle => 'Қимыл шебері';

  @override
  String get achGesturesDoneBody => 'Қимылдар бойынша барлық сабақты өттіңіз.';

  @override
  String get achFirstCallTitle => 'Алғашқы қоңырау';

  @override
  String get achFirstCallBody => 'Жақындарға қоңырау шалуды үйрендіңіз.';

  @override
  String get achFirstPaymentTitle => 'Алғашқы төлем';

  @override
  String get achFirstPaymentBody => 'Оқу банкінде шотты төледіңіз.';

  @override
  String get achScamShieldTitle => 'Алаяқтардан қорғаныс';

  @override
  String get achScamShieldBody =>
      'Алаяқтармен байланысты барлық жағдайды талдадыңыз.';

  @override
  String get settingsTitle => 'Баптаулар';

  @override
  String get previewLabel => 'Сабақ осылай көрінеді';

  @override
  String get previewText => 'Төмендегі түймені басыңыз';

  @override
  String textSizeLabel(String level) {
    return 'Мәтін өлшемі · $level';
  }

  @override
  String get themeLabel => 'Түс схемасы';

  @override
  String get voiceLabel => 'Дыбыстау';

  @override
  String get voiceAuto => 'Тапсырмаларды дауыстап оқу';

  @override
  String get voiceSlow => 'Баяу';

  @override
  String get voiceNormal => 'Қалыпты';

  @override
  String get soundHaptics => 'Дыбыс және діріл';

  @override
  String get languageLabel => 'Тіл';

  @override
  String get helperSection => 'Көмекшіге арналған';

  @override
  String get resetProgress => 'Үлгерімді тазалау';

  @override
  String get resetTitle => 'Үлгерімді тазалау керек пе?';

  @override
  String get resetBody =>
      'Барлық сабақ қайтадан жаңа болады. Баптаулар сақталады.';

  @override
  String get resetConfirm => 'Иә, тазалау';

  @override
  String get resetCancel => 'Бас тарту';

  @override
  String get about => 'Қосымша туралы';

  @override
  String get aboutBody =>
      'Қадам / Шаг — цифрлық сауаттылық тренажері. Мұнда бәрі оқу үшін: ақша мен деректер жалған. Интернетсіз жұмыс істейді.';
}
