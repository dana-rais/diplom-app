import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../content/lesson.dart';
import '../theme/app_tokens.dart';
import '../theme/app_typography.dart';

/// «Учебный режим» pill. Text wraps instead of truncating.
class TrainingBadge extends StatelessWidget {
  const TrainingBadge(this.kind, {super.key});

  final TrainingBadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.tokens;
    final label = switch (kind) {
      TrainingBadgeKind.mode => l.trainingMode,
      TrainingBadgeKind.call => l.trainingCall,
      TrainingBadgeKind.sms => l.trainingSms,
      TrainingBadgeKind.message => l.trainingShort,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: t.badgeBg,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          label,
          style: AppTypography.badge.copyWith(color: t.onBadge),
        ),
      ),
    );
  }
}
