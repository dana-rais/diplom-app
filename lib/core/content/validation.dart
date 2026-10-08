import 'lesson.dart';
import 'module.dart';
import 'voice_keys.dart';

final _idPattern = RegExp(r'^[a-z0-9_]+$');

int _words(String s) =>
    s.trim().isEmpty ? 0 : s.trim().split(RegExp(r'\s+')).length;

/// Returns human-readable problems; an empty list means the module is valid.
///
/// Checks: `"<module.id>."` lesson prefix; unique lesson/step ids; 3..8 steps;
/// kk + ru non-empty everywhere; instruction <= 12 words (both languages) for
/// non-explainer steps; voice key pattern; unique extraVoice keys (also against
/// the generated intro/step/hint/summary keys); `hintKind` without
/// `hintTargetId` only if it equals the expected kind.
List<String> validateModule(LearningModule m) {
  final errors = <String>[];
  void text(String where, String kk, String ru) {
    if (kk.trim().isEmpty) errors.add('$where: kk is empty');
    if (ru.trim().isEmpty) errors.add('$where: ru is empty');
  }

  if (!_idPattern.hasMatch(m.id)) {
    errors.add('module id "${m.id}" must match [a-z0-9_]+');
  }
  text('module ${m.id} title', m.title.kk, m.title.ru);
  text('module ${m.id} shortTitle', m.shortTitle.kk, m.shortTitle.ru);
  text('module ${m.id} description', m.description.kk, m.description.ru);
  for (final e in m.extras) {
    if (!e.id.startsWith('${m.id}.')) {
      errors.add('extra ${e.id}: id must start with "${m.id}."');
    }
    text('extra ${e.id} title', e.title.kk, e.title.ru);
  }

  final lessonIds = <String>{};
  final allKeys = <String>{};
  void key(String where, String k) {
    if (!kVoiceKeyPattern.hasMatch(k)) {
      errors.add('$where: voice key "$k" does not match the key pattern');
    }
    if (!allKeys.add(k)) errors.add('$where: duplicate voice key "$k"');
  }

  for (final l in m.lessons) {
    if (!l.id.startsWith('${m.id}.')) {
      errors.add('lesson ${l.id}: id must start with "${m.id}."');
    }
    if (!lessonIds.add(l.id)) errors.add('lesson ${l.id}: duplicate lesson id');
    text('lesson ${l.id} title', l.title.kk, l.title.ru);
    text('lesson ${l.id} intro', l.intro.kk, l.intro.ru);
    text('lesson ${l.id} summary', l.summary.kk, l.summary.ru);
    key('lesson ${l.id}', introKey(l));
    key('lesson ${l.id}', summaryKey(l));
    if (l.steps.length < 3 || l.steps.length > 8) {
      errors.add('lesson ${l.id}: has ${l.steps.length} steps, expected 3..8');
    }
    final stepIds = <String>{};
    for (final s in l.steps) {
      final w = 'lesson ${l.id} step ${s.id}';
      if (!_idPattern.hasMatch(s.id)) {
        errors.add('$w: step id must match [a-z0-9_]+');
      }
      if (!stepIds.add(s.id)) errors.add('$w: duplicate step id');
      text('$w instruction', s.instruction.kk, s.instruction.ru);
      text('$w hint', s.hint.kk, s.hint.ru);
      text('$w outcomeLabel', s.outcomeLabel.kk, s.outcomeLabel.ru);
      if (s.panelAction != null) {
        text('$w panelAction', s.panelAction!.kk, s.panelAction!.ru);
      }
      if (s.presentation != StepPresentation.explainer) {
        if (_words(s.instruction.kk) > 12) {
          errors.add('$w: kk instruction is longer than 12 words');
        }
        if (_words(s.instruction.ru) > 12) {
          errors.add('$w: ru instruction is longer than 12 words');
        }
      }
      if (s.hintKind != null &&
          s.hintTargetId == null &&
          s.hintKind != s.expected.kind) {
        errors.add('$w: hintKind is set without hintTargetId');
      }
      if (s.initialHelpLevel < 1 || s.initialHelpLevel > 3) {
        errors.add('$w: initialHelpLevel must be 1..3');
      }
      key(w, stepKey(l, s));
      key(w, hintKey(l, s));
    }
    final extraKeys = <String>{};
    for (final v in l.extraVoice) {
      final w = 'lesson ${l.id} extraVoice ${v.key}';
      text(w, v.text.kk, v.text.ru);
      if (!kVoiceKeyPattern.hasMatch(v.key)) {
        errors.add('$w: voice key does not match the key pattern');
      }
      if (!extraKeys.add(v.key)) errors.add('$w: duplicate extraVoice key');
      if (!allKeys.add(v.key)) {
        errors.add('$w: collides with another voice key in the module');
      }
    }
  }
  return errors;
}
