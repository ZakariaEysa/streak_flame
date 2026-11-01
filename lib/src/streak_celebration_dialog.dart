import 'package:flutter/material.dart';
import 'streak_animation_controller.dart';
import 'streak_badge_style.dart';
import 'streak_flame_style.dart';
import 'streak_celebration_style.dart';
import 'streak_palette.dart';
import 'streak_strings.dart';
import 'streak_display.dart';
import 'streak_widget.dart';
import 'streak_celebration_dialog_frame.dart';
import 'streak_celebration_route.dart';
import 'streak_validation.dart';

/// Compatibility dialog presentation sharing StreakWidget's state and properties.
class StreakCelebrationDialog extends StreakWidget {
  /// Retains the legacy dialog size and host-dismissal defaults.
  const StreakCelebrationDialog({
    required super.oldStreak,
    required super.newStreak,
    super.palette,
    super.flameStyle,
    super.badgeStyle,
    super.celebrationStyle,
    super.strings,
    super.isStreakReset,
    super.size = 215,
    super.maxWidth,
    super.autoStart,
    super.transitionDelay,
    super.transitionDuration,
    super.idleDuration,
    super.controller,
    super.numberFormatter,
    super.unitLabelBuilder,
    super.semanticsLabel,
    super.numberStyle,
    super.unitStyle,
    super.animationsEnabled,
    super.idleAnimationEnabled,
    super.respectReducedMotion,
    super.enableHaptics,
    super.showGlow,
    super.showParticles,
    super.particleCount,
    super.header,
    super.footer,
    super.onContinue,
    super.onClose,
    super.onTransitionComplete,
    super.key,
  }) : super(display: StreakDisplay.celebration);

  /// Presents the shared celebration through the legacy entry point.
  static Future<void> show(
    BuildContext context, {
    required int oldStreak,
    required int newStreak,
    StreakPalette palette = const StreakPalette(),
    StreakFlameStyle flameStyle = const StreakFlameStyle(),
    StreakBadgeStyle badgeStyle = const StreakBadgeStyle(),
    StreakCelebrationStyle celebrationStyle = const StreakCelebrationStyle(),
    StreakStrings strings = const StreakStrings(),
    bool? isStreakReset,
    double size = 215,
    double maxWidth = 400,
    bool autoStart = true,
    Duration transitionDelay = const Duration(milliseconds: 700),
    Duration transitionDuration = const Duration(milliseconds: 1400),
    Duration idleDuration = const Duration(milliseconds: 2200),
    StreakAnimationController? controller,
    StreakNumberFormatter? numberFormatter,
    String Function(int count)? unitLabelBuilder,
    String? semanticsLabel,
    TextStyle? numberStyle,
    TextStyle? unitStyle,
    bool animationsEnabled = true,
    bool idleAnimationEnabled = true,
    bool respectReducedMotion = true,
    bool enableHaptics = false,
    bool showGlow = true,
    bool showParticles = true,
    int particleCount = 28,
    Widget? header,
    Widget? footer,
    VoidCallback? onContinue,
    VoidCallback? onTransitionComplete,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    Color barrierColor = const Color(0xA6000000),
    double blurSigma = 0,
    VoidCallback? onDismiss,
  }) {
    validateStreakConfiguration(
      oldStreak: oldStreak,
      newStreak: newStreak,
      size: size,
      transitionDelay: transitionDelay,
      transitionDuration: transitionDuration,
      idleDuration: idleDuration,
      particleCount: particleCount,
      flameStyle: flameStyle,
      badgeStyle: badgeStyle,
      celebrationStyle: celebrationStyle,
      maxWidth: maxWidth,
    );
    return showStreakCelebrationRoute(
      context,
      strings: strings,
      animationsEnabled: animationsEnabled,
      respectReducedMotion: respectReducedMotion,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor,
      blurSigma: blurSigma,
      onDismiss: onDismiss,
      builder: (routeContext) => StreakCelebrationDialog(
        oldStreak: oldStreak,
        newStreak: newStreak,
        palette: palette,
        flameStyle: flameStyle,
        badgeStyle: badgeStyle,
        celebrationStyle: celebrationStyle,
        strings: strings,
        isStreakReset: isStreakReset,
        size: size,
        maxWidth: maxWidth,
        autoStart: autoStart,
        transitionDelay: transitionDelay,
        transitionDuration: transitionDuration,
        idleDuration: idleDuration,
        controller: controller,
        numberFormatter: numberFormatter,
        unitLabelBuilder: unitLabelBuilder,
        semanticsLabel: semanticsLabel,
        numberStyle: numberStyle,
        unitStyle: unitStyle,
        animationsEnabled: animationsEnabled,
        idleAnimationEnabled: idleAnimationEnabled,
        respectReducedMotion: respectReducedMotion,
        enableHaptics: enableHaptics,
        showGlow: showGlow,
        showParticles: showParticles,
        particleCount: particleCount,
        header: header,
        footer: footer,
        onTransitionComplete: onTransitionComplete,
        onClose: () => Navigator.of(routeContext).pop(),
        onContinue: () {
          Navigator.of(routeContext).pop();
          onContinue?.call();
        },
      ),
    );
  }

  @override
  Widget wrapPresentation(BuildContext context, Widget child) =>
      StreakCelebrationDialogFrame(
        maxWidth: maxWidth,
        insetPadding: celebrationStyle.dialogInsetPadding,
        child: child,
      );

  @override
  VoidCallback? resolveClose(BuildContext context) =>
      onClose ?? () => Navigator.of(context).pop();

  @override
  VoidCallback? resolveContinue(BuildContext context) =>
      onContinue ?? () => Navigator.of(context).pop();
}
