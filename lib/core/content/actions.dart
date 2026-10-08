enum GestureKind {
  tap,
  doubleTap,
  longPress,
  swipeLeft,
  swipeRight,
  swipeUp,
  swipeDown,
  scroll,
  pinchZoom,
  drag,
  enterText,
  holdToRecord,
  choice,
  next,
  progress,
}

/// The «action» button in the instruction panel (e.g. «Выбрать»).
const kPanelActionTarget = 'engine.panel_action';

/// The engine's own «Дальше» button.
const kNextTarget = 'engine.next';

/// A tap on the scene background that hit no target (reported by the engine).
const kBackgroundTarget = 'engine.background';

/// What a lesson step waits for.
class ExpectedAction {
  const ExpectedAction(
    this.targetId,
    this.kind, {
    this.value,
    this.dropTargetId,
    this.alsoAccept = const [],
  });

  final String targetId;
  final GestureKind kind;

  /// When non-null the reported [UserAction.value] must be equal.
  final String? value;

  /// For [GestureKind.drag]: id of the target the item must be dropped on.
  /// Informational for the scene; matching itself only uses
  /// [targetId], [kind] and [value].
  final String? dropTargetId;

  /// Alternative actions that also complete the step.
  final List<ExpectedAction> alsoAccept;

  bool matches(UserAction a) {
    if (kind == a.kind &&
        targetId == a.targetId &&
        (value == null || value == a.value)) {
      return true;
    }
    for (final alt in alsoAccept) {
      if (alt.matches(a)) return true;
    }
    return false;
  }
}

/// What the user did in a scene.
class UserAction {
  const UserAction(this.targetId, this.kind, {this.value});

  final String targetId;
  final GestureKind kind;
  final String? value;

  @override
  String toString() => 'UserAction($targetId, ${kind.name}, value: $value)';
}
