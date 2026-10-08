import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/app/app_scope.dart';
import 'package:kadam/core/app/app_services.dart';
import 'package:kadam/core/app/kadam_app.dart';
import 'package:kadam/core/app/lesson_launcher.dart';
import 'package:kadam/core/app/text_scale.dart';
import 'package:kadam/core/content/catalog.dart';
import 'package:kadam/core/content/lesson.dart';
import 'package:kadam/core/content/localized_text.dart';
import 'package:kadam/core/settings/app_settings.dart';
import 'package:kadam/core/sim_api/scene_context.dart';
import 'package:kadam/core/sim_api/scene_sizes.dart';
import 'package:kadam/core/sim_api/scene_spec.dart';
import 'package:kadam/core/sim_api/simulator_frame.dart';
import 'package:kadam/core/sim_api/target_registry.dart';

import 'fakes.dart';

/// Pumps [child] as `home` of the real app (providers, theme, l10n, text
/// scale). `size` is the logical view size (DPR 1.0), `scale` the SYSTEM text
/// scale. With `reduceMotion` (default) `disableAnimations` is on, so no
/// repeating animation is created. Everything is reset in `addTearDown`.
///
/// If [services] is given, [theme] and [lang] are ignored (the services'
/// settings win). Returns the services in use.
Future<AppServices> pumpApp(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(360, 800),
  double scale = 1.0,
  AppThemeMode theme = AppThemeMode.light,
  AppLanguage lang = AppLanguage.ru,
  AppServices? services,
  ModuleCatalog? catalog,
  LessonLauncher? launcher,
  bool reduceMotion = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: reduceMotion);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  final s =
      services ??
      AppServices.forTest(
        settings: AppSettings(
          language: lang,
          theme: theme,
          onboardingCompleted: true,
        ),
      );
  await tester.pumpWidget(
    AppScope(
      services: s,
      modules: catalog ?? testCatalog(),
      launcher: launcher ?? FakeLessonLauncher(),
      child: KadamMaterialApp(home: child),
    ),
  );
  await tester.pump();
  return s;
}

/// Renders [spec] the way the engine will: inside the real `SimulatorFrame`
/// constrained to exactly [sceneSize] (its OUTER size), `SceneScope`,
/// `TargetScope` and a 1.5 text clamp. Returns the recording context
/// (`ctx.registry` is the scene's `TargetRegistry`).
///
/// Does NOT run accessibility guidelines itself; call `expectA11y`.
Future<FakeSceneContext> pumpScene(
  WidgetTester tester,
  SceneSpec spec, {
  Lesson? lesson,
  LessonStep? step,
  Size sceneSize = kSceneCompact,
  double scale = 1.5,
  AppThemeMode theme = AppThemeMode.light,
  AppLanguage lang = AppLanguage.ru,
  bool reduceMotion = true,
  Map<String, String>? data,
}) async {
  final st = step ?? stubStep(spec);
  final ls = lesson ?? stubLesson(st);
  final ctx = FakeSceneContext(
    lesson: ls,
    step: st,
    language: lang,
    data: data,
  );
  final registry = TargetRegistry();
  ctx.registry = registry;
  addTearDown(registry.dispose);
  final view = Size(
    math.max(320, sceneSize.width + 32),
    math.max(640, sceneSize.height + 120),
  );
  await pumpApp(
    tester,
    Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SceneScope(
            sceneContext: ctx,
            child: TargetScope(
              registry: registry,
              child: ChromeScale(
                child: SizedBox.fromSize(
                  size: sceneSize,
                  child: SimulatorFrame(
                    badge: st.badge,
                    child: Builder(builder: (c) => spec.build(c, ctx)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    size: view,
    scale: scale,
    theme: theme,
    lang: lang,
    reduceMotion: reduceMotion,
  );
  return ctx;
}

/// `pump()`, then `pump(50 ms)` until no frame is scheduled (max 40). Never
/// throws, unlike `pumpAndSettle`.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 40 && tester.binding.hasScheduledFrame; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
