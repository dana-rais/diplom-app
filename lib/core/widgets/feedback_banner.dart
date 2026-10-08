import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';

enum _FeedbackKind { success, almost }

/// Feedback after an action. «Almost» is a calm retry hint (redo icon, never a
/// cross, never red).
class FeedbackBanner extends StatelessWidget {
  /// Defaults: «Отлично!» / «Вы нажали правильно».
  const FeedbackBanner.success({super.key, this.title, this.body})
    : _kind = _FeedbackKind.success;

  /// Defaults: «Почти получилось» / «Попробуйте ещё раз — я подскажу».
  const FeedbackBanner.almost({super.key, this.title, this.body})
    : _kind = _FeedbackKind.almost;

  final _FeedbackKind _kind;
  final String? title, body;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final ok = _kind == _FeedbackKind.success;
    final bg = ok ? t.successContainer : t.neutralFeedback;
    final accent = ok ? t.success : t.neutralBorder;
    final heading =
        title ?? (ok ? l.feedbackSuccessTitle : l.feedbackAlmostTitle);
    final text = body ?? (ok ? l.feedbackSuccessBody : l.feedbackAlmostBody);
    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(color: accent, width: AppSizes.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                ok ? Icons.check_circle : Icons.replay,
                color: ok ? t.success : t.neutralIcon,
                size: AppSizes.icon,
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: AppTypography.label.copyWith(color: accent),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      text,
                      style: AppTypography.body.copyWith(
                        color: ok ? t.success : t.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
