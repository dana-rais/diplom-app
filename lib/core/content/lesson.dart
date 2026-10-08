import '../sim_api/scene_spec.dart';
import 'actions.dart';
import 'localized_text.dart';

/// How a step is laid out by the engine.
enum StepPresentation { simulator, panel, explainer }

enum TrainingBadgeKind { mode, call, sms, message }

enum LessonIndicator { steps, scenario }

class LessonStep {
  const LessonStep({
    required this.id,
    required this.scene,
    required this.expected,
    required this.instruction,
    required this.hint,
    required this.outcomeLabel,
    this.presentation = StepPresentation.simulator,
    this.badge = TrainingBadgeKind.mode,
    this.panelAction,
    this.autoAdvance = false,
    this.initialHelpLevel = 1,
    this.hintTargetId,
    this.hintKind,
  });

  /// Unique inside the lesson; `[a-z0-9_]+`.
  final String id;
  final SceneSpec scene;
  final ExpectedAction expected;
  final LocalizedText instruction;

  /// Shown after a miss («Почти получилось»).
  final LocalizedText hint;

  /// Short line for the summary list («Нажать на большой круг»).
  final LocalizedText outcomeLabel;
  final StepPresentation presentation;
  final TrainingBadgeKind badge;

  /// Label of the button in the instruction panel that reports
  /// [kPanelActionTarget] (e.g. «Выбрать»). Null = no such button.
  final LocalizedText? panelAction;

  /// Skip the success card and move on immediately after a match.
  final bool autoAdvance;

  /// 1..3 (3 = text + hole + finger).
  final int initialHelpLevel;

  /// Spotlight/finger fallback when the expected target is not mounted/visible.
  final String? hintTargetId;
  final GestureKind? hintKind;
}

/// A pre-recorded voice line that is not derived from a step/lesson text.
class VoiceLine {
  const VoiceLine(this.key, this.text);

  final String key;
  final LocalizedText text;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.intro,
    required this.summary,
    required this.steps,
    this.indicator = LessonIndicator.steps,
    this.extraVoice = const [],
  });

  /// `<moduleId>.<name>`, e.g. `gestures.tap`.
  final String id;
  final LocalizedText title;
  final LocalizedText intro;
  final LocalizedText summary;
  final List<LessonStep> steps;
  final LessonIndicator indicator;
  final List<VoiceLine> extraVoice;
}
