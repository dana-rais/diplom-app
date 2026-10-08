import 'package:flutter/widgets.dart';

/// Implemented by the engine; features open lessons only through this.
abstract interface class LessonLauncher {
  /// Opens [lessonId]. With [resume] a saved run continues, otherwise the
  /// lesson starts at its intro.
  Future<void> openLesson(
    BuildContext context,
    String lessonId, {
    bool resume = true,
  });
}
