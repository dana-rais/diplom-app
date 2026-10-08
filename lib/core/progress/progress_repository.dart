import 'dart:convert';

import '../storage/key_value_store.dart';
import 'lesson_progress.dart';

const kProgressKey = 'progress.v1';

class ProgressSnapshot {
  const ProgressSnapshot({this.lessons = const {}, this.lastLessonId});

  final Map<String, LessonProgress> lessons;
  final String? lastLessonId;
}

class ProgressRepository {
  ProgressRepository(this._store);

  final KeyValueStore _store;

  /// Corrupt or unknown-version data gives an empty snapshot; a single
  /// corrupt lesson entry is skipped.
  ProgressSnapshot load() {
    final raw = _store.getString(kProgressKey);
    if (raw == null) return const ProgressSnapshot();
    try {
      final j = jsonDecode(raw);
      if (j is! Map || j['v'] != 1) return const ProgressSnapshot();
      final lessons = <String, LessonProgress>{};
      final map = j['lessons'];
      if (map is Map) {
        for (final e in map.entries) {
          if (e.key is! String) continue;
          final p = LessonProgress.fromJson(e.key as String, e.value);
          if (p != null) lessons[p.lessonId] = p;
        }
      }
      final last = j['last'];
      return ProgressSnapshot(
        lessons: lessons,
        lastLessonId: last is String && lessons.containsKey(last) ? last : null,
      );
    } catch (_) {
      return const ProgressSnapshot();
    }
  }

  Future<void> save(ProgressSnapshot s) => _store.setString(
    kProgressKey,
    jsonEncode({
      'v': 1,
      'last': s.lastLessonId,
      'lessons': {for (final e in s.lessons.entries) e.key: e.value.toJson()},
    }),
  );

  Future<void> clear() => _store.remove(kProgressKey);
}
