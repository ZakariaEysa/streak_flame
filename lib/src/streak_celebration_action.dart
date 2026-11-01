import 'package:flutter/material.dart';
import 'streak_palette.dart';
import 'streak_strings.dart';
import 'streak_celebration_style.dart';

/// Internal default celebration action, independent of flame animation ticks.
class StreakCelebrationAction extends StatelessWidget {
  /// Creates the host-owned action.
  const StreakCelebrationAction({
    required this.palette,
    required this.strings,
    required this.style,
    this.onContinue,
    super.key,
  });

  /// Shared color fallbacks.
  final StreakPalette palette;

  /// Localized action label.
  final StreakStrings strings;

  /// Effective optional action overrides.
  final StreakCelebrationStyle style;

  /// Null disables the inline action.
  final VoidCallback? onContinue;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onContinue,
    style: (style.buttonStyle ?? const ButtonStyle()).merge(
      FilledButton.styleFrom(
        backgroundColor: style.buttonBackgroundColor ?? palette.accent,
        foregroundColor: style.buttonForegroundColor ?? palette.surface,
        disabledBackgroundColor: style.buttonDisabledBackgroundColor,
        disabledForegroundColor: style.buttonDisabledForegroundColor,
        overlayColor: style.buttonOverlayColor,
        textStyle: style.buttonTextStyle,
        side: BorderSide(
          color: style.buttonBorderColor ?? Colors.transparent,
          width: style.buttonBorderWidth,
          style: style.buttonBorderWidth == 0
              ? BorderStyle.none
              : BorderStyle.solid,
        ),
        shape: style.buttonShape,
        minimumSize: style.buttonMinimumSize,
        padding: style.buttonPadding,
      ),
    ),
    child: Text(strings.button, textAlign: style.textAlign),
  );
}
