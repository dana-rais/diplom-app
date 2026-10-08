import 'package:flutter/material.dart';

import '../content/lesson.dart';
import '../theme/app_tokens.dart';
import 'dashed_border.dart';
import 'training_badge.dart';

/// Dashed frame + «Учебный режим» strip ABOVE the scene (never overlaying it).
/// It fills the constraints it is given: that box is the scene contract
/// (`kSceneCompact` / `kSceneRegular` are its OUTER size).
class SimulatorFrame extends StatelessWidget {
  const SimulatorFrame({
    super.key,
    required this.badge,
    this.trailing,
    required this.child,
  });

  final TrainingBadgeKind badge;

  /// Optional widget at the right end of the badge strip (e.g. «Ситуация 1 из 6»).
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return DashedBorder(
      color: t.simulatorFrame,
      radius: AppSizes.frameRadius,
      strokeWidth: AppSizes.outline,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.outline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppSizes.frameRadius - AppSizes.outline,
          ),
          child: ColoredBox(
            color: t.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: TrainingBadge(badge)),
                      if (trailing != null) ...[
                        const SizedBox(width: AppSizes.s8),
                        Flexible(child: trailing!),
                      ],
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
