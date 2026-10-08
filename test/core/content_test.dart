import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/content/actions.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/content/voice_keys.dart';

import '../support/support.dart';

void main() {
  test('LocalizedText and Localized resolve by language', () {
    const t = LocalizedText(kk: 'қ', ru: 'р');
    expect(t.resolve(AppLanguage.kk), 'қ');
    expect(t.resolve(AppLanguage.ru), 'р');
    const l = Localized<int>(kk: 1, ru: 2);
    expect(l.resolve(AppLanguage.kk), 1);
    expect(l.resolve(AppLanguage.ru), 2);
  });

  group('ExpectedAction.matches', () {
    const e = ExpectedAction('a', GestureKind.tap);
    test('kind and target must match', () {
      expect(e.matches(const UserAction('a', GestureKind.tap)), isTrue);
      expect(e.matches(const UserAction('b', GestureKind.tap)), isFalse);
      expect(e.matches(const UserAction('a', GestureKind.longPress)), isFalse);
      expect(e.matches(const UserAction('a', GestureKind.progress)), isFalse);
    });
    test('value: null accepts any, set requires equality', () {
      expect(
        e.matches(const UserAction('a', GestureKind.tap, value: 'x')),
        isTrue,
      );
      const v = ExpectedAction('a', GestureKind.enterText, value: '1234');
      expect(
        v.matches(const UserAction('a', GestureKind.enterText, value: '1234')),
        isTrue,
      );
      expect(
        v.matches(const UserAction('a', GestureKind.enterText, value: '1')),
        isFalse,
      );
      expect(v.matches(const UserAction('a', GestureKind.enterText)), isFalse);
    });
    test('alsoAccept is checked recursively', () {
      const x = ExpectedAction(
        kPanelActionTarget,
        GestureKind.tap,
        alsoAccept: [
          ExpectedAction(
            'hang_up',
            GestureKind.tap,
            alsoAccept: [ExpectedAction('deep', GestureKind.swipeUp)],
          ),
        ],
      );
      expect(
        x.matches(const UserAction(kPanelActionTarget, GestureKind.tap)),
        isTrue,
      );
      expect(x.matches(const UserAction('hang_up', GestureKind.tap)), isTrue);
      expect(x.matches(const UserAction('deep', GestureKind.swipeUp)), isTrue);
      expect(x.matches(const UserAction('deep', GestureKind.tap)), isFalse);
    });
  });

  test('voice keys', () {
    final lesson = testCatalog().lessonById('test_a.one')!;
    final step = lesson.steps.first;
    expect(introKey(lesson), 'test_a.one.intro');
    expect(stepKey(lesson, step), 'test_a.one.s1');
    expect(hintKey(lesson, step), 'test_a.one.s1.hint');
    expect(summaryKey(lesson), 'test_a.one.summary');
    for (final k in [
      introKey(lesson),
      stepKey(lesson, step),
      hintKey(lesson, step),
      summaryKey(lesson),
    ]) {
      expect(kVoiceKeyPattern.hasMatch(k), isTrue, reason: k);
    }
    expect(kVoiceKeyPattern.hasMatch('Bad.Key'), isFalse);
    expect(kVoiceKeyPattern.hasMatch('a..b'), isFalse);
    expect(kVoiceKeyPattern.hasMatch('a.b-c'), isFalse);
  });

  group('ModuleCatalog', () {
    final c = testCatalog();
    test('lookups', () {
      expect(c.modules.map((m) => m.id), ['test_a', 'test_b']);
      expect(c.allLessons.map((l) => l.id), [
        'test_a.one',
        'test_a.two',
        'test_a.scroll',
        'test_b.one',
      ]);
      expect(c.lessonById('test_b.one')?.id, 'test_b.one');
      expect(c.lessonById('nope'), isNull);
      expect(c.moduleOfLesson('test_a.two')?.id, 'test_a');
      expect(c.moduleOfLesson('nope'), isNull);
    });
    test('nextLessonAfter stays inside the module', () {
      expect(c.nextLessonAfter('test_a.one'), 'test_a.two');
      expect(c.nextLessonAfter('test_a.scroll'), isNull);
      expect(c.nextLessonAfter('test_b.one'), isNull);
      expect(c.nextLessonAfter('nope'), isNull);
    });
    test('lessonIndexInModule', () {
      expect(c.lessonIndexInModule('test_a.two'), 1);
      expect(c.lessonIndexInModule('test_b.one'), 0);
      expect(c.lessonIndexInModule('nope'), -1);
    });
  });
}
