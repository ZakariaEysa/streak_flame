import 'package:flutter/material.dart';
import 'streak_palette.dart';
import 'streak_strings.dart';
import 'streak_celebration_style.dart';
import 'streak_dialog_header.dart';
import 'streak_celebration_action.dart';

/// Internal stateless celebration composition; does not listen to animation ticks.
class StreakCelebrationContent extends StatelessWidget {
  /// Creates the shared inline and modal content.
  const StreakCelebrationContent({
    required this.flame,
    required this.palette,
    required this.strings,
    required this.style,
    required this.title,
    required this.subtitle,
    required this.reducedMotion,
    this.header,
    this.footer,
    this.onClose,
    this.onContinue,
    super.key,
  });

  /// Shared animated flame child.
  final Widget flame;

  /// Shared color fallbacks.
  final StreakPalette palette;

  /// Localized labels.
  final StreakStrings strings;

  /// Optional celebration appearance.
  final StreakCelebrationStyle style;

  /// Current transition-dependent title.
  final String title;

  /// Increase or restart description.
  final String subtitle;

  /// Disable title transitions when motion is reduced.
  final bool reducedMotion;

  /// Optional replacement header.
  final Widget? header;

  /// Optional replacement action.
  final Widget? footer;

  /// Host-owned close action.
  final VoidCallback? onClose;

  /// Host-owned continue action.
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (style.showHeader)
        header ??
            StreakDialogHeader(
              strings: strings,
              palette: palette,
              style: style,
              onClose: onClose,
            ),
      Center(key: const ValueKey('streak-flame-slot'), child: flame),
      AnimatedSwitcher(
        duration: reducedMotion
            ? Duration.zero
            : const Duration(milliseconds: 250),
        child: Text(
          title,
          key: ValueKey(title),
          textAlign: style.textAlign,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: style.titleColor ?? palette.foreground,
          ).merge(style.titleStyle),
        ),
      ),
      SizedBox(height: style.titleSubtitleSpacing),
      Text(
        subtitle,
        textAlign: style.textAlign,
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: style.subtitleColor ?? palette.secondaryForeground,
        ).merge(style.subtitleStyle),
      ),
      if (style.showAction) ...[
        SizedBox(height: style.actionSpacing),
        footer ??
            StreakCelebrationAction(
              palette: palette,
              strings: strings,
              style: style,
              onContinue: onContinue,
            ),
      ],
    ],
  );
}
