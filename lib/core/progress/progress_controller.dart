import 'package:flutter/foundation.dart';

import '../content/catalog.dart';
import '../content/module.dart';
import 'lesson_progress.dart';
import 'progress_repository.dart';

class ProgressController extends ChangeNotifier {
  ProgressController(this._repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now {
    final s = _repository.load();
    _lessons = {...s.lessons};
    _last = s.lastLessonId;
  }

  final ProgressRepository _repository;
  final DateTime Function() _now;
  late Map<String, LessonProgress> _lessons;
  String? _last;

  LessonProgress? of(String id) => _lessons[id];

  /// The lesson touched most recently (saved step or completed), if any.
  String? get lastLessonId => _last;

  /// Persists the current step (resume point) of a run.
  Future<void> saveStep(
    String lessonId,
    int stepIndex,
    String stepId,
    Map<String, String> data,
    Map<String, StepRecord> steps,
  ) {
    final old = _lessons[lessonId];
    _lessons[lessonId] =
        (old ?? LessonProgress(lessonId: lessonId, updatedAt: _now())).copyWith(
          resumeStep: stepIndex,
          resumeStepId: stepId,
          data: Map.unmodifiable(data),
          steps: Map.unmodifiable(steps),
          updatedAt: _now(),
        );
    _last = lessonId;
    return _commit();
  }

  /// Marks the lesson completed and drops its resume point and run data.
  Future<void> completeLesson(String lessonId, Map<String, StepRecord> steps) {
    final old = _lessons[lessonId];
    _lessons[lessonId] =
        (old ?? LessonProgress(lessonId: lessonId, updatedAt: _now())).copyWith(
          completed: true,
          clearResume: true,
          data: const {},
          steps: Map.unmodifiable(steps),
          updatedAt: _now(),
        );
    _last = lessonId;
    return _commit();
  }

  /// Drops the resume point and run data (e.g. «Пройти ещё раз»); keeps
  /// `completed` and the step records.
  Future<void> clearRun(String lessonId) {
    final old = _lessons[lessonId];
    if (old == null) return Future.value();
    if (!old.completed && old.steps.isEmpty) {
      _lessons.remove(lessonId);
      if (_last == lessonId) _last = null;
    } else {
      _lessons[lessonId] = old.copyWith(
        clearResume: true,
        data: const {},
        updatedAt: _now(),
      );
    }
    return _commit();
  }

  Future<void> resetAll() async {
    _lessons = {};
    _last = null;
    notifyListeners();
    await _repository.clear();
  }

  int completedCount(LearningModule m) =>
      m.lessons.where((l) => _lessons[l.id]?.completed ?? false).length;

  /// Completed lessons with at least one difficult step, in catalog order.
  List<String> difficultLessonIds(ModuleCatalog c) => [
    for (final l in c.allLessons)
      if (_lessons[l.id] case final p? when p.completed && p.difficult) l.id,
  ];

  /// Where «Продолжить урок» should go: the most recently touched lesson that
  /// still has a resume point and exists in the catalog.
  ({String lessonId, int step})? continueTarget(ModuleCatalog c) {
    LessonProgress? best;
    for (final p in _lessons.values) {
      if (p.resumeStep == null || c.lessonById(p.lessonId) == null) continue;
      if (p.lessonId == _last) {
        best = p;
        break;
      }
      if (best == null || p.updatedAt.isAfter(best.updatedAt)) best = p;
    }
    if (best == null) return null;
    final lesson = c.lessonById(best.lessonId)!;
    var step = best.resumeStep!;
    final byId = best.resumeStepId == null
        ? -1
        : lesson.steps.indexWhere((s) => s.id == best!.resumeStepId);
    if (byId >= 0) step = byId;
    step = step.clamp(0, lesson.steps.length - 1);
    return (lessonId: best.lessonId, step: step);
  }

  Future<void> _commit() {
    notifyListeners();
    return _repository.save(
      ProgressSnapshot(lessons: Map.of(_lessons), lastLessonId: _last),
    );
  }
}
