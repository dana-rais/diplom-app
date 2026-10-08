import 'package:flutter/material.dart';

const kFontFamily = 'NotoSans';

/// Type scale from the mockups. 18 is the minimum size anywhere.
abstract final class AppTypography {
  static const display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  static const title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static const bodyL = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  static const body = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );
  static const label = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  static const small = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static const badge = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);

  /// Material slots: display -> headlineMedium, title -> titleLarge,
  /// bodyL -> bodyLarge, body -> bodyMedium, label -> labelLarge,
  /// small -> bodySmall, badge -> labelMedium. Unused slots map to the
  /// closest style so nothing falls below 18.
  static TextTheme textTheme(Color color) {
    TextStyle c(TextStyle s) =>
        s.copyWith(color: color, fontFamily: kFontFamily);
    return TextTheme(
      displayLarge: c(display),
      displayMedium: c(display),
      displaySmall: c(display),
      headlineLarge: c(display),
      headlineMedium: c(display),
      headlineSmall: c(title),
      titleLarge: c(title),
      titleMedium: c(bodyL),
      titleSmall: c(body),
      bodyLarge: c(bodyL),
      bodyMedium: c(body),
      bodySmall: c(small),
      labelLarge: c(label),
      labelMedium: c(badge),
      labelSmall: c(badge),
    );
  }
}
