import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/settings/app_settings.dart';
import 'package:kadam/core/theme/app_theme.dart';
import 'package:kadam/core/theme/app_tokens.dart';
import 'package:kadam/core/theme/app_typography.dart';
import 'package:kadam/core/theme/contrast.dart';

void main() {
  final themes = {
    'light': AppTokens.light,
    'highContrast': AppTokens.highContrast,
  };

  for (final e in themes.entries) {
    final t = e.value;
    group('contrast ${e.key}', () {
      test('body text pairs are >= 7:1', () {
        final pairs = <String, (Color, Color)>{
          'onSurface/surface': (t.onSurface, t.surface),
          'onSurface/card': (t.onSurface, t.card),
          'onSurface2/surface': (t.onSurface2, t.surface),
          'onSurface2/card': (t.onSurface2, t.card),
          'onPrimary/primary': (t.onPrimary, t.primary),
          'onPrimary/primaryPressed': (t.onPrimary, t.primaryPressed),
          'onPrimaryContainer/primaryContainer': (
            t.onPrimaryContainer,
            t.primaryContainer,
          ),
          'success/successContainer': (t.success, t.successContainer),
          'onSurface/neutralFeedback': (t.onSurface, t.neutralFeedback),
          'onBadge/badgeBg': (t.onBadge, t.badgeBg),
          'disabledFg/disabledBg': (t.disabledFg, t.disabledBg),
          'primary(text)/surface': (
            t.isHighContrast ? t.primary : t.primary,
            t.surface,
          ),
        };
        for (final p in pairs.entries) {
          expect(
            contrastRatio(p.value.$1, p.value.$2),
            greaterThanOrEqualTo(7.0),
            reason: p.key,
          );
        }
      });

      test('large text and UI pairs are >= 4.5:1', () {
        final pairs = <String, (Color, Color)>{
          'neutralBorder/neutralFeedback': (t.neutralBorder, t.neutralFeedback),
          'neutralIcon/neutralFeedback': (t.neutralIcon, t.neutralFeedback),
          'success/card': (t.success, t.card),
          'onSurface2/primaryContainer': (t.onSurface2, t.primaryContainer),
          'primary/card': (t.primary, t.card),
        };
        for (final p in pairs.entries) {
          expect(
            contrastRatio(p.value.$1, p.value.$2),
            greaterThanOrEqualTo(4.5),
            reason: p.key,
          );
        }
      });

      test('simulator frame vs surface >= 3:1', () {
        expect(
          contrastRatio(t.simulatorFrame, t.surface),
          greaterThanOrEqualTo(3.0),
        );
      });

      test('highlight ring is visible on the dimmed scene (>= 3:1)', () {
        final dimmed = overOpaque(t.overlayDim, t.surface);
        expect(contrastRatio(t.highlight, dimmed), greaterThanOrEqualTo(3.0));
      });
    });
  }

  test('documented ratios from the mockups', () {
    expect(
      contrastRatio(AppTokens.light.onPrimary, AppTokens.light.primary),
      closeTo(9.7, 0.2),
    );
    expect(
      contrastRatio(
        AppTokens.highContrast.onPrimary,
        AppTokens.highContrast.primary,
      ),
      closeTo(15, 0.5),
    );
  });

  group('theme', () {
    for (final mode in AppThemeMode.values) {
      test('builds for ${mode.name}', () {
        final theme = AppTheme.of(mode);
        expect(theme.useMaterial3, isTrue);
        expect(theme.textTheme.bodyMedium?.fontFamily, kFontFamily);
        expect(theme.extension<AppTokens>(), isNotNull);
        expect(theme.textTheme.bodyMedium?.fontSize, 20);
        expect(theme.textTheme.titleLarge?.fontSize, 26);
        expect(theme.textTheme.bodySmall?.fontSize, 18);
        // 18 is the minimum anywhere.
        for (final s in [
          theme.textTheme.displayLarge,
          theme.textTheme.titleSmall,
          theme.textTheme.labelSmall,
          theme.textTheme.labelMedium,
        ]) {
          expect(s!.fontSize, greaterThanOrEqualTo(18));
        }
      });
    }

    test('button sizes: filled >= 64, outlined >= 56', () {
      final theme = AppTheme.of(AppThemeMode.light);
      expect(
        theme.filledButtonTheme.style!.minimumSize!.resolve({})!.height,
        64,
      );
      expect(
        theme.outlinedButtonTheme.style!.minimumSize!.resolve({})!.height,
        56,
      );
    });

    test('high contrast tokens are the discrete second theme', () {
      expect(AppTokens.highContrast.isHighContrast, isTrue);
      expect(AppTokens.light.isHighContrast, isFalse);
      expect(
        AppTheme.of(AppThemeMode.highContrast).brightness,
        Brightness.dark,
      );
    });
  });
}
