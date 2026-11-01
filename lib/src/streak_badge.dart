import 'package:flutter/material.dart';

import 'streak_palette.dart';
import 'streak_badge_style.dart';

/// Internal badge; only count transitions rebuild it, never idle flame ticks.
class StreakBadge extends StatelessWidget {
  /// Creates the badge.
  const StreakBadge({
    required this.progress,
    required this.oldNumber,
    required this.newNumber,
    required this.unit,
    required this.palette,
    this.style = const StreakBadgeStyle(),
    this.numberStyle,
    this.unitStyle,
    super.key,
  });

  /// Transition fraction.
  final double progress;

  /// Formatted starting count.
  final String oldNumber;

  /// Formatted target count.
  final String newNumber;

  /// Unit corresponding to the visible count.
  final String unit;

  /// Visual colors.
  final StreakPalette palette;

  /// Badge shape, border, layout and shadows.
  final StreakBadgeStyle style;

  /// Optional override for count typography.
  final TextStyle? numberStyle;

  /// Optional override for unit typography.
  final TextStyle? unitStyle;

  @override
  Widget build(BuildContext context) {
    final entering = Curves.easeOutCubic.transform(
      ((progress - 0.35) / 0.55).clamp(0.0, 1.0),
    );
    final leaving = ((progress - 0.15) / 0.3).clamp(0.0, 1.0);
    final background = palette.badgeBackground ?? palette.surface;
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape:
            style.shape ??
            CircleBorder(
              side: BorderSide(
                color: palette.badgeBorder ?? palette.accent,
                width: style.borderWidth,
                style: style.borderWidth == 0
                    ? BorderStyle.none
                    : style.borderStyle,
              ),
            ),
        gradient:
            palette.badgeGradient ??
            RadialGradient(
              colors: [
                palette.badgeHighlight ??
                    Color.lerp(background, palette.foreground, 0.05)!,
                background,
              ],
            ),
        shadows:
            style.shadows ??
            [
              BoxShadow(
                color:
                    palette.badgeGlow ?? palette.accent.withValues(alpha: 0.4),
                blurRadius: style.glowBlurRadius,
                spreadRadius: style.glowSpreadRadius,
                offset: style.glowOffset,
              ),
            ],
      ),
      child: Padding(
        padding: style.padding,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 88,
            height: 88,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (leaving < 1)
                        Opacity(
                          opacity: 1 - leaving,
                          child: Transform.translate(
                            offset: Offset(0, -36 * leaving),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                oldNumber,
                                style: TextStyle(
                                  fontSize: 44,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                  color:
                                      palette.badgeOldNumber ??
                                      palette.foreground,
                                ).merge(numberStyle),
                              ),
                            ),
                          ),
                        ),
                      if (entering > 0)
                        Opacity(
                          opacity: entering,
                          child: Transform.translate(
                            offset: Offset(0, 36 * (1 - entering)),
                            child: Transform.scale(
                              scale: 0.7 + entering * 0.3,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  newNumber,
                                  style: TextStyle(
                                    fontSize: 46,
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        palette.badgeNumber ??
                                        palette.flameCore,
                                  ).merge(numberStyle),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: palette.badgeLabel ?? palette.secondaryForeground,
                    ).merge(unitStyle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
