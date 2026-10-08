import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../settings/settings_controller.dart';
import '../theme/app_theme.dart';
import 'text_scale.dart';

/// MaterialApp driven by settings: locale, theme (live preview) and text
/// scale. Must be placed below [AppScope].
class KadamMaterialApp extends StatelessWidget {
  const KadamMaterialApp({super.key, required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsController>().value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (c) => AppLocalizations.of(c).appTitle,
      locale: Locale(s.language?.name ?? 'ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.of(s.theme),
      builder: (context, child) => AppTextScale(
        step: s.textScale,
        child: child ?? const SizedBox.shrink(),
      ),
      home: home,
    );
  }
}
