import '../content/localized_text.dart';

enum TextScaleStep {
  s100(1.0),
  s125(1.25),
  s150(1.5),
  s200(2.0);

  const TextScaleStep(this.factor);

  final double factor;
}

enum AppThemeMode { light, highContrast }

/// `slow` plays at rate 0.85.
enum VoiceSpeed {
  slow(0.85),
  normal(1.0);

  const VoiceSpeed(this.rate);

  final double rate;
}

T _enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

class AppSettings {
  const AppSettings({
    this.language,
    this.textScale = TextScaleStep.s100,
    this.theme = AppThemeMode.light,
    this.voiceAutoPlay = false,
    this.voiceSpeed = VoiceSpeed.normal,
    this.soundAndHaptics = true,
    this.onboardingCompleted = false,
  });

  static const defaults = AppSettings();

  /// Null until the user picks a language in onboarding.
  final AppLanguage? language;
  final TextScaleStep textScale;
  final AppThemeMode theme;
  final bool voiceAutoPlay;
  final VoiceSpeed voiceSpeed;
  final bool soundAndHaptics;
  final bool onboardingCompleted;

  AppSettings copyWith({
    AppLanguage? language,
    bool clearLanguage = false,
    TextScaleStep? textScale,
    AppThemeMode? theme,
    bool? voiceAutoPlay,
    VoiceSpeed? voiceSpeed,
    bool? soundAndHaptics,
    bool? onboardingCompleted,
  }) => AppSettings(
    language: clearLanguage ? null : (language ?? this.language),
    textScale: textScale ?? this.textScale,
    theme: theme ?? this.theme,
    voiceAutoPlay: voiceAutoPlay ?? this.voiceAutoPlay,
    voiceSpeed: voiceSpeed ?? this.voiceSpeed,
    soundAndHaptics: soundAndHaptics ?? this.soundAndHaptics,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );

  Map<String, Object?> toJson() => {
    'v': 1,
    'language': language?.name,
    'textScale': textScale.name,
    'theme': theme.name,
    'voiceAutoPlay': voiceAutoPlay,
    'voiceSpeed': voiceSpeed.name,
    'soundAndHaptics': soundAndHaptics,
    'onboardingCompleted': onboardingCompleted,
  };

  /// Tolerant: unknown/missing fields fall back to defaults.
  factory AppSettings.fromJson(Map<String, Object?> j) {
    bool b(String k, bool d) => j[k] is bool ? j[k]! as bool : d;
    final lang = j['language'];
    return AppSettings(
      language: AppLanguage.values.where((e) => e.name == lang).firstOrNull,
      textScale: _enumByName(
        TextScaleStep.values,
        j['textScale'],
        defaults.textScale,
      ),
      theme: _enumByName(AppThemeMode.values, j['theme'], defaults.theme),
      voiceAutoPlay: b('voiceAutoPlay', defaults.voiceAutoPlay),
      voiceSpeed: _enumByName(
        VoiceSpeed.values,
        j['voiceSpeed'],
        defaults.voiceSpeed,
      ),
      soundAndHaptics: b('soundAndHaptics', defaults.soundAndHaptics),
      onboardingCompleted: b(
        'onboardingCompleted',
        defaults.onboardingCompleted,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.textScale == textScale &&
      other.theme == theme &&
      other.voiceAutoPlay == voiceAutoPlay &&
      other.voiceSpeed == voiceSpeed &&
      other.soundAndHaptics == soundAndHaptics &&
      other.onboardingCompleted == onboardingCompleted;

  @override
  int get hashCode => Object.hash(
    language,
    textScale,
    theme,
    voiceAutoPlay,
    voiceSpeed,
    soundAndHaptics,
    onboardingCompleted,
  );
}
