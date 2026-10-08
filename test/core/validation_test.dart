import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/content/actions.dart';
import 'package:kadam/core/content/lesson.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/content/module.dart';
import 'package:kadam/core/content/validation.dart';

import '../support/support.dart';

const _t = LocalizedText(kk: 'қ', ru: 'р');

LessonStep _step(
  String id, {
  LocalizedText instruction = _t,
  LocalizedText hint = _t,
  LocalizedText outcome = _t,
  StepPresentation presentation = StepPresentation.simulator,
  String? hintTargetId,
  GestureKind? hintKind,
  int level = 1,
}) => LessonStep(
  id: id,
  scene: const TapScene(),
  expected: const ExpectedAction('btn', GestureKind.tap),
  instruction: instruction,
  hint: hint,
  outcomeLabel: outcome,
  presentation: presentation,
  hintTargetId: hintTargetId,
  hintKind: hintKind,
  initialHelpLevel: level,
);

Lesson _lesson(
  String id, {
  List<LessonStep>? steps,
  LocalizedText title = _t,
  List<VoiceLine> extra = const [],
}) => Lesson(
  id: id,
  title: title,
  intro: _t,
  summary: _t,
  steps: steps ?? [_step('a'), _step('b'), _step('c')],
  extraVoice: extra,
);

LearningModule _module(
  List<Lesson> lessons, {
  String id = 'm',
  LocalizedText title = _t,
}) => LearningModule(
  id: id,
  title: title,
  shortTitle: _t,
  description: _t,
  icon: Icons.circle,
  lessons: lessons,
);

bool _has(List<String> errors, String part) =>
    errors.any((e) => e.contains(part));

