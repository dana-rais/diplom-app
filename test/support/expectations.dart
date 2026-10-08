import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/sim_api/target_registry.dart';

/// Minimum "main" tap target (dp).
const kMainTapTarget = 56.0;

/// No exception (overflow, build error...) was caught by the framework.
void expectNoLayoutErrors(WidgetTester tester) {
  final e = tester.takeException();
  expect(e, isNull, reason: 'Layout/build error: $e');
}

/// No paragraph was cut by `maxLines` (content text must wrap, not truncate).
void expectNoTruncatedText(WidgetTester tester) {
  for (final el in find.byType(RichText).evaluate()) {
    final ro = el.renderObject;
    if (ro is RenderParagraph) {
      expect(
        ro.didExceedMaxLines,
        isFalse,
        reason: 'Truncated text: "${ro.text.toPlainText()}"',
      );
    }
  }
}

/// Android tap-target size, labeled tap targets, text contrast.
Future<void> expectA11y(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  try {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  } finally {
    handle.dispose();
  }
}

void expectUniqueTargets(TargetRegistry registry) {
  expect(
    registry.debugDuplicateIds(),
    isEmpty,
    reason: 'Two mounted SimTargets share an id',
  );
}

/// [finder] is fully inside the view and hit-testable.
void expectInViewport(WidgetTester tester, Finder finder) {
  expect(finder, findsAtLeastNWidgets(1));
  final rect = tester.getRect(finder.first);
  final view = tester.view.physicalSize / tester.view.devicePixelRatio;
  expect(Offset.zero & view, isNotNull);
  final bounds = Offset.zero & view;
  expect(
    bounds.inflate(0.5).contains(rect.topLeft) &&
        bounds.inflate(0.5).contains(rect.bottomRight),
    isTrue,
    reason: 'Rect $rect is outside the viewport $bounds',
  );
  expect(finder.hitTestable(), findsAtLeastNWidgets(1));
}
