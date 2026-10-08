class StepRecord {
  const StepRecord({
    this.misses = 0,
    this.maxHelpLevel = 1,
    this.struggled = false,
  });

  final int misses;
  final int maxHelpLevel;
  final bool struggled;

  bool get difficult => misses >= 2 || maxHelpLevel >= 3 || struggled;

  StepRecord copyWith({int? misses, int? maxHelpLevel, bool? struggled}) =>
      StepRecord(
        misses: misses ?? this.misses,
        maxHelpLevel: maxHelpLevel ?? this.maxHelpLevel,
        struggled: struggled ?? this.struggled,
      );

  Map<String, Object?> toJson() => {
    'misses': misses,
    'help': maxHelpLevel,
    'struggled': struggled,
  };

  factory StepRecord.fromJson(Map<String, Object?> j) => StepRecord(
    misses: j['misses'] is int ? j['misses']! as int : 0,
    maxHelpLevel: j['help'] is int ? j['help']! as int : 1,
    struggled: j['struggled'] == true,
  );
}

class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    this.completed = false,
    this.resumeStep,
    this.resumeStepId,
    this.data = const {},
    this.steps = const {},
    required this.updatedAt,
  });

  final String lessonId;
  final bool completed;

  /// Index of the step to resume at; null = no run in progress.
  final int? resumeStep;

  /// Preferred over [resumeStep] when it still exists in the lesson.
  final String? resumeStepId;

  /// Scene data of the current run (`SceneContext.setData`).
  final Map<String, String> data;
  final Map<String, StepRecord> steps;
  final DateTime updatedAt;

  /// True when any recorded step was difficult.
  bool get difficult => steps.values.any((s) => s.difficult);

  LessonProgress copyWith({
    bool? completed,
    int? resumeStep,
    String? resumeStepId,
    bool clearResume = false,
    Map<String, String>? data,
    Map<String, StepRecord>? steps,
    DateTime? updatedAt,
  }) => LessonProgress(
    lessonId: lessonId,
    completed: completed ?? this.completed,
    resumeStep: clearResume ? null : (resumeStep ?? this.resumeStep),
    resumeStepId: clearResume ? null : (resumeStepId ?? this.resumeStepId),
    data: data ?? this.data,
    steps: steps ?? this.steps,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, Object?> toJson() => {
    'completed': completed,
    'resumeStep': resumeStep,
    'resumeStepId': resumeStepId,
    'data': data,
    'steps': {for (final e in steps.entries) e.key: e.value.toJson()},
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  static LessonProgress? fromJson(String lessonId, Object? raw) {
    if (raw is! Map) return null;
    try {
      final data = raw['data'];
      final steps = raw['steps'];
      return LessonProgress(
        lessonId: lessonId,
        completed: raw['completed'] == true,
        resumeStep: raw['resumeStep'] is int ? raw['resumeStep'] as int : null,
        resumeStepId: raw['resumeStepId'] is String
            ? raw['resumeStepId'] as String
            : null,
        data: data is Map
            ? {
                for (final e in data.entries)
                  if (e.key is String && e.value is String)
                    e.key as String: e.value as String,
              }
            : const {},
        steps: steps is Map
            ? {
                for (final e in steps.entries)
                  if (e.key is String && e.value is Map)
                    e.key as String: StepRecord.fromJson(
                      (e.value as Map).cast<String, Object?>(),
                    ),
              }
            : const {},
        updatedAt:
            DateTime.tryParse(raw['updatedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );
    } catch (_) {
      return null;
    }
  }
}
