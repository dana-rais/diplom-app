import 'package:flutter/widgets.dart';

import 'lesson.dart';
import 'localized_text.dart';

/// A non-lesson screen inside a module (e.g. the cyber memo).
class ModuleExtra {
  ModuleExtra({
    required this.id,
    required this.title,
    required this.icon,
    required this.builder,
  });

  /// `<moduleId>.<name>`, e.g. `cyber.memo`.
  final String id;
  final LocalizedText title;
  final IconData icon;
  final WidgetBuilder builder;
}

class LearningModule {
  LearningModule({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.icon,
    required this.lessons,
    this.extras = const [],
  });

  final String id;
  final LocalizedText title;

  /// For narrow places (bottom nav, chips).
  final LocalizedText shortTitle;
  final LocalizedText description;
  final IconData icon;
  final List<Lesson> lessons;
  final List<ModuleExtra> extras;
}
