import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Rounded card (20 dp) with a 2 dp border. With [onTap] it is a button with
/// at least 56 dp height.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSizes.s16),
    this.color,
    this.borderColor,
    this.semanticsLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color, borderColor;

  /// Replaces the merged child semantics when set.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final radius = BorderRadius.circular(AppSizes.cardRadius);
    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.tapMain),
        child: content,
      );
    }
    final card = Material(
      color: color ?? t.card,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: borderColor ?? t.cardBorder,
          width: AppSizes.outline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, borderRadius: radius, child: content),
    );
    if (semanticsLabel == null) return card;
    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticsLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: card,
    );
  }
}
