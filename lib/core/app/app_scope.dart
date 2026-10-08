import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../audio/feedback_service.dart';
import '../audio/voice_service.dart';
import '../content/catalog.dart';
import '../progress/progress_controller.dart';
import '../settings/settings_controller.dart';
import 'app_services.dart';
import 'lesson_launcher.dart';

/// Exposes the app services through `provider`. Read them anywhere below with
/// `context.read<T>()` / `context.watch<T>()` for:
/// [AppServices], [SettingsController], [ProgressController], [VoiceService],
/// [FeedbackService], [ModuleCatalog], [LessonLauncher].
class AppScope extends StatelessWidget {
  const AppScope({
    super.key,
    required this.services,
    required this.modules,
    required this.launcher,
    required this.child,
  });

  final AppServices services;
  final ModuleCatalog modules;
  final LessonLauncher launcher;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider<AppServices>.value(value: services),
      ChangeNotifierProvider<SettingsController>.value(
        value: services.settings,
      ),
      ChangeNotifierProvider<ProgressController>.value(
        value: services.progress,
      ),
      ChangeNotifierProvider<VoiceService>.value(value: services.voice),
      Provider<FeedbackService>.value(value: services.feedback),
      Provider<ModuleCatalog>.value(value: modules),
      Provider<LessonLauncher>.value(value: launcher),
    ],
    child: child,
  );
}
