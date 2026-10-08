import 'package:flutter/material.dart';

/// Fixed sizes and spacing (dp).
abstract final class AppSizes {
  static const double tapMin = 48;
  static const double tapMain = 56;
  static const double tapPrimary = 64;
  static const double pinKey = 72;
  static const double gap = 12;
  static const double s4 = 4, s8 = 8, s12 = 12, s16 = 16, s24 = 24, s32 = 32;
  static const double buttonRadius = 16;
  static const double cardRadius = 20;
  static const double frameRadius = 20;
  static const double outline = 2;
  static const double icon = 32;
  static const double iconInButton = 28;
  static const Duration motion = Duration(milliseconds: 250);
  static const Curve motionCurve = Curves.easeOutCubic;
  static const Duration pulse = Duration(milliseconds: 1200);
}

/// Design tokens from the mockups (pages 1-2), Light and High contrast.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryPressed,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.primaryContainerBorder,
    required this.surface,
    required this.card,
    required this.cardBorder,
    required this.onSurface,
    required this.onSurface2,
    required this.success,
    required this.successContainer,
    required this.neutralFeedback,
    required this.neutralBorder,
    required this.neutralIcon,
    required this.simulatorFrame,
    required this.badgeBg,
    required this.onBadge,
    required this.overlayDim,
    required this.highlight,
    required this.focusRing,
    required this.disabledBg,
    required this.disabledFg,
  });

  final Brightness brightness;
  final Color primary, onPrimary, primaryPressed;
  final Color primaryContainer, onPrimaryContainer, primaryContainerBorder;
  final Color surface, card, cardBorder;
  final Color onSurface, onSurface2;
  final Color success, successContainer;
  final Color neutralFeedback, neutralBorder, neutralIcon;
  final Color simulatorFrame, badgeBg, onBadge;
  final Color overlayDim, highlight, focusRing;
  final Color disabledBg, disabledFg;

  bool get isHighContrast => this == highContrast;

  static const light = AppTokens(
    brightness: Brightness.light,
    primary: Color(0xFF17418C),
    onPrimary: Color(0xFFFFFFFF),
    primaryPressed: Color(0xFF0F2E66),
    primaryContainer: Color(0xFFE6ECF7),
    onPrimaryContainer: Color(0xFF17418C),
    primaryContainerBorder: Color(0xFFE6ECF7),
    surface: Color(0xFFFAF7F2),
    card: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFDDD6CA),
    onSurface: Color(0xFF1B1A17),
    onSurface2: Color(0xFF4A463F),
    success: Color(0xFF145A2E),
    successContainer: Color(0xFFE6F2E8),
    neutralFeedback: Color(0xFFFFF1CC),
    neutralBorder: Color(0xFF8A5A00),
    neutralIcon: Color(0xFF8A5A00),
    simulatorFrame: Color(0xFFC2560F),
    badgeBg: Color(0xFFFFE2C7),
    onBadge: Color(0xFF6B2E00),
    overlayDim: Color(0xB811100E),
    highlight: Color(0xFFFFC21A),
    focusRing: Color(0xFFFFC21A),
    disabledBg: Color(0xFFECE8E1),
    disabledFg: Color(0xFF4A463F),
  );

  static const highContrast = AppTokens(
    brightness: Brightness.dark,
    primary: Color(0xFFFFD60A),
    onPrimary: Color(0xFF000000),
    primaryPressed: Color(0xFFE6C000),
    primaryContainer: Color(0xFF000000),
    onPrimaryContainer: Color(0xFFFFD60A),
    primaryContainerBorder: Color(0xFFFFD60A),
    surface: Color(0xFF000000),
    card: Color(0xFF000000),
    cardBorder: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onSurface2: Color(0xFFE0E0E0),
    success: Color(0xFF5BE38A),
    successContainer: Color(0xFF000000),
    neutralFeedback: Color(0xFF000000),
    neutralBorder: Color(0xFFFFD60A),
    neutralIcon: Color(0xFFFFD60A),
    simulatorFrame: Color(0xFFFF9F43),
    badgeBg: Color(0xFFFF9F43),
    onBadge: Color(0xFF000000),
    overlayDim: Color(0xCC000000),
    highlight: Color(0xFFFFD60A),
    focusRing: Color(0xFFFFFFFF),
    disabledBg: Color(0xFF000000),
    disabledFg: Color(0xFFBDBDBD),
  );

  static AppTokens forMode(Brightness b, {required bool highContrast}) =>
      highContrast ? AppTokens.highContrast : AppTokens.light;

  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>() ?? AppTokens.light;

  @override
  AppTokens copyWith({
    Color? primary,
    Color? onPrimary,
    Color? surface,
    Color? onSurface,
  }) => AppTokens(
    brightness: brightness,
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    primaryPressed: primaryPressed,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    primaryContainerBorder: primaryContainerBorder,
    surface: surface ?? this.surface,
    card: card,
    cardBorder: cardBorder,
    onSurface: onSurface ?? this.onSurface,
    onSurface2: onSurface2,
    success: success,
    successContainer: successContainer,
    neutralFeedback: neutralFeedback,
    neutralBorder: neutralBorder,
    neutralIcon: neutralIcon,
    simulatorFrame: simulatorFrame,
    badgeBg: badgeBg,
    onBadge: onBadge,
    overlayDim: overlayDim,
    highlight: highlight,
    focusRing: focusRing,
    disabledBg: disabledBg,
    disabledFg: disabledFg,
  );

  /// Themes are discrete (Light / High contrast): no interpolation.
  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) =>
      (other is AppTokens && t >= 0.5) ? other : this;
}

extension AppTokensContext on BuildContext {
  AppTokens get tokens => AppTokens.of(this);
}
