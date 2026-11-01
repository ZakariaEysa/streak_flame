import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'streak_animation_controller.dart';
import 'streak_badge.dart';
import 'streak_badge_style.dart';
import 'streak_flame_style.dart';
import 'streak_flame_painter.dart';
import 'streak_palette.dart';
import 'streak_strings.dart';
import 'streak_validation.dart';

/// A responsive animated streak flame, with no storage or application imports.
///
/// [size] is the preferred flame width; the complete canvas includes room for
/// glow and particles. Bounded parent constraints shrink the entire composition.
/// Changing either count restarts the transition when [autoStart] is true.
/// With [autoStart] false, the old count stays visible until [controller] replays.
/// Reduced motion displays the final count immediately. Hidden or paused flames
/// retain progress and resume when enabled. No callback fires after disposal.
class BigStreakFlameWidget extends StatefulWidget {
  /// Creates a customizable streak flame.
  const BigStreakFlameWidget({
    required this.oldStreak,
    required this.newStreak,
    this.size = 220,
    this.autoStart = true,
    this.transitionDelay = const Duration(milliseconds: 700),
    this.transitionDuration = const Duration(milliseconds: 1400),
    this.idleDuration = const Duration(milliseconds: 2200),
    this.controller,
    this.palette = const StreakPalette(),
    this.flameStyle = const StreakFlameStyle(),
    this.badgeStyle = const StreakBadgeStyle(),
    this.strings = const StreakStrings(),
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
    this.onTransitionComplete,
    super.key,
  }) : assert(oldStreak >= 0 && newStreak >= 0),
       assert(size > 0 && size < double.infinity),
       assert(particleCount >= 0 && particleCount <= 64);

  /// Initial count. Must be nonnegative.
  final int oldStreak;

  /// Target count. Must be nonnegative.
  final int newStreak;

  /// Preferred flame width before fitting to parent constraints.
  final double size;

  /// Automatically transition on mount and count changes.
  final bool autoStart;

  /// Delay before an automatic transition. Replays skip this delay.
  final Duration transitionDelay;

  /// Duration of the count celebration.
  final Duration transitionDuration;

  /// Duration of one idle flame cycle.
  final Duration idleDuration;

  /// Optional externally owned replay/pause controller.
  final StreakAnimationController? controller;

  /// Flame, badge, and text colors.
  final StreakPalette palette;

  /// Optional flame outline and effect geometry.
  final StreakFlameStyle flameStyle;

  /// Optional badge geometry, shape and shadows.
  final StreakBadgeStyle badgeStyle;

  /// Localizable unit labels.
  final StreakStrings strings;

  /// Optional localized number formatting.
  final StreakNumberFormatter? numberFormatter;

  /// Optional unit/plural formatter for arbitrary language rules.
  final String Function(int count)? unitLabelBuilder;

  /// Override for the stable screen-reader description of the target count.
  final String? semanticsLabel;

  /// Optional count typography.
  final TextStyle? numberStyle;

  /// Optional unit typography.
  final TextStyle? unitStyle;

  /// False displays the target count without motion.
  final bool animationsEnabled;

  /// Whether to continuously flicker between celebrations.
  final bool idleAnimationEnabled;

  /// Honor MediaQuery.disableAnimations (on by default).
  final bool respectReducedMotion;

  /// Opt-in platform haptic feedback at the count transition.
  final bool enableHaptics;

  /// Paint the ambient halo.
  final bool showGlow;

  /// Paint the celebration burst.
  final bool showParticles;

  /// Particle count, from zero to 64.
  final int particleCount;

  /// Called once per completed transition, including reduced-motion completion.
  final VoidCallback? onTransitionComplete;

  @override
  State<BigStreakFlameWidget> createState() => _BigStreakFlameWidgetState();
}

