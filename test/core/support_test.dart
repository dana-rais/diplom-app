import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/content/actions.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/settings/app_settings.dart';
import 'package:kadam/core/sim_api/simulator_frame.dart';
import 'package:kadam/core/sim_api/target_registry.dart';

import '../support/support.dart';

void main() {
  testWidgets('settle terminates and never throws', (tester) async {
    await pumpApp(tester, const Scaffold(body: SizedBox()));
    await settle(tester);
    // A never-ending animation: settle stops after its iteration cap.
    await tester.pumpWidget(
      const MaterialApp(home: CircularProgressIndicator()),
    );
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'pumpApp applies size, scale, motion preference, theme, language',
    (tester) async {
      late BuildContext ctx;
      await pumpApp(
        tester,
        Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
        size: const Size(320, 640),
        scale: 2.0,
        theme: AppThemeMode.highContrast,
        lang: AppLanguage.kk,
        reduceMotion: true,
      );
      expect(MediaQuery.sizeOf(ctx), const Size(320, 640));
      expect(MediaQuery.textScalerOf(ctx).scale(10), 20);
      expect(MediaQuery.disableAnimationsOf(ctx), isTrue);
      expect(Theme.of(ctx).brightness, Brightness.dark);
      expect(Localizations.localeOf(ctx).languageCode, 'kk');
    },
  );

  testWidgets('pumpApp reduceMotion: false leaves animations on', (
    tester,
  ) async {
    late BuildContext ctx;
    await pumpApp(
      tester,
      Builder(
        builder: (c) {
          ctx = c;
          return const SizedBox();
        },
      ),
      reduceMotion: false,
    );
    expect(MediaQuery.disableAnimationsOf(ctx), isFalse);
  });

  for (final size in [kSceneCompact, kSceneRegular]) {
    testWidgets('A3: SimulatorFrame outer size == $size', (tester) async {
      await pumpScene(tester, const TapScene(), sceneSize: size);
      expect(tester.getSize(find.byType(SimulatorFrame)), size);
      expectNoLayoutErrors(tester);
    });
  }

  testWidgets('pumpScene: scope, registry, recording context', (tester) async {
    final ctx = await pumpScene(tester, const TapScene(), lang: AppLanguage.kk);
    expect(ctx.registry.isMounted('btn'), isTrue);
    expectUniqueTargets(ctx.registry);
    expectInViewport(tester, find.text('Tap'));
    await tester.tap(find.text('Tap'));
    expect(ctx.actions.single.targetId, 'btn');
    expect(ctx.actions.single.kind, GestureKind.tap);
    expect(ctx.lastAction, ctx.actions.single);
    expect(ctx.t(const LocalizedText(kk: 'қ', ru: 'р')), 'қ');
    // badge strip is above the scene, translated
    expect(find.text('Оқу режимі'), findsOneWidget);
    await expectA11y(tester);
    expectNoTruncatedText(tester);
  });

  testWidgets(
    'pumpScene at scale 1.5 / high contrast has no overflow in the compact box',
    (tester) async {
      await pumpScene(
        tester,
        const TapScene(),
        theme: AppThemeMode.highContrast,
        lang: AppLanguage.kk,
      );
      expectNoLayoutErrors(tester);
    },
  );

  testWidgets('ListScene: inner list scrolls and reports progress', (
    tester,
  ) async {
    final ctx = await pumpScene(tester, const ListScene());
    expect(ctx.registry.isMounted('list'), isTrue);
    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pump();
    expect(
      ctx.actions.any(
        (a) => a.kind == GestureKind.progress && a.targetId == 'list',
      ),
      isTrue,
    );
  });

  testWidgets('expectInViewport fails for off-screen widgets', (tester) async {
    await pumpApp(
      tester,
      const Scaffold(
        body: Stack(
          children: [Positioned(left: 1000, top: 10, child: Text('far'))],
        ),
      ),
    );
    expect(() => expectInViewport(tester, find.text('far')), throwsA(anything));
  });

  testWidgets('expectUniqueTargets fails on duplicates', (tester) async {
    final r = TargetRegistry();
    addTearDown(r.dispose);
    final k1 = GlobalKey(), k2 = GlobalKey();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            SizedBox(key: k1),
            SizedBox(key: k2),
          ],
        ),
      ),
    );
    r.register('x', k1, TargetShape.circle);
    r.register('x', k2, TargetShape.circle);
    expect(() => expectUniqueTargets(r), throwsA(anything));
    await tester.pump();
  });

  test('FakeAudioBackend / InMemoryStore / testCatalog basics', () async {
    final b = FakeAudioBackend();
    await b.play('a', rate: 0.85);
    expect(b.played.single.rate, 0.85);
    final s = InMemoryStore({'k': 'v'});
    await s.setString('x', 'y');
    expect(s.getString('x'), 'y');
    await s.remove('x');
    expect(s.getString('x'), isNull);
    expect(testCatalog().modules, hasLength(2));
  });

  testWidgets('FakeLessonLauncher records openLesson', (tester) async {
    final l = FakeLessonLauncher();
    late BuildContext ctx;
    await pumpApp(
      tester,
      Builder(
        builder: (c) {
          ctx = c;
          return const SizedBox();
        },
      ),
      launcher: l,
    );
    await l.openLesson(ctx, 'test_a.one', resume: false);
    expect(l.opened.single, (lessonId: 'test_a.one', resume: false));
  });
}