void main() {
  test('a well-formed module is valid', () {
    expect(validateModule(_module([_lesson('m.one')])), isEmpty);
    for (final m in testCatalog().modules) {
      expect(validateModule(m), isEmpty, reason: m.id);
    }
  });

  test('lesson id must start with the module prefix', () {
    expect(
      _has(validateModule(_module([_lesson('x.one')])), 'must start with "m."'),
      isTrue,
    );
    expect(
      _has(
        validateModule(_module([_lesson('mm.one')])),
        'must start with "m."',
      ),
      isTrue,
    );
  });

  test('duplicate lesson ids', () {
    expect(
      _has(
        validateModule(_module([_lesson('m.one'), _lesson('m.one')])),
        'duplicate lesson id',
      ),
      isTrue,
    );
  });

  test('duplicate step ids', () {
    final l = _lesson('m.one', steps: [_step('a'), _step('a'), _step('c')]);
    expect(_has(validateModule(_module([l])), 'duplicate step id'), isTrue);
  });

  test('3..8 steps', () {
    final two = _lesson('m.one', steps: [_step('a'), _step('b')]);
    expect(_has(validateModule(_module([two])), 'expected 3..8'), isTrue);
    final nine = _lesson(
      'm.one',
      steps: [for (var i = 0; i < 9; i++) _step('s$i')],
    );
    expect(_has(validateModule(_module([nine])), 'expected 3..8'), isTrue);
    final eight = _lesson(
      'm.one',
      steps: [for (var i = 0; i < 8; i++) _step('s$i')],
    );
    expect(validateModule(_module([eight])), isEmpty);
  });

  test('empty kk or ru text anywhere', () {
    const empty = LocalizedText(kk: '', ru: 'р');
    const emptyRu = LocalizedText(kk: 'қ', ru: ' ');
    expect(
      _has(
        validateModule(_module([_lesson('m.one', title: empty)])),
        'title: kk is empty',
      ),
      isTrue,
    );
    expect(
      _has(
        validateModule(_module([_lesson('m.one')], title: emptyRu)),
        'ru is empty',
      ),
      isTrue,
    );
    final steps = [
      _step('a', instruction: empty),
      _step('b', hint: emptyRu),
      _step('c', outcome: empty),
    ];
    final e = validateModule(_module([_lesson('m.one', steps: steps)]));
    expect(_has(e, 'instruction: kk is empty'), isTrue);
    expect(_has(e, 'hint: ru is empty'), isTrue);
    expect(_has(e, 'outcomeLabel: kk is empty'), isTrue);
    final extra = _lesson('m.one', extra: [const VoiceLine('m.one.x', empty)]);
    expect(_has(validateModule(_module([extra])), 'extraVoice'), isTrue);
  });

  test('instruction longer than 12 words (non-explainer only)', () {
    const long = LocalizedText(
      kk: 'бір екі үш төрт бес алты жеті сегіз тоғыз он он бір он екі он үш',
      ru: 'один два три четыре пять шесть семь восемь девять десять одиннадцать двенадцать тринадцать',
    );
    final sim = _lesson(
      'm.one',
      steps: [
        _step('a', instruction: long),
        _step('b'),
        _step('c'),
      ],
    );
    final e = validateModule(_module([sim]));
    expect(_has(e, 'kk instruction is longer than 12 words'), isTrue);
    expect(_has(e, 'ru instruction is longer than 12 words'), isTrue);
    final explainer = _lesson(
      'm.one',
      steps: [
        _step('a', instruction: long, presentation: StepPresentation.explainer),
        _step('b'),
        _step('c'),
      ],
    );
    expect(validateModule(_module([explainer])), isEmpty);
  });

  test('voice key pattern', () {
    final bad = _lesson('m.One');
    expect(_has(validateModule(_module([bad])), 'key pattern'), isTrue);
    final badStep = _lesson(
      'm.one',
      steps: [_step('A-b'), _step('b'), _step('c')],
    );
    final e = validateModule(_module([badStep]));
    expect(_has(e, 'step id must match'), isTrue);
    expect(_has(e, 'key pattern'), isTrue);
  });

  test(
    'extraVoice keys: pattern, uniqueness, no collision with generated keys',
    () {
      final l = _lesson(
        'm.one',
        extra: const [
          VoiceLine('m.one.extra', _t),
          VoiceLine('m.one.extra', _t),
          VoiceLine('Bad Key', _t),
          VoiceLine('m.one.a', _t),
        ],
      );
      final e = validateModule(_module([l]));
      expect(_has(e, 'duplicate extraVoice key'), isTrue);
      expect(_has(e, 'does not match the key pattern'), isTrue);
      expect(_has(e, 'collides with another voice key'), isTrue);
    },
  );

  test('hintKind needs hintTargetId (unless it equals the expected kind)', () {
    final bad = _lesson(
      'm.one',
      steps: [
        _step('a', hintKind: GestureKind.swipeUp),
        _step('b'),
        _step('c'),
      ],
    );
    expect(
      _has(
        validateModule(_module([bad])),
        'hintKind is set without hintTargetId',
      ),
      isTrue,
    );
    final ok = _lesson(
      'm.one',
      steps: [
        _step('a', hintTargetId: 'list', hintKind: GestureKind.swipeUp),
        _step('b', hintKind: GestureKind.tap),
        _step('c'),
      ],
    );
    expect(validateModule(_module([ok])), isEmpty);
  });

  test('initialHelpLevel must be 1..3', () {
    final l = _lesson(
      'm.one',
      steps: [_step('a', level: 4), _step('b'), _step('c')],
    );
    expect(_has(validateModule(_module([l])), 'initialHelpLevel'), isTrue);
  });

  test('extras must be prefixed with the module id', () {
    final m = LearningModule(
      id: 'm',
      title: _t,
      shortTitle: _t,
      description: _t,
      icon: Icons.circle,
      lessons: [_lesson('m.one')],
      extras: [
        ModuleExtra(
          id: 'other.memo',
          title: _t,
          icon: Icons.list,
          builder: (_) => const SizedBox(),
        ),
      ],
    );
    expect(_has(validateModule(m), 'extra other.memo'), isTrue);
  });
}
