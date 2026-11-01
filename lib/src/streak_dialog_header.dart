import 'package:flutter/material.dart';
import 'streak_palette.dart';
import 'streak_strings.dart';
import 'streak_celebration_style.dart';

/// Internal wrapping header with optional close action.
class StreakDialogHeader extends StatelessWidget {
  /// Creates the shared header.
  const StreakDialogHeader({
    required this.strings,
    required this.palette,
    this.style = const StreakCelebrationStyle(),
    this.onClose,
    super.key,
  });

  /// Localized header and dismissal labels.
  final StreakStrings strings;

  /// Shared color fallbacks.
  final StreakPalette palette;

  /// Optional pill and close control overrides.
  final StreakCelebrationStyle style;

  /// Optional host close action.
  final VoidCallback? onClose;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: style.headerGradient == null
                  ? (style.headerBackgroundColor ??
                        palette.accent.withValues(alpha: 0.15))
                  : null,
              gradient: style.headerGradient,
              shape:
                  style.headerShape ??
                  RoundedRectangleBorder(
                    borderRadius: style.headerBorderRadius,
                    side: BorderSide(
                      color: style.headerBorderColor ?? Colors.transparent,
                      width: style.headerBorderWidth,
                      style: style.headerBorderWidth == 0
                          ? BorderStyle.none
                          : BorderStyle.solid,
                    ),
                  ),
            ),
            child: Padding(
              padding: style.headerPadding,
              child: Text(
                strings.badge,
                style: TextStyle(
                  color:
                      style.headerForegroundColor ??
                      palette.secondaryForeground,
                  fontWeight: FontWeight.w700,
                ).merge(style.headerTextStyle),
              ),
            ),
          ),
        ),
      ),
      if (style.showCloseButton && onClose != null)
        IconButton(
          tooltip: strings.dismissLabel,
          onPressed: onClose,
          iconSize: style.closeIconSize,
          style: (style.closeButtonStyle ?? const ButtonStyle()).merge(
            IconButton.styleFrom(
              foregroundColor: style.closeColor ?? palette.foreground,
              backgroundColor: style.closeBackgroundColor,
              minimumSize: const Size(48, 48),
              shape: style.closeShape,
              side: BorderSide(
                color: style.closeBorderColor ?? Colors.transparent,
                width: style.closeBorderWidth,
                style: style.closeBorderWidth == 0
                    ? BorderStyle.none
                    : BorderStyle.solid,
              ),
            ),
          ),
          icon: const Icon(Icons.close_rounded),
        ),
    ],
  );
}
