import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kadam/core/app/lesson_launcher.dart';
import 'package:kadam/core/audio/audio_backend.dart';
import 'package:kadam/core/content/actions.dart';
import 'package:kadam/core/content/catalog.dart';
import 'package:kadam/core/content/lesson.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/content/module.dart';
import 'package:kadam/core/sim_api/scene_context.dart';
import 'package:kadam/core/sim_api/scene_spec.dart';
import 'package:kadam/core/sim_api/sim_target.dart';
import 'package:kadam/core/sim_api/target_registry.dart';

export 'package:kadam/core/storage/key_value_store.dart' show InMemoryStore;

/// Records playback; never completes by itself (call [complete]).
class FakeAudioBackend implements AudioBackend {
  final List<({String path, double rate})> played = [];
  int stopCount = 0;
  bool disposed = false;

  /// Paths whose [play] throws.
  final Set<String> failPaths = {};

  /// Paths whose [play] waits for the completer (may complete with an error).
  final Map<String, Completer<void>> gates = {};
  final StreamController<void> _complete = StreamController<void>.broadcast(
    sync: true,
  );

  String? get lastPath => played.isEmpty ? null : played.last.path;

  /// Simulates the current clip finishing.
  void complete() => _complete.add(null);

  @override
  Future<void> play(String assetPath, {double rate = 1.0}) async {
    await gates[assetPath]?.future;
    if (failPaths.contains(assetPath)) throw StateError('cannot play');
    played.add((path: assetPath, rate: rate));
  }

  @override
  Future<void> stop() async => stopCount++;

  @override
  Stream<void> get onComplete => _complete.stream;

  @override
  Future<void> dispose() async => disposed = true;
}

/// Records `openLesson` calls without navigating.
class FakeLessonLauncher implements LessonLauncher {
  final List<({String lessonId, bool resume})> opened = [];

  @override
  Future<void> openLesson(
    BuildContext context,
    String lessonId, {
    bool resume = true,
  }) async => opened.add((lessonId: lessonId, resume: resume));
}

/// Scene context that records everything a scene does.
class FakeSceneContext extends SceneContext {
  FakeSceneContext({
    required this.lesson,
    required this.step,
    this.language = AppLanguage.ru,
    this.helpLevel = 1,
    Map<String, String>? data,
  }) : dataMap = {...?data};

  @override
  final Lesson lesson;
  @override
  final LessonStep step;
  @override
  final AppLanguage language;
  @override
  int helpLevel;

  final List<UserAction> actions = [];
  final Map<String, String> dataMap;
  final List<String> voicePlayed = [];
  int struggleCount = 0;

  /// Set by `pumpScene`: the registry the scene's `SimTarget`s register in.
  late TargetRegistry registry;

  UserAction? get lastAction => actions.isEmpty ? null : actions.last;
  bool get struggled => struggleCount > 0;

  @override
  void report(UserAction a) => actions.add(a);

  @override
  String? data(String k) => dataMap[k];

  @override
  void setData(String k, String v) => dataMap[k] = v;

  @override
  void markStruggle() => struggleCount++;

  @override
  void playVoice(String key) => voicePlayed.add(key);
}

/// One button; reports `UserAction(targetId, tap)` on tap.
class TapScene extends SceneSpec {
  const TapScene({this.targetId = 'btn'});

  final String targetId;

  @override
  Widget build(BuildContext context, SceneContext ctx) => Center(
    child: SimTarget(
      id: targetId,
      child: FilledButton(
        onPressed: () => ctx.report(UserAction(targetId, GestureKind.tap)),
        child: const Text('Tap'),
      ),
    ),
  );
}

/// A scene with an inner vertical `ListView` (SimTarget `list`). Scrolling
/// reports `progress`; tapping item N reports `tap` on `item_N`.
class ListScene extends SceneSpec {
  const ListScene();

  @override
  Widget build(BuildContext context, SceneContext ctx) =>
      NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollUpdateNotification) {
            ctx.report(const UserAction('list', GestureKind.progress));
          }
          return false;
        },
        child: SimTarget(
          id: 'list',
          child: ListView.builder(
            itemCount: 30,
            itemExtent: 56,
            itemBuilder: (_, i) => InkWell(
              onTap: () => ctx.report(UserAction('item_$i', GestureKind.tap)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Item $i'),
              ),
            ),
          ),
        ),
      );
}

LessonStep stubStep(
  SceneSpec scene, {
  String id = 's1',
  ExpectedAction expected = const ExpectedAction('btn', GestureKind.tap),
}) => LessonStep(
  id: id,
  scene: scene,
  expected: expected,
  instruction: const LocalizedText(kk: 'Басыңыз', ru: 'Нажмите'),
  hint: const LocalizedText(kk: 'Тағы көріңіз', ru: 'Попробуйте ещё'),
  outcomeLabel: const LocalizedText(kk: 'Басу', ru: 'Нажать'),
);

Lesson stubLesson(LessonStep step, {String id = 'test.stub'}) => Lesson(
  id: id,
  title: const LocalizedText(kk: 'Сынақ', ru: 'Проба'),
  intro: const LocalizedText(kk: 'Кіріспе', ru: 'Вступление'),
  summary: const LocalizedText(kk: 'Қорытынды', ru: 'Итог'),
  steps: [step],
);

Lesson _lesson(String id, SceneSpec scene, ExpectedAction expected) => Lesson(
  id: id,
  title: LocalizedText(kk: 'Сабақ $id', ru: 'Урок $id'),
  intro: const LocalizedText(kk: 'Кіріспе', ru: 'Вступление'),
  summary: const LocalizedText(kk: 'Қорытынды', ru: 'Итог'),
  steps: [
    for (final n in const ['s1', 's2', 's3'])
      stubStep(scene, id: n, expected: expected),
  ],
);

/// Two fake modules: `test_a` (lessons `test_a.one`, `test_a.two` with tap
/// scenes, `test_a.scroll` with the inner-ListView scene) and `test_b`
/// (`test_b.one`). Every lesson has steps s1..s3 expecting `btn`/tap
/// (`list`/scroll for `test_a.scroll`).
ModuleCatalog testCatalog() {
  const tap = ExpectedAction('btn', GestureKind.tap);
  return ModuleCatalog([
    LearningModule(
      id: 'test_a',
      title: const LocalizedText(kk: 'Сынақ А', ru: 'Проба А'),
      shortTitle: const LocalizedText(kk: 'А', ru: 'А'),
      description: const LocalizedText(kk: 'Сипаттама', ru: 'Описание'),
      icon: Icons.circle,
      lessons: [
        _lesson('test_a.one', const TapScene(), tap),
        _lesson('test_a.two', const TapScene(), tap),
        _lesson(
          'test_a.scroll',
          const ListScene(),
          const ExpectedAction('list', GestureKind.scroll),
        ),
      ],
    ),
    LearningModule(
      id: 'test_b',
      title: const LocalizedText(kk: 'Сынақ Б', ru: 'Проба Б'),
      shortTitle: const LocalizedText(kk: 'Б', ru: 'Б'),
      description: const LocalizedText(kk: 'Сипаттама', ru: 'Описание'),
      icon: Icons.square,
      lessons: [_lesson('test_b.one', const TapScene(), tap)],
    ),
  ]);
}
