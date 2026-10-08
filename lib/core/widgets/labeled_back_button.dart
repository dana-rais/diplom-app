import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// «← Назад»: always icon + word, at least 56 dp tall.
class LabeledBackButton extends StatelessWidget {
  const LabeledBackButton({super.key, this.onPressed, this.label});

  /// Defaults to `Navigator.maybePop`.
  final VoidCallback? onPressed;

  /// Defaults to the localized «Назад».
  final String? label;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    icon: const Icon(Icons.arrow_back),
    label: Text(label ?? AppLocalizations.of(context).back),
  );
}
