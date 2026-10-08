// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Қадам / Шаг';

  @override
  String get back => 'Назад';

  @override
  String get toHome => 'На главную';

  @override
  String get next => 'Дальше';

  @override
  String get start => 'Начать';

  @override
  String get voicePlay => 'Озвучить';

  @override
  String get voiceStop => 'Остановить';

  @override
  String get voiceUnavailable => 'Озвучка недоступна';

  @override
  String get hint => 'Подсказка';

  @override
  String get repeat => 'Повторить';

  @override
  String get notAvailableYet => 'Пока недоступно';

  @override
  String get on => 'Вкл';

  @override
  String get off => 'Выкл';

  @override
  String stepOf(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String situationOf(int current, int total) {
    return 'Ситуация $current из $total';
  }

  @override
  String get trainingMode => 'Учебный режим';

  @override
  String get trainingCall => 'Учебный звонок';

  @override
  String get trainingSms => 'Учебное SMS';

  @override
  String get trainingShort => 'Учебный';

  @override
  String get feedbackSuccessTitle => 'Отлично!';

  @override
  String get feedbackSuccessBody => 'Вы нажали правильно';

  @override
  String get feedbackAlmostTitle => 'Почти получилось';

  @override
  String get feedbackAlmostBody => 'Попробуйте ещё раз — я подскажу';

  @override
  String get exitTitle => 'Выйти из урока?';

  @override
  String get exitBody => 'Прогресс сохранится. Продолжите с этого места.';

  @override
  String get exitStay => 'Остаться в уроке';

  @override
  String get exitLeave => 'Выйти';

  @override
  String get introHeading => 'Чему научимся?';

  @override
  String get summaryTitle => 'Урок пройден';

  @override
  String get summaryDone => 'Получилось';

  @override
  String get summaryRepeat => 'Стоит повторить';

  @override
  String get summaryRetryNote => 'Понадобилась подсказка или вторая попытка';

  @override
  String get summaryAgain => 'Пройти ещё раз';

  @override
  String get choiceFootnote =>
      'Здесь нет неправильных ответов — после выбора разберём ситуацию вместе.';

  @override
  String get navHome => 'Главная';

  @override
  String get navProgress => 'Мой прогресс';

  @override
  String get navProgressShort => 'Прогресс';

  @override
  String get navSettings => 'Настройки';

  @override
  String get greeting => 'Добрый день!';

  @override
  String get homeSubtitle => 'Чему научимся?';

  @override
  String get continueHere => 'Вы остановились здесь';

  @override
  String get continueLesson => 'Продолжить урок';

  @override
  String get lessonsHeader => 'Уроки';

  @override
  String moduleProgress(int done, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total уроков',
      many: '$total уроков',
      few: '$total уроков',
      one: '$total урока',
    );
    return '$done из $_temp0';
  }

  @override
  String moduleNotStarted(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total уроков',
      many: '$total уроков',
      few: '$total урока',
      one: '$total урок',
    );
    return 'Ещё не начат · $_temp0';
  }

  @override
  String repeatDifficult(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уроков',
      many: '$count уроков',
      few: '$count урока',
      one: '$count урок',
    );
    return 'Повторить трудное · $_temp0';
  }

  @override
  String get lessonStatusDone => 'Пройден';

  @override
  String get lessonStatusNew => 'Новый';

  @override
  String lessonStatusResume(int step, int total) {
    return 'Продолжить: шаг $step из $total';
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
    return 'Настройка $current из $total';
  }

  @override
  String get onbTextQuestion => 'Вам удобно читать этот текст?';

  @override
  String onbTextCurrent(String level) {
    return 'Сейчас: $level';
  }

  @override
  String get onbTextBody =>
      'Если этот текст хорошо видно, нажмите «Да, удобно». Если нет — «Крупнее».';

  @override
  String get onbTextYes => 'Да, удобно';

  @override
  String get onbTextSmaller => 'Мельче';

  @override
  String get onbTextBigger => 'Крупнее';

  @override
  String get textScaleNormal => 'Обычный (100%)';

  @override
  String get textScaleLarge => 'Крупный (125%)';

  @override
  String get textScaleXLarge => 'Очень крупный (150%)';

  @override
  String get textScaleMax => 'Максимальный (200%)';

  @override
  String get onbVoiceQuestion => 'Читать задания вслух?';

  @override
  String get onbVoiceListen => 'Послушать пример';

  @override
  String get onbVoiceYes => 'Да, читать вслух';

  @override
  String get onbVoiceNo => 'Нет, не нужно';

  @override
  String get onbThemeQuestion => 'Какое оформление удобнее?';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeHighContrast => 'Высокий контраст';

  @override
  String get onbSafeTitle => 'Здесь можно ошибаться';

  @override
  String get onbSafeBody =>
      'Это учебное приложение. Деньги и данные ненастоящие, ничего нельзя сломать.';

  @override
  String get onbFirstTapTitle => 'Первое нажатие';

  @override
  String get onbFirstTapButton => 'Нажмите сюда';

  @override
  String get onbFirstTapAlmost => 'Почти! Нажмите на кнопку ниже.';

  @override
  String get progressTitle => 'Мой прогресс';

  @override
  String get progressEmpty =>
      'Пока нет пройденных уроков. Начните с главной страницы.';

  @override
  String get difficultTitle => 'Повторить трудное';

  @override
  String get difficultEmpty => 'Трудных уроков нет. Отличная работа!';

  @override
  String get achievementsTitle => 'Достижения';

  @override
  String get achFirstLessonTitle => 'Первый урок';

  @override
  String get achFirstLessonBody => 'Вы прошли свой первый урок.';

  @override
  String get achGesturesDoneTitle => 'Мастер жестов';

  @override
  String get achGesturesDoneBody => 'Вы прошли все уроки по жестам.';

  @override
  String get achFirstCallTitle => 'Первый звонок';

  @override
  String get achFirstCallBody => 'Вы научились звонить близким.';

  @override
  String get achFirstPaymentTitle => 'Первая оплата';

  @override
  String get achFirstPaymentBody => 'Вы оплатили счёт в учебном банке.';

  @override
  String get achScamShieldTitle => 'Щит от мошенников';

  @override
  String get achScamShieldBody => 'Вы разобрали все ситуации с мошенниками.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get previewLabel => 'Так будет выглядеть урок';

  @override
  String get previewText => 'Нажмите на кнопку внизу';

  @override
  String textSizeLabel(String level) {
    return 'Размер текста · $level';
  }

  @override
  String get themeLabel => 'Тема';

  @override
  String get voiceLabel => 'Озвучка';

  @override
  String get voiceAuto => 'Читать задания вслух';

  @override
  String get voiceSlow => 'Медленно';

  @override
  String get voiceNormal => 'Обычно';

  @override
  String get soundHaptics => 'Звук и вибрация';

  @override
  String get languageLabel => 'Язык';

  @override
  String get helperSection => 'Для помощника';

  @override
  String get resetProgress => 'Сбросить прогресс';

  @override
  String get resetTitle => 'Сбросить прогресс?';

  @override
  String get resetBody =>
      'Все уроки снова станут новыми. Настройки сохранятся.';

  @override
  String get resetConfirm => 'Да, сбросить';

  @override
  String get resetCancel => 'Отмена';

  @override
  String get about => 'О приложении';

  @override
  String get aboutBody =>
      'Қадам / Шаг — тренажёр цифровой грамотности. Здесь всё учебное: деньги и данные ненастоящие. Работает без интернета.';
}
