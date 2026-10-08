import 'package:flutter/widgets.dart';

import '../content/actions.dart';
import '../content/lesson.dart';
import '../content/localized_text.dart';

/// The channel between a scene and the lesson engine.
abstract class SceneContext {
  Lesson get lesson;
  LessonStep get step;
  AppLanguage get language;

  /// Current help level, 1..3.
  int get helpLevel;

  /// Report what the user did. Final actions on pointer-up / gesture end,
  /// partial interactions as `GestureKind.progress`.
  void report(UserAction a);

  /// Per-lesson-run key/value data (survives resume).
  String? data(String k);
  void setData(String k, String v);

  /// Mark the current step as «difficult» (e.g. a risky choice).
  void markStruggle();

  /// Play a voice key (e.g. a caller line); no-op when the file is missing.
  void playVoice(String key);

  String t(LocalizedText x) => x.resolve(language);
}

class SceneScope extends InheritedWidget {
  const SceneScope({
    super.key,
    required this.sceneContext,
    required super.child,
  });

  final SceneContext sceneContext;

  static SceneContext of(BuildContext c) {
    final s = c.dependOnInheritedWidgetOfExactType<SceneScope>();
    assert(s != null, 'No SceneScope above this context');
    return s!.sceneContext;
  }

  @override
  bool updateShouldNotify(SceneScope old) => true;
}
