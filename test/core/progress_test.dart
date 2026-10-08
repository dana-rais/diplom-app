import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/progress/lesson_progress.dart';
import 'package:kadam/core/progress/progress_controller.dart';
import 'package:kadam/core/progress/progress_repository.dart';

import '../support/support.dart';

void main() {
  final catalog = testCatalog();
  late InMemoryStore store;
  late ProgressController c;
  var tick = 0;
  ProgressController make() => ProgressController(
    ProgressRepository(store),
    now: () => DateTime.utc(2026, 1, 1).add(Duration(minutes: tick++)),
  );

  setUp(() {
    tick = 0;
    store = InMemoryStore();
    c = make();
  });

  group('StepRecord', () {
    test('difficult rules', () {
      expect(const StepRecord().difficult, isFalse);
      expect(const StepRecord(misses: 1).difficult, isFalse);
      expect(const StepRecord(misses: 2).difficult, isTrue);
      expect(const StepRecord(maxHelpLevel: 2).difficult, isFalse);
      expect(const StepRecord(maxHelpLevel: 3).difficult, isTrue);
      expect(const StepRecord(struggled: true).difficult, isTrue);
    });
    test('json round trip', () {
      const r = StepRecord(misses: 3, maxHelpLevel: 2, struggled: true);
      final b = StepRecord.fromJson(r.toJson());
      expect((b.misses, b.maxHelpLevel, b.struggled), (3, 2, true));
    });
  });

  test('saveStep stores resume point, data and records', () async {
    await c.saveStep(
      'test_a.one',
      1,
      's2',
      {'k': 'v'},
      {'s1': const StepRecord(misses: 1)},
    );
    final p = c.of('test_a.one')!;
    expect(p.completed, isFalse);
    expect(p.resumeStep, 1);
    expect(p.resumeStepId, 's2');
    expect(p.data, {'k': 'v'});
    expect(p.steps['s1']!.misses, 1);
    expect(c.lastLessonId, 'test_a.one');
    expect(c.of('nope'), isNull);
  });

  test('persists and reloads', () async {
    await c.saveStep(
      'test_a.one',
      2,
      's3',
      {'a': 'b'},
      {'s1': const StepRecord(misses: 2)},
    );
    await c.completeLesson('test_b.one', {'s1': const StepRecord()});
    final again = make();
    expect(again.of('test_a.one')!.resumeStepId, 's3');
    expect(again.of('test_a.one')!.data, {'a': 'b'});
    expect(again.of('test_a.one')!.steps['s1']!.misses, 2);
    expect(again.of('test_b.one')!.completed, isTrue);
    expect(again.lastLessonId, 'test_b.one');
    expect(store.values.keys, ['progress.v1']);
  });

  test('completeLesson clears resume point and data', () async {
    await c.saveStep('test_a.one', 1, 's2', {'k': 'v'}, {});
    await c.completeLesson('test_a.one', {'s1': const StepRecord(misses: 2)});
    final p = c.of('test_a.one')!;
    expect(p.completed, isTrue);
    expect(p.resumeStep, isNull);
    expect(p.resumeStepId, isNull);
    expect(p.data, isEmpty);
    expect(p.difficult, isTrue);
  });

  test(
    'clearRun keeps completion, drops resume; removes empty records',
    () async {
      await c.completeLesson('test_a.one', {});
      await c.saveStep('test_a.one', 1, 's2', {'k': 'v'}, {});
      await c.clearRun('test_a.one');
      final p = c.of('test_a.one')!;
      expect(p.completed, isTrue);
      expect(p.resumeStep, isNull);
      expect(p.data, isEmpty);

      await c.saveStep('test_b.one', 0, 's1', {}, {});
      await c.clearRun('test_b.one');
      expect(c.of('test_b.one'), isNull);
      await c.clearRun('missing'); // no throw
    },
  );

  test('completedCount counts per module', () async {
    final a = catalog.modules[0];
    expect(c.completedCount(a), 0);
    await c.completeLesson('test_a.one', {});
    await c.completeLesson('test_a.two', {});
    await c.saveStep('test_a.scroll', 0, 's1', {}, {});
    expect(c.completedCount(a), 2);
    expect(c.completedCount(catalog.modules[1]), 0);
  });

  test('difficultLessonIds: completed lessons with a difficult step, catalog order', () async {
    await c.completeLesson('test_b.one', {'s1': const StepRecord(misses: 2)});
    await c.completeLesson('test_a.two', {
      's1': const StepRecord(maxHelpLevel: 3),
    });
    await c.completeLesson('test_a.one', {'s1': const StepRecord(misses: 1)});
    await c.saveStep('test_a.scroll', 0, 's1', {}, {
      's1': const StepRecord(struggled: true),
    });
    expect(c.difficultLessonIds(catalog), ['test_a.two', 'test_b.one']);
  });

  group('continueTarget', () {
    test('null without a run in progress', () async {
      expect(c.continueTarget(catalog), isNull);
      await c.completeLesson('test_a.one', {});
      expect(c.continueTarget(catalog), isNull);
    });
    test('most recently touched lesson with a resume point', () async {
      await c.saveStep('test_a.one', 1, 's2', {}, {});
      await c.saveStep('test_b.one', 2, 's3', {}, {});
      expect(c.continueTarget(catalog), (lessonId: 'test_b.one', step: 2));
      await c.completeLesson('test_b.one', {});
      expect(c.continueTarget(catalog), (lessonId: 'test_a.one', step: 1));
    });
    test('prefers resumeStepId and clamps the index', () async {
      await c.saveStep('test_a.one', 0, 's3', {}, {});
      expect(c.continueTarget(catalog)!.step, 2);
      await c.saveStep('test_a.one', 99, 'gone', {}, {});
      expect(c.continueTarget(catalog)!.step, 2);
    });
    test('ignores lessons that are not in the catalog', () async {
      await c.saveStep('removed.lesson', 1, 's2', {}, {});
      expect(c.continueTarget(catalog), isNull);
    });
  });

  test('resetAll clears memory and storage and notifies', () async {
    await c.completeLesson('test_a.one', {});
    var n = 0;
    c.addListener(() => n++);
    await c.resetAll();
    expect(n, 1);
    expect(c.of('test_a.one'), isNull);
    expect(c.lastLessonId, isNull);
    expect(store.values, isEmpty);
    expect(make().of('test_a.one'), isNull);
  });

  group('corrupt data', () {
    for (final bad in [
      'garbage',
      '[]',
      '{"v":9,"lessons":{}}',
      '{"v":1,"lessons":5}',
    ]) {
      test('"$bad" gives an empty controller', () {
        store = InMemoryStore({'progress.v1': bad});
        final p = make();
        expect(p.lastLessonId, isNull);
        expect(p.of('test_a.one'), isNull);
      });
    }
    test('a single broken lesson entry is skipped', () {
      store = InMemoryStore({
        'progress.v1': '{"v":1,"last":"test_a.one","lessons":{"test_a.one":{"completed":true},"test_b.one":"oops"}}',
      });
      final p = make();
      expect(p.of('test_a.one')!.completed, isTrue);
      expect(p.of('test_b.one'), isNull);
      expect(p.lastLessonId, 'test_a.one');
    });
  });
}
