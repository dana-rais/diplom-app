/// Supported content languages.
enum AppLanguage { kk, ru }

/// Inline bilingual text for lesson content.
class LocalizedText {
  const LocalizedText({required this.kk, required this.ru});

  final String kk, ru;

  String resolve(AppLanguage l) => l == AppLanguage.kk ? kk : ru;
}

/// Language-dependent value of any type (assets, widgets, numbers).
class Localized<T> {
  const Localized({required this.kk, required this.ru});

  final T kk, ru;

  T resolve(AppLanguage l) => l == AppLanguage.kk ? kk : ru;
}
