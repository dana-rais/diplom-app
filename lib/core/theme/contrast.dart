import 'dart:ui';

/// WCAG relative-luminance contrast ratio (1..21). Both colors are treated as
/// opaque; composite translucent colors yourself first (see [overOpaque]).
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

/// [fg] (possibly translucent) painted over the opaque [bg].
Color overOpaque(Color fg, Color bg) => Color.alphaBlend(fg, bg);
