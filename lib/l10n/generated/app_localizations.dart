import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Қадам / Шаг'**
  String get appTitle;

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get back;

  /// No description provided for @toHome.
  ///
  /// In ru, this message translates to:
  /// **'На главную'**
  String get toHome;

  /// No description provided for @next.
  ///
  /// In ru, this message translates to:
  /// **'Дальше'**
  String get next;

  /// No description provided for @start.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get start;

  /// No description provided for @voicePlay.
  ///
  /// In ru, this message translates to:
  /// **'Озвучить'**
  String get voicePlay;

  /// No description provided for @voiceStop.
  ///
  /// In ru, this message translates to:
  /// **'Остановить'**
  String get voiceStop;

  /// No description provided for @voiceUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Озвучка недоступна'**
  String get voiceUnavailable;

  /// No description provided for @hint.
  ///
  /// In ru, this message translates to:
  /// **'Подсказка'**
  String get hint;

  /// No description provided for @repeat.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get repeat;

  /// No description provided for @notAvailableYet.
  ///
  /// In ru, this message translates to:
  /// **'Пока недоступно'**
  String get notAvailableYet;

  /// No description provided for @on.
  ///
  /// In ru, this message translates to:
  /// **'Вкл'**
  String get on;

  /// No description provided for @off.
  ///
  /// In ru, this message translates to:
  /// **'Выкл'**
  String get off;

  /// No description provided for @stepOf.
  ///
  /// In ru, this message translates to:
  /// **'Шаг {current} из {total}'**
  String stepOf(int current, int total);

  /// No description provided for @situationOf.
  ///
  /// In ru, this message translates to:
  /// **'Ситуация {current} из {total}'**
  String situationOf(int current, int total);

  /// No description provided for @trainingMode.
  ///
  /// In ru, this message translates to:
  /// **'Учебный режим'**
  String get trainingMode;

  /// No description provided for @trainingCall.
  ///
  /// In ru, this message translates to:
  /// **'Учебный звонок'**
  String get trainingCall;

  /// No description provided for @trainingSms.
  ///
  /// In ru, this message translates to:
  /// **'Учебное SMS'**
  String get trainingSms;

  /// No description provided for @trainingShort.
  ///
  /// In ru, this message translates to:
  /// **'Учебный'**
  String get trainingShort;

  /// No description provided for @feedbackSuccessTitle.
  ///
  /// In ru, this message translates to:
  /// **'Отлично!'**
  String get feedbackSuccessTitle;

  /// No description provided for @feedbackSuccessBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы нажали правильно'**
  String get feedbackSuccessBody;

  /// No description provided for @feedbackAlmostTitle.
  ///
  /// In ru, this message translates to:
  /// **'Почти получилось'**
  String get feedbackAlmostTitle;

  /// No description provided for @feedbackAlmostBody.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте ещё раз — я подскажу'**
  String get feedbackAlmostBody;

  /// No description provided for @exitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из урока?'**
  String get exitTitle;

  /// No description provided for @exitBody.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс сохранится. Продолжите с этого места.'**
  String get exitBody;

  /// No description provided for @exitStay.
  ///
  /// In ru, this message translates to:
  /// **'Остаться в уроке'**
  String get exitStay;

  /// No description provided for @exitLeave.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get exitLeave;

  /// No description provided for @introHeading.
  ///
  /// In ru, this message translates to:
  /// **'Чему научимся?'**
  String get introHeading;

  /// No description provided for @summaryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Урок пройден'**
  String get summaryTitle;

  /// No description provided for @summaryDone.
  ///
  /// In ru, this message translates to:
  /// **'Получилось'**
  String get summaryDone;

  /// No description provided for @summaryRepeat.
  ///
  /// In ru, this message translates to:
  /// **'Стоит повторить'**
  String get summaryRepeat;

  /// No description provided for @summaryRetryNote.
  ///
  /// In ru, this message translates to:
  /// **'Понадобилась подсказка или вторая попытка'**
  String get summaryRetryNote;

  /// No description provided for @summaryAgain.
  ///
  /// In ru, this message translates to:
  /// **'Пройти ещё раз'**
  String get summaryAgain;

  /// No description provided for @choiceFootnote.
  ///
  /// In ru, this message translates to:
  /// **'Здесь нет неправильных ответов — после выбора разберём ситуацию вместе.'**
  String get choiceFootnote;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get navHome;

  /// No description provided for @navProgress.
  ///
  /// In ru, this message translates to:
  /// **'Мой прогресс'**
  String get navProgress;

  /// No description provided for @navProgressShort.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get navProgressShort;

  /// No description provided for @navSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get navSettings;

  /// No description provided for @greeting.
  ///
  /// In ru, this message translates to:
  /// **'Добрый день!'**
  String get greeting;

  /// No description provided for @homeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Чему научимся?'**
  String get homeSubtitle;

  /// No description provided for @continueHere.
  ///
  /// In ru, this message translates to:
  /// **'Вы остановились здесь'**
  String get continueHere;

  /// No description provided for @continueLesson.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить урок'**
  String get continueLesson;

  /// No description provided for @lessonsHeader.
  ///
  /// In ru, this message translates to:
  /// **'Уроки'**
  String get lessonsHeader;

  /// No description provided for @moduleProgress.
  ///
  /// In ru, this message translates to:
  /// **'{done} из {total, plural, one{{total} урока} few{{total} уроков} many{{total} уроков} other{{total} уроков}}'**
  String moduleProgress(int done, int total);

  /// No description provided for @moduleNotStarted.
  ///
  /// In ru, this message translates to:
  /// **'Ещё не начат · {total, plural, one{{total} урок} few{{total} урока} many{{total} уроков} other{{total} уроков}}'**
  String moduleNotStarted(int total);

  /// No description provided for @repeatDifficult.
  ///
  /// In ru, this message translates to:
  /// **'Повторить трудное · {count, plural, one{{count} урок} few{{count} урока} many{{count} уроков} other{{count} уроков}}'**
  String repeatDifficult(int count);

  /// No description provided for @lessonStatusDone.
  ///
  /// In ru, this message translates to:
  /// **'Пройден'**
  String get lessonStatusDone;

  /// No description provided for @lessonStatusNew.
  ///
  /// In ru, this message translates to:
  /// **'Новый'**
  String get lessonStatusNew;

  /// No description provided for @lessonStatusResume.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить: шаг {step} из {total}'**
  String lessonStatusResume(int step, int total);

  /// No description provided for @onbWelcome.
  ///
  /// In ru, this message translates to:
  /// **'Сәлеметсіз бе! Здравствуйте!'**
  String get onbWelcome;

  /// No description provided for @onbChooseLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Тілді таңдаңыз. Выберите язык.'**
  String get onbChooseLanguage;

  /// No description provided for @onbHelperNote.
  ///
  /// In ru, this message translates to:
  /// **'Баптауға жақындарыңыз көмектесе алады. Можно попросить близких помочь с настройкой.'**
  String get onbHelperNote;

  /// No description provided for @langKk.
  ///
  /// In ru, this message translates to:
  /// **'Қазақша'**
  String get langKk;

  /// No description provided for @langKkSub.
  ///
  /// In ru, this message translates to:
  /// **'Қазақ тілінде жалғастыру'**
  String get langKkSub;

  /// No description provided for @langRu.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get langRu;

  /// No description provided for @langRuSub.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить на русском'**
  String get langRuSub;

  /// No description provided for @onbSetupOf.
  ///
  /// In ru, this message translates to:
  /// **'Настройка {current} из {total}'**
  String onbSetupOf(int current, int total);

  /// No description provided for @onbTextQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Вам удобно читать этот текст?'**
  String get onbTextQuestion;

  /// No description provided for @onbTextCurrent.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас: {level}'**
  String onbTextCurrent(String level);

  /// No description provided for @onbTextBody.
  ///
  /// In ru, this message translates to:
  /// **'Если этот текст хорошо видно, нажмите «Да, удобно». Если нет — «Крупнее».'**
  String get onbTextBody;

  /// No description provided for @onbTextYes.
  ///
  /// In ru, this message translates to:
  /// **'Да, удобно'**
  String get onbTextYes;

  /// No description provided for @onbTextSmaller.
  ///
  /// In ru, this message translates to:
  /// **'Мельче'**
  String get onbTextSmaller;

  /// No description provided for @onbTextBigger.
  ///
  /// In ru, this message translates to:
  /// **'Крупнее'**
  String get onbTextBigger;

  /// No description provided for @textScaleNormal.
  ///
  /// In ru, this message translates to:
  /// **'Обычный (100%)'**
  String get textScaleNormal;

  /// No description provided for @textScaleLarge.
  ///
  /// In ru, this message translates to:
  /// **'Крупный (125%)'**
  String get textScaleLarge;

  /// No description provided for @textScaleXLarge.
  ///
  /// In ru, this message translates to:
  /// **'Очень крупный (150%)'**
  String get textScaleXLarge;

  /// No description provided for @textScaleMax.
  ///
  /// In ru, this message translates to:
  /// **'Максимальный (200%)'**
  String get textScaleMax;

  /// No description provided for @onbVoiceQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Читать задания вслух?'**
  String get onbVoiceQuestion;

  /// No description provided for @onbVoiceListen.
  ///
  /// In ru, this message translates to:
  /// **'Послушать пример'**
  String get onbVoiceListen;

  /// No description provided for @onbVoiceYes.
  ///
  /// In ru, this message translates to:
  /// **'Да, читать вслух'**
  String get onbVoiceYes;

  /// No description provided for @onbVoiceNo.
  ///
  /// In ru, this message translates to:
  /// **'Нет, не нужно'**
  String get onbVoiceNo;

  /// No description provided for @onbThemeQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Какое оформление удобнее?'**
  String get onbThemeQuestion;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeHighContrast.
  ///
  /// In ru, this message translates to:
  /// **'Высокий контраст'**
  String get themeHighContrast;

  /// No description provided for @onbSafeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Здесь можно ошибаться'**
  String get onbSafeTitle;

  /// No description provided for @onbSafeBody.
  ///
  /// In ru, this message translates to:
  /// **'Это учебное приложение. Деньги и данные ненастоящие, ничего нельзя сломать.'**
  String get onbSafeBody;

  /// No description provided for @onbFirstTapTitle.
  ///
  /// In ru, this message translates to:
  /// **'Первое нажатие'**
  String get onbFirstTapTitle;

  /// No description provided for @onbFirstTapButton.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите сюда'**
  String get onbFirstTapButton;

  /// No description provided for @onbFirstTapAlmost.
  ///
  /// In ru, this message translates to:
  /// **'Почти! Нажмите на кнопку ниже.'**
  String get onbFirstTapAlmost;

  /// No description provided for @progressTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мой прогресс'**
  String get progressTitle;

  /// No description provided for @progressEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет пройденных уроков. Начните с главной страницы.'**
  String get progressEmpty;

  /// No description provided for @difficultTitle.
  ///
  /// In ru, this message translates to:
  /// **'Повторить трудное'**
  String get difficultTitle;

  /// No description provided for @difficultEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Трудных уроков нет. Отличная работа!'**
  String get difficultEmpty;

  /// No description provided for @achievementsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Достижения'**
  String get achievementsTitle;

  /// No description provided for @achFirstLessonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Первый урок'**
  String get achFirstLessonTitle;

  /// No description provided for @achFirstLessonBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы прошли свой первый урок.'**
  String get achFirstLessonBody;

  /// No description provided for @achGesturesDoneTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мастер жестов'**
  String get achGesturesDoneTitle;

  /// No description provided for @achGesturesDoneBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы прошли все уроки по жестам.'**
  String get achGesturesDoneBody;

  /// No description provided for @achFirstCallTitle.
  ///
  /// In ru, this message translates to:
  /// **'Первый звонок'**
  String get achFirstCallTitle;

  /// No description provided for @achFirstCallBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы научились звонить близким.'**
  String get achFirstCallBody;

  /// No description provided for @achFirstPaymentTitle.
  ///
  /// In ru, this message translates to:
  /// **'Первая оплата'**
  String get achFirstPaymentTitle;

  /// No description provided for @achFirstPaymentBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы оплатили счёт в учебном банке.'**
  String get achFirstPaymentBody;

  /// No description provided for @achScamShieldTitle.
  ///
  /// In ru, this message translates to:
  /// **'Щит от мошенников'**
  String get achScamShieldTitle;

  /// No description provided for @achScamShieldBody.
  ///
  /// In ru, this message translates to:
  /// **'Вы разобрали все ситуации с мошенниками.'**
  String get achScamShieldBody;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @previewLabel.
  ///
  /// In ru, this message translates to:
  /// **'Так будет выглядеть урок'**
  String get previewLabel;

  /// No description provided for @previewText.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите на кнопку внизу'**
  String get previewText;

  /// No description provided for @textSizeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Размер текста · {level}'**
  String textSizeLabel(String level);

  /// No description provided for @themeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get themeLabel;

  /// No description provided for @voiceLabel.
  ///
  /// In ru, this message translates to:
  /// **'Озвучка'**
  String get voiceLabel;

  /// No description provided for @voiceAuto.
  ///
  /// In ru, this message translates to:
  /// **'Читать задания вслух'**
  String get voiceAuto;

  /// No description provided for @voiceSlow.
  ///
  /// In ru, this message translates to:
  /// **'Медленно'**
  String get voiceSlow;

  /// No description provided for @voiceNormal.
  ///
  /// In ru, this message translates to:
  /// **'Обычно'**
  String get voiceNormal;

  /// No description provided for @soundHaptics.
  ///
  /// In ru, this message translates to:
  /// **'Звук и вибрация'**
  String get soundHaptics;

  /// No description provided for @languageLabel.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get languageLabel;

  /// No description provided for @helperSection.
  ///
  /// In ru, this message translates to:
  /// **'Для помощника'**
  String get helperSection;

  /// No description provided for @resetProgress.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить прогресс'**
  String get resetProgress;

  /// No description provided for @resetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить прогресс?'**
  String get resetTitle;

  /// No description provided for @resetBody.
  ///
  /// In ru, this message translates to:
  /// **'Все уроки снова станут новыми. Настройки сохранятся.'**
  String get resetBody;

  /// No description provided for @resetConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Да, сбросить'**
  String get resetConfirm;

  /// No description provided for @resetCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get resetCancel;

  /// No description provided for @about.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In ru, this message translates to:
  /// **'Қадам / Шаг — тренажёр цифровой грамотности. Здесь всё учебное: деньги и данные ненастоящие. Работает без интернета.'**
  String get aboutBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
