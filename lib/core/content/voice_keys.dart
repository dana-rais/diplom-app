import 'lesson.dart';

String introKey(Lesson l) => '${l.id}.intro';
String stepKey(Lesson l, LessonStep s) => '${l.id}.${s.id}';
String hintKey(Lesson l, LessonStep s) => '${l.id}.${s.id}.hint';
String summaryKey(Lesson l) => '${l.id}.summary';

/// Every voice key (and therefore every audio file name) must match this.
final kVoiceKeyPattern = RegExp(r'^[a-z0-9_]+(\.[a-z0-9_]+)*$');
