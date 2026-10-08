import 'lesson.dart';
import 'module.dart';

/// Read-only index over all modules (order = Home order).
class ModuleCatalog {
  ModuleCatalog(List<LearningModule> m) : _modules = List.unmodifiable(m);

  final List<LearningModule> _modules;

  List<LearningModule> get modules => _modules;

  Iterable<Lesson> get allLessons => _modules.expand((m) => m.lessons);

  Lesson? lessonById(String id) {
    for (final l in allLessons) {
      if (l.id == id) return l;
    }
    return null;
  }

  LearningModule? moduleOfLesson(String id) {
    for (final m in _modules) {
      if (m.lessons.any((l) => l.id == id)) return m;
    }
    return null;
  }

  /// Next lesson in the SAME module, or null for the last one / unknown id.
  String? nextLessonAfter(String id) {
    final m = moduleOfLesson(id);
    if (m == null) return null;
    final i = m.lessons.indexWhere((l) => l.id == id);
    return (i >= 0 && i + 1 < m.lessons.length) ? m.lessons[i + 1].id : null;
  }

  /// Index of the lesson inside its module, or -1.
  int lessonIndexInModule(String id) {
    final m = moduleOfLesson(id);
    return m == null ? -1 : m.lessons.indexWhere((l) => l.id == id);
  }
}
