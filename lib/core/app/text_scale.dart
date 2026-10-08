import 'package:flutter/widgets.dart';

import '../settings/app_settings.dart';

const double kMinTextScale = 1.0;
const double kMaxTextScale = 2.0;

/// Scale at which text is considered «large» (compact lesson layout etc.).
const double kLargeTextScale = 1.5;

/// effective = clamp(system x app factor, 1.0, 2.0)
double effectiveTextScale(double systemLinear, TextScaleStep step) =>
    (systemLinear * step.factor).clamp(kMinTextScale, kMaxTextScale).toDouble();

/// The linear factor of the ambient text scaler.
double linearTextScaleOf(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(20) / 20;

/// True when the (already effective) text scale is >= 1.5.
bool isLargeText(BuildContext context) =>
    linearTextScaleOf(context) >= kLargeTextScale - 0.0001;

/// Applies [effectiveTextScale] to [child]; used in `MaterialApp.builder`.
class AppTextScale extends StatelessWidget {
  const AppTextScale({super.key, required this.step, required this.child});

  final TextScaleStep step;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scale = effectiveTextScale(linearTextScaleOf(context), step);
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(scale)),
      child: child,
    );
  }
}

/// Clamps text to 1.5 for chrome (top bar, help bar, bottom nav, scenes).
class ChromeScale extends StatelessWidget {
  const ChromeScale({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    maxScaleFactor: kLargeTextScale,
    child: child,
  );
}
