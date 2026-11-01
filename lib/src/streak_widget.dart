import 'package:flutter/material.dart';
import 'big_streak_flame_widget.dart';
import 'streak_animation_controller.dart';
import 'streak_badge_style.dart';
import 'streak_flame_style.dart';
import 'streak_celebration_style.dart';
import 'streak_palette.dart';
import 'streak_strings.dart';
import 'streak_display.dart';
import 'streak_celebration_content.dart';
import 'streak_celebration_frame.dart';
import 'streak_celebration_dialog_frame.dart';
import 'streak_celebration_route.dart';
import 'streak_validation.dart';

/// Shared flame presentation with optional inline celebration framing.
/// Use [showCelebration] to present the same content as a modal popup.
class StreakWidget extends StatefulWidget {
  /// Only the two counts are required; appearance and behavior are optional.
  const StreakWidget({
    required this.oldStreak,
    required this.newStreak,
    this.display = StreakDisplay.flame,
    this.palette = const StreakPalette(),
    this.flameStyle = const StreakFlameStyle(),
    this.badgeStyle = const StreakBadgeStyle(),
    this.celebrationStyle = const StreakCelebrationStyle(),
    this.strings = const StreakStrings(),
    this.isStreakReset,
    this.size = 220,
    this.maxWidth = 400,
    this.autoStart = true,
    this.transitionDelay = const Duration(milliseconds: 700),
    this.transitionDuration = const Duration(milliseconds: 1400),
    this.idleDuration = const Duration(milliseconds: 2200),
    this.controller,
    this.numberFormatter,
    this.unitLabelBuilder,
    this.semanticsLabel,
    this.numberStyle,
    this.unitStyle,
    this.animationsEnabled = true,
    this.idleAnimationEnabled = true,
    this.respectReducedMotion = true,
    this.enableHaptics = false,
    this.showGlow = true,
    this.showParticles = true,
    this.particleCount = 28,
    this.header,
    this.footer,
    this.onContinue,
    this.onClose,
    this.onTransitionComplete,
    super.key,
  });

  /// Starting count. Must be nonnegative.
  final int oldStreak;

  /// Target count. Must be nonnegative.
  final int newStreak;

  /// Flame alone or the complete inline celebration.
  final StreakDisplay display;

  /// Flame/badge colors and shared fallbacks; frame overrides are in celebrationStyle.
  final StreakPalette palette;

  /// Flame outline, halo radius, and particle size.
  final StreakFlameStyle flameStyle;

  /// Badge shape, border width, size, position, padding, and shadows.
  final StreakBadgeStyle badgeStyle;

  /// Optional outer frame, header, text, and action styling.
  final StreakCelebrationStyle celebrationStyle;

  /// Unit labels and increase/restart messages.
  final StreakStrings strings;

  /// Null detects restart wording when the target count decreases.
  final bool? isStreakReset;

  /// Preferred flame width; badge/effect dimensions scale with it.
  final double size;

  /// Maximum width of the complete celebration.
  final double maxWidth;

  /// Start automatically on mount and count changes.
  final bool autoStart;

  /// Delay before automatic transitions.
  final Duration transitionDelay;

  /// Duration of the count transition.
  final Duration transitionDuration;

  /// Duration of one idle flicker cycle.
  final Duration idleDuration;

  /// Externally owned replay/pause controller; dispose it in its owner.
  final StreakAnimationController? controller;

  /// Optional localized number formatting.
  final StreakNumberFormatter? numberFormatter;

  /// Optional unit/plural formatter.
  final String Function(int count)? unitLabelBuilder;

  /// Stable screen-reader label for the target count.
  final String? semanticsLabel;

  /// Count typography; explicit color overrides the palette.
  final TextStyle? numberStyle;

  /// Unit typography; explicit color overrides the palette.
  final TextStyle? unitStyle;

  /// False immediately displays the completed state.
  final bool animationsEnabled;

  /// Enable continuous flame flickering.
  final bool idleAnimationEnabled;

  /// Honor the host reduced-motion preference.
  final bool respectReducedMotion;

  /// Opt-in platform feedback.
  final bool enableHaptics;

  /// Show the flame halo; badge shadows are configured separately.
  final bool showGlow;

  /// Show burst particles.
  final bool showParticles;

  /// Particle budget, from zero to 64.
  final int particleCount;

  /// Optional replacement header; showHeader controls its visibility.
  final Widget? header;

  /// Optional replacement footer, taking precedence over the default action.
  final Widget? footer;

  /// Inline action callback. The default button is disabled when omitted.
  final VoidCallback? onContinue;

  /// Inline close callback. The close control is omitted when absent.
  final VoidCallback? onClose;

  /// Called once per completed count transition.
  final VoidCallback? onTransitionComplete;

