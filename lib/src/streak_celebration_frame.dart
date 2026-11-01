import 'package:flutter/material.dart';
import 'streak_palette.dart';
import 'streak_celebration_style.dart';

/// Internal scrolling inline card, shared by inline and popup presentations.
class StreakCelebrationFrame extends StatelessWidget {
  /// Creates the internal presentation component.
  const StreakCelebrationFrame({
    required this.palette,
    required this.style,
    required this.maxWidth,
    required this.child,
    super.key,
  });

  /// Configuration supplied by the shared widget.
  final StreakPalette palette;

  /// Configuration supplied by the shared widget.
  final StreakCelebrationStyle style;

  /// Configuration supplied by the shared widget.
  final double maxWidth;

  /// Configuration supplied by the shared widget.
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final shape =
        style.shape ??
        RoundedRectangleBorder(
          borderRadius: style.borderRadius,
          side: BorderSide(
            color: style.borderColor ?? palette.accent.withValues(alpha: 0.35),
            width: style.borderWidth,
            style: style.borderWidth == 0
                ? BorderStyle.none
                : BorderStyle.solid,
          ),
        );
    return Align(
      alignment: Alignment.topCenter,
      widthFactor: 1,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: style.margin,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: style.backgroundGradient == null
                  ? (style.backgroundColor ?? palette.surface)
                  : null,
              gradient: style.backgroundGradient,
              shape: shape,
              shadows: style.shadows,
            ),
            child: ClipPath(
              clipper: ShapeBorderClipper(shape: shape),
              child: Material(
                type: MaterialType.transparency,
                child: SingleChildScrollView(
                  padding: style.padding,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
