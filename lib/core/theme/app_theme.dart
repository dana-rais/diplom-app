import 'package:flutter/material.dart';

import '../settings/app_settings.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// Material 3 theme for Light / High contrast built from [AppTokens].
abstract final class AppTheme {
  static ThemeData of(AppThemeMode mode) => build(
    mode == AppThemeMode.highContrast
        ? AppTokens.highContrast
        : AppTokens.light,
  );

  static ThemeData build(AppTokens t) {
    final scheme = ColorScheme(
      brightness: t.brightness,
      primary: t.primary,
      onPrimary: t.onPrimary,
      primaryContainer: t.primaryContainer,
      onPrimaryContainer: t.onPrimaryContainer,
      secondary: t.primary,
      onSecondary: t.onPrimary,
      secondaryContainer: t.primaryContainer,
      onSecondaryContainer: t.onPrimaryContainer,
      tertiary: t.success,
      onTertiary: t.successContainer,
      // Errors are never shown as red crosses; keep the neutral feedback tone.
      error: t.neutralBorder,
      onError: t.neutralFeedback,
      surface: t.surface,
      onSurface: t.onSurface,
      onSurfaceVariant: t.onSurface2,
      surfaceContainerHighest: t.card,
      outline: t.cardBorder,
      outlineVariant: t.cardBorder,
      surfaceTint: Colors.transparent,
    );
    final textTheme = AppTypography.textTheme(t.onSurface);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
    );
    WidgetStateProperty<Color?> bg(Color base, Color pressed) =>
        WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.disabled)
              ? t.disabledBg
              : s.contains(WidgetState.pressed)
              ? pressed
              : base,
        );
    final fg = WidgetStateProperty.resolveWith(
      (s) => s.contains(WidgetState.disabled) ? t.disabledFg : t.onPrimary,
    );
    final focusSide = WidgetStateProperty.resolveWith<BorderSide?>(
      (s) => s.contains(WidgetState.focused)
          ? BorderSide(color: t.focusRing, width: 3)
          : null,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      colorScheme: scheme,
      fontFamily: kFontFamily,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: t.surface,
      canvasColor: t.surface,
      focusColor: t.focusRing.withValues(alpha: 0.3),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      splashFactory: InkRipple.splashFactory,
      iconTheme: IconThemeData(color: t.onSurface, size: AppSizes.icon),
      extensions: [t],
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.tapPrimary, AppSizes.tapPrimary),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStatePropertyAll(shape),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          iconSize: const WidgetStatePropertyAll(AppSizes.iconInButton),
          backgroundColor: bg(t.primary, t.primaryPressed),
          foregroundColor: fg,
          side: focusSide,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.tapMain, AppSizes.tapMain),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: WidgetStatePropertyAll(shape),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          iconSize: const WidgetStatePropertyAll(AppSizes.iconInButton),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.disabled) ? t.disabledFg : t.primary,
          ),
          side: WidgetStateProperty.resolveWith(
            (s) => BorderSide(
              color: s.contains(WidgetState.disabled)
                  ? t.disabledFg
                  : s.contains(WidgetState.focused)
                  ? t.focusRing
                  : t.primary,
              width: s.contains(WidgetState.focused) ? 3 : AppSizes.outline,
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.tapMain, AppSizes.tapMain),
          ),
          shape: WidgetStatePropertyAll(shape),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: WidgetStatePropertyAll(t.primary),
        ),
      ),
      cardTheme: CardThemeData(
        color: t.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          side: BorderSide(color: t.cardBorder, width: AppSizes.outline),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          side: BorderSide(color: t.cardBorder, width: AppSizes.outline),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      dividerTheme: DividerThemeData(color: t.cardBorder, thickness: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.onPrimary : t.onSurface2,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? t.primary : t.card,
        ),
        trackOutlineColor: WidgetStatePropertyAll(t.onSurface2),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(t.onSurface2),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(3),
      ),
    );
  }
}
