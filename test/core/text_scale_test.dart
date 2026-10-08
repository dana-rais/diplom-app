import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/app/text_scale.dart';
import 'package:kadam/core/settings/app_settings.dart';

void main() {
  group('effectiveTextScale', () {
    test('multiplies system and app factor', () {
      expect(effectiveTextScale(1.0, TextScaleStep.s125), 1.25);
      expect(effectiveTextScale(1.2, TextScaleStep.s125), closeTo(1.5, 1e-9));
    });
    test('clamps to [1.0, 2.0]', () {
      expect(effectiveTextScale(0.8, TextScaleStep.s100), 1.0);
      expect(effectiveTextScale(1.5, TextScaleStep.s200), 2.0);
      expect(effectiveTextScale(3.0, TextScaleStep.s100), 2.0);
    });
    test('steps are 100/125/150/200', () {
      expect(TextScaleStep.values.map((s) => s.factor), [1.0, 1.25, 1.5, 2.0]);
    });
  });

  testWidgets('isLargeText and ChromeScale', (tester) async {
    late bool large;
    late double chrome, outer;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: Builder(
          builder: (context) {
            large = isLargeText(context);
            outer = linearTextScaleOf(context);
            return ChromeScale(
              child: Builder(
                builder: (c) {
                  chrome = linearTextScaleOf(c);
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
    expect(large, isTrue);
    expect(outer, closeTo(2.0, 1e-9));
    expect(chrome, closeTo(1.5, 1e-9));
  });

  testWidgets('isLargeText is false at 1.25', (tester) async {
    late bool large;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.25)),
        child: Builder(
          builder: (context) {
            large = isLargeText(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(large, isFalse);
  });

  testWidgets('AppTextScale applies system x app clamped', (tester) async {
    late double seen;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
        child: AppTextScale(
          step: TextScaleStep.s200,
          child: Builder(
            builder: (c) {
              seen = linearTextScaleOf(c);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(seen, 2.0);
  });
}