class _BigStreakFlameWidgetState extends State<BigStreakFlameWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _idle;
  late final AnimationController _transition;
  late final Listenable _repaint;
  Timer? _delay;
  bool _pending = false;
  bool _started = false;
  bool _armed = false;
  bool _hapticSent = false;
  bool _visible = true;
  bool _reduced = false;
  bool _foreground = true;
  bool _immediate = false;
  int _generation = 0;
  int _controllerRevision = 0;

  bool get _motionDisabled => !widget.animationsEnabled || _reduced;
  bool get _canTick =>
      _visible && _foreground && !(widget.controller?.isPaused ?? false);

  @override
  void initState() {
    super.initState();
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
    );
    _idle = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: widget.idleDuration,
    );
    _transition =
        AnimationController(
            vsync: this,
            duration: widget.transitionDuration,
            animationBehavior: AnimationBehavior.preserve,
          )
          ..addStatusListener(_onStatus)
          ..addListener(_onTick);
    _repaint = Listenable.merge([_idle, _transition]);
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    _attachController();
    _reset();
  }

  void _attachController() {
    _controllerRevision = widget.controller?.replayRevision ?? 0;
    widget.controller?.addListener(_onCommand);
  }

  void _reset({bool replay = false}) {
    _generation++;
    _delay?.cancel();
    _delay = null;
    _armed = false;
    _hapticSent = false;
    _started = false;
    _immediate = replay;
    _pending =
        replay || (widget.autoStart && widget.oldStreak != widget.newStreak);
    _transition.stop();
    _transition.value = widget.oldStreak == widget.newStreak && !replay ? 1 : 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Supported older Flutter SDKs do not expose TickerMode.valuesOf.
    // ignore: deprecated_member_use
    _visible = TickerMode.of(context);
    _reduced =
        widget.respectReducedMotion && MediaQuery.disableAnimationsOf(context);
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant BigStreakFlameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    );
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onCommand);
      _attachController();
    }
    _idle.duration = widget.idleDuration;
    _transition.duration = widget.transitionDuration;
    _reduced =
        widget.respectReducedMotion && MediaQuery.disableAnimationsOf(context);
    if (oldWidget.oldStreak != widget.oldStreak ||
        oldWidget.newStreak != widget.newStreak ||
        oldWidget.autoStart != widget.autoStart) {
      _reset();
    } else if (oldWidget.transitionDelay != widget.transitionDelay &&
        !_started) {
      _delay?.cancel();
      _delay = null;
    }
    _syncMotion();
  }

  void _onCommand() {
    if (_controllerRevision != widget.controller?.replayRevision) {
      _controllerRevision = widget.controller?.replayRevision ?? 0;
      _reset(replay: true);
    }
    _syncMotion();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _syncMotion();
  }

  void _syncMotion() {
    if (_motionDisabled) {
      _idle.stop();
      _idle.value = 0;
      _delay?.cancel();
      _delay = null;
      _transition.stop();
      if (_pending || _started) _armed = true;
      _pending = false;
      _started = false;
      _transition.value = 1;
      return;
    }
    if (!_canTick) {
      _delay?.cancel();
      _delay = null;
      _idle.stop();
      _transition.stop();
      return;
    }
    if (widget.idleAnimationEnabled) {
      if (!_idle.isAnimating) _idle.repeat();
    } else {
      _idle.stop();
    }
    if (_pending) {
      if (_delay != null) return;
      final generation = _generation;
      void start() {
        _delay = null;
        if (!mounted || generation != _generation || !_canTick) return;
        _pending = false;
        _started = true;
        _armed = true;
        _transition.forward();
      }

      final delay = _immediate ? Duration.zero : widget.transitionDelay;
      if (delay == Duration.zero) {
        start();
      } else {
        _delay = Timer(delay, start);
      }
    } else if (_started && !_transition.isAnimating && _transition.value < 1) {
      _transition.forward();
    }
  }

  void _onTick() {
    if (!widget.enableHaptics ||
        _motionDisabled ||
        _hapticSent ||
        !_armed ||
        _transition.value < 0.45)
      return;
    _hapticSent = true;
    // Optional feedback must not interrupt the visual on unsupported platforms.
    unawaited(HapticFeedback.mediumImpact().catchError((Object _) {}));
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !_armed) return;
    _armed = false;
    _started = false;
    final generation = _generation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && generation == _generation) {
        widget.onTransitionComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _generation++;
    _delay?.cancel();
    widget.controller?.removeListener(_onCommand);
    WidgetsBinding.instance.removeObserver(this);
    _transition.removeStatusListener(_onStatus);
    _transition.removeListener(_onTick);
    _transition.dispose();
    _idle.dispose();
    super.dispose();
  }

  String _number(int count) => widget.numberFormatter?.call(count) ?? '$count';
  String _unit(int count) =>
      widget.unitLabelBuilder?.call(count) ?? widget.strings.unitFor(count);

  @override
  Widget build(BuildContext context) {
    final targetDescription =
        widget.semanticsLabel ??
        '${_number(widget.newStreak)} ${_unit(widget.newStreak)}';
    return Semantics(
      label: targetDescription,
      image: true,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final preferredScale = widget.size / 220;
            final widthScale = constraints.hasBoundedWidth
                ? constraints.maxWidth / 352
                : preferredScale;
            final heightScale = constraints.hasBoundedHeight
                ? constraints.maxHeight / 396
                : preferredScale;
            final scale = math.min(
              preferredScale,
              math.min(widthScale, heightScale),
            );
            return SizedBox(
              width: 352 * scale,
              height: 396 * scale,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 352,
                  height: 396,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: StreakFlamePainter(
                            idle: _idle,
                            transition: _transition,
                            palette: widget.palette,
                            flameStyle: widget.flameStyle,
                            badgeStyle: widget.badgeStyle,
                            textDirection: Directionality.of(context),
                            particleCount: widget.particleCount,
                            showGlow: widget.showGlow,
                            showParticles: widget.showParticles,
                            repaint: _repaint,
                          ),
                        ),
                      ),
                      Positioned(
                        left:
                            StreakFlamePainter.badgeCenter.dx +
                            widget.badgeStyle.offset.dx -
                            widget.badgeStyle.size / 2,
                        top:
                            StreakFlamePainter.badgeCenter.dy +
                            widget.badgeStyle.offset.dy -
                            widget.badgeStyle.size / 2,
                        width: widget.badgeStyle.size,
                        height: widget.badgeStyle.size,
                        child: AnimatedBuilder(
                          animation: _transition,
                          builder: (context, _) {
                            final count = _transition.value < 0.5
                                ? widget.oldStreak
                                : widget.newStreak;
                            return StreakBadge(
                              progress: _transition.value,
                              oldNumber: _number(widget.oldStreak),
                              newNumber: _number(widget.newStreak),
                              unit: _unit(count),
                              palette: widget.palette,
                              style: widget.badgeStyle,
                              numberStyle: widget.numberStyle,
                              unitStyle: widget.unitStyle,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