  /// Opens the full celebration as a popup; onContinue runs after requesting close.
  /// onDismiss runs after any dismissal, including barrier taps and system back.
  static Future<void> showCelebration(
    BuildContext context, {
    required int oldStreak,
    required int newStreak,
    StreakPalette palette = const StreakPalette(),
    StreakFlameStyle flameStyle = const StreakFlameStyle(),
    StreakBadgeStyle badgeStyle = const StreakBadgeStyle(),
    StreakCelebrationStyle celebrationStyle = const StreakCelebrationStyle(),
    StreakStrings strings = const StreakStrings(),
    bool? isStreakReset,
    double size = 220,
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
      builder: (routeContext) => StreakCelebrationDialogFrame(
        maxWidth: maxWidth,
        insetPadding: celebrationStyle.dialogInsetPadding,
        child: StreakWidget(
          display: StreakDisplay.celebration,
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
      ),
    );
  }

  /// Extension point used by the compatibility dialog to supply modal layout.
  @protected
  Widget wrapPresentation(BuildContext context, Widget child) => child;

  /// Resolves the inline continue action; compatibility dialogs may default to pop.
  @protected
  VoidCallback? resolveContinue(BuildContext context) => onContinue;

  /// Resolves the inline close action; compatibility dialogs may default to pop.
  @protected
  VoidCallback? resolveClose(BuildContext context) => onClose;

  @override
  State<StreakWidget> createState() => _StreakWidgetState();
}

class _StreakWidgetState extends State<StreakWidget> {
  bool _transitioned = false;
  int _replayRevision = 0;
  void _attachController() {
    _replayRevision = widget.controller?.replayRevision ?? 0;
    widget.controller?.addListener(_onController);
  }

  void _onController() {
    final revision = widget.controller?.replayRevision ?? 0;
    if (revision != _replayRevision) {
      _replayRevision = revision;
      if (_transitioned) setState(() => _transitioned = false);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onController);
    super.dispose();
  }

  void _validate() {
    validateStreakConfiguration(
      oldStreak: widget.oldStreak,
      newStreak: widget.newStreak,
      size: widget.size,
      transitionDelay: widget.transitionDelay,
      transitionDuration: widget.transitionDuration,
      idleDuration: widget.idleDuration,
      particleCount: widget.particleCount,
      flameStyle: widget.flameStyle,
      badgeStyle: widget.badgeStyle,
      celebrationStyle: widget.celebrationStyle,
      maxWidth: widget.maxWidth,
    );
  }

  @override
  void initState() {
    super.initState();
    _validate();
    _attachController();
  }

  @override
  void didUpdateWidget(covariant StreakWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validate();
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onController);
      _attachController();
    }
    if (oldWidget.oldStreak != widget.oldStreak ||
        oldWidget.newStreak != widget.newStreak ||
        oldWidget.autoStart != widget.autoStart ||
        oldWidget.display != widget.display)
      _transitioned = false;
  }

  @override
  Widget build(BuildContext context) {
    final flame = BigStreakFlameWidget(
      key: const ValueKey('streak-flame'),
      oldStreak: widget.oldStreak,
      newStreak: widget.newStreak,
      size: widget.size,
      autoStart: widget.autoStart,
      transitionDelay: widget.transitionDelay,
      transitionDuration: widget.transitionDuration,
      idleDuration: widget.idleDuration,
      controller: widget.controller,
      palette: widget.palette,
      flameStyle: widget.flameStyle,
      badgeStyle: widget.badgeStyle,
      strings: widget.strings,
      numberFormatter: widget.numberFormatter,
      unitLabelBuilder: widget.unitLabelBuilder,
      semanticsLabel: widget.semanticsLabel,
      numberStyle: widget.numberStyle,
      unitStyle: widget.unitStyle,
      animationsEnabled: widget.animationsEnabled,
      idleAnimationEnabled: widget.idleAnimationEnabled,
      respectReducedMotion: widget.respectReducedMotion,
      enableHaptics: widget.enableHaptics,
      showGlow: widget.showGlow,
      showParticles: widget.showParticles,
      particleCount: widget.particleCount,
      onTransitionComplete: () {
        if (!mounted) return;
        if (!_transitioned && widget.display == StreakDisplay.celebration)
          setState(() => _transitioned = true);
        widget.onTransitionComplete?.call();
      },
    );
    if (widget.display == StreakDisplay.flame)
      return widget.wrapPresentation(context, flame);
    final style = widget.celebrationStyle;
    final reduced =
        !widget.animationsEnabled ||
        (widget.respectReducedMotion &&
            MediaQuery.disableAnimationsOf(context));
    final complete =
        reduced || _transitioned || widget.oldStreak == widget.newStreak;
    final reset = widget.isStreakReset ?? widget.newStreak < widget.oldStreak;
    final title = reset
        ? (complete
              ? widget.strings.resetUpdatedTitle
              : widget.strings.resetTitle)
        : (complete ? widget.strings.updatedTitle : widget.strings.title);
    final subtitle = reset
        ? widget.strings.resetSubtitle
        : widget.strings.subtitle;
    return widget.wrapPresentation(
      context,
      StreakCelebrationFrame(
        palette: widget.palette,
        style: style,
        maxWidth: widget.maxWidth,
        child: StreakCelebrationContent(
          flame: flame,
          palette: widget.palette,
          strings: widget.strings,
          style: style,
          title: title,
          subtitle: subtitle,
          reducedMotion: reduced,
          header: widget.header,
          footer: widget.footer,
          onClose: widget.resolveClose(context),
          onContinue: widget.resolveContinue(context),
        ),
      ),
    );
  }
}
