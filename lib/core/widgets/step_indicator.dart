import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../theme/app_tokens.dart';

/// «Шаг 2 из 5» text plus progress dots. Announced as one label.
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.current,
    required this.total,
    this.showText = true,
    this.showDots = true,
    this.label,
  });

  /// 1-based.
  final int current, total;
  final bool showText, showDots;

  /// Overrides the default «Шаг N из M» (e.g. onboarding «Настройка N из M»).
  final String? label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final text = label ?? AppLocalizations.of(context).stepOf(current, total);
    return Semantics(
      container: true,
      label: text,
      child: ExcludeSemantics(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSizes.s12,
          runSpacing: AppSizes.s4,
          children: [
            if (showText)
              Text(text, style: Theme.of(context).textTheme.bodySmall),
            if (showDots)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 1; i <= total; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSizes.s8),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i <= current ? t.primary : Colors.transparent,
                          border: Border.all(color: t.primary, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
