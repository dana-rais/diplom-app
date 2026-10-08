import 'package:flutter/widgets.dart';

import '../content/localized_text.dart';

extension AppLanguageOf on BuildContext {
  /// Language of the current `Localizations` locale (kk, otherwise ru).
  AppLanguage get appLanguage =>
      Localizations.localeOf(this).languageCode == 'kk'
      ? AppLanguage.kk
      : AppLanguage.ru;
}
