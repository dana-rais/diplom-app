import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

/// Two-choice dialog with a scrollable body and stacked full-width buttons:
/// the SAFE choice on top (primary), the other below (secondary).
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    required this.safeLabel,
    required this.confirmLabel,
  });

  final String title, body;

  /// Top, primary button (e.g. «Остаться в уроке»). Pops `false`.
  final String safeLabel;

  /// Bottom, secondary button (e.g. «Выйти»). Pops `true`.
  final String confirmLabel;

  /// Resolves to true only if [confirmLabel] was chosen; dismissing counts as
  /// the safe choice (false).
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String body,
    required String safeLabel,
    required String confirmLabel,
  }) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        body: body,
        safeLabel: safeLabel,
        confirmLabel: confirmLabel,
      ),
    );
    return r ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSizes.s16),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        namesRoute: true,
        label: title,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: text.titleLarge),
              const SizedBox(height: AppSizes.s12),
              Text(body, style: text.bodyMedium),
              const SizedBox(height: AppSizes.s24),
              PrimaryButton(
                label: safeLabel,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(height: AppSizes.gap),
              SecondaryButton(
                label: confirmLabel,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
