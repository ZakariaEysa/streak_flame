import 'package:flutter/material.dart';
import 'package:streak_flame/streak_flame.dart';

import 'playground_actions.dart';
import 'playground_counts.dart';
import 'playground_messages.dart';
import 'playground_layout.dart';
import 'playground_settings.dart';

/// Independent flame playground with live settings and test scenarios.
class StreakDemoPage extends StatefulWidget {
  /// Creates the playground.
  const StreakDemoPage({super.key});

  @override
  State<StreakDemoPage> createState() => _StreakDemoPageState();
}

class _StreakDemoPageState extends State<StreakDemoPage> {
  final _controller = StreakAnimationController();
  final _formKey = GlobalKey<FormState>();
  final _oldEditor = TextEditingController(text: '6');
  final _newEditor = TextEditingController(text: '7');
  final _positive = TextEditingController();
  final _restart = TextEditingController();
  var _count = 7;
  var _previousCount = 6;
  var _isReset = false;
  var _arabic = false;
  var _blue = false;
  var _lightBadge = false;
  var _full = false;
  var _roundedBadge = false;
  var _customFrame = false;
  var _motion = true;
  var _idle = true;
  var _glow = true;
  var _burst = true;
  var _reduced = false;
  var _size = 220.0;
  var _duration = 1400.0;
  var _delay = 700.0;
  var _idleDuration = 2200.0;
  var _textScale = 1.0;
  var _particles = 28.0;

  StreakStrings get _strings {
    final positive = _positive.text.trim();
    final restart = _restart.text.trim();
    return _arabic
        ? StreakStrings(
            day: 'يوم',
            days: 'أيام',
            badge: 'الاستريك اليومي',
            title: 'خلي الشعلة منورة!',
            updatedTitle: positive.isEmpty ? 'الاستريك زاد!' : positive,
            subtitle: 'كل يوم بيفرق. كمل!',
            resetTitle: 'نبدأ من جديد',
            resetUpdatedTitle: restart.isEmpty
                ? 'استريك جديد، بداية جديدة!'
                : restart,
            resetSubtitle: 'مجهودك اللي فات لسه له قيمة. كمل يوم بيوم.',
            button: 'كمل',
            dismissLabel: 'إغلاق الاحتفال',
          )
        : StreakStrings(
            updatedTitle: positive.isEmpty ? 'Streak updated!' : positive,
            resetUpdatedTitle: restart.isEmpty
                ? 'New streak, new start!'
                : restart,
          );
  }

  StreakPalette get _palette {
    final flame = _blue
        ? const StreakPalette(
            flameBase: Color(0xFF2563EB),
            flameMiddle: Color(0xFF0891B2),
            flameTip: Color(0xFF67E8F9),
            flameCore: Color(0xFFECFEFF),
            accent: Color(0xFF22D3EE),
          )
        : const StreakPalette();
    return _lightBadge
        ? flame.copyWith(
            badgeBackground: Colors.white,
            badgeHighlight: const Color(0xFFFDF2F8),
            badgeBorder: const Color(0xFFDB2777),
            badgeGlow: const Color(0x66DB2777),
            badgeOldNumber: const Color(0xFF475569),
            badgeNumber: const Color(0xFFBE185D),
            badgeLabel: const Color(0xFF475569),
          )
        : flame;
  }

  StreakBadgeStyle get _badgeStyle => _roundedBadge
      ? const StreakBadgeStyle(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            side: BorderSide(color: Colors.pink, width: 4),
          ),
        )
      : const StreakBadgeStyle();

  StreakFlameStyle get _flameStyle => _customFrame
      ? const StreakFlameStyle(borderColor: Colors.cyanAccent, borderWidth: 2)
      : const StreakFlameStyle();

  StreakCelebrationStyle get _celebrationStyle => _customFrame
      ? const StreakCelebrationStyle(
          backgroundColor: Color(0xFFFFF7ED),
          borderColor: Colors.pink,
          borderWidth: 2,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          titleColor: Color(0xFF831843),
          subtitleColor: Color(0xFF475569),
          headerBackgroundColor: Color(0xFFFCE7F3),
          headerForegroundColor: Color(0xFF9D174D),
          headerBorderColor: Colors.pink,
          headerBorderWidth: 1,
          closeColor: Color(0xFF9D174D),
          closeBackgroundColor: Color(0xFFFCE7F3),
          buttonBackgroundColor: Color(0xFFBE185D),
          buttonForegroundColor: Colors.white,
          buttonBorderColor: Color(0xFF831843),
          buttonBorderWidth: 2,
          buttonShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        )
      : const StreakCelebrationStyle();

  void _toggle(PlaygroundToggle setting, bool value) {
    setState(() {
      switch (setting) {
        case PlaygroundToggle.full:
          _full = value;
        case PlaygroundToggle.roundedBadge:
          _roundedBadge = value;
        case PlaygroundToggle.customFrame:
          _customFrame = value;
        case PlaygroundToggle.arabic:
          _arabic = value;
        case PlaygroundToggle.blue:
          _blue = value;
        case PlaygroundToggle.lightBadge:
          _lightBadge = value;
        case PlaygroundToggle.motion:
          _motion = value;
        case PlaygroundToggle.idle:
          _idle = value;
        case PlaygroundToggle.glow:
          _glow = value;
        case PlaygroundToggle.burst:
          _burst = value;
        case PlaygroundToggle.reduced:
          _reduced = value;
      }
    });
  }

  void _range(PlaygroundRange setting, double value) {
    setState(() {
      switch (setting) {
        case PlaygroundRange.size:
          _size = value;
        case PlaygroundRange.duration:
          _duration = value;
        case PlaygroundRange.delay:
          _delay = value;
        case PlaygroundRange.idleDuration:
          _idleDuration = value;
        case PlaygroundRange.particles:
          _particles = value;
        case PlaygroundRange.textScale:
          _textScale = value;
      }
    });
  }

  void _applyCounts() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _previousCount = int.parse(_oldEditor.text.trim());
      _count = int.parse(_newEditor.text.trim());
      _isReset = _count < _previousCount;
    });
  }

  void _nextDay() {
    final next = _count + 1;
    if (next <= _count) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This count cannot be increased on this platform.'),
        ),
      );
      return;
    }
    _changeCount(next, reset: false);
  }

  void _changeCount(int count, {required bool reset}) {
    setState(() {
      _previousCount = _count;
      _count = count;
      _isReset = reset;
      _oldEditor.text = '$_previousCount';
      _newEditor.text = '$_count';
    });
    _formKey.currentState?.validate();
  }

  void _celebrate(BuildContext buttonContext) {
    StreakWidget.showCelebration(
      buttonContext,
      oldStreak: _previousCount,
      newStreak: _count,
      isStreakReset: _isReset,
      strings: _strings,
      palette: _palette,
      flameStyle: _flameStyle,
      badgeStyle: _badgeStyle,
      celebrationStyle: _celebrationStyle,
      size: _size,
      transitionDelay: Duration(milliseconds: _delay.round()),
      transitionDuration: Duration(milliseconds: _duration.round()),
      idleDuration: Duration(milliseconds: _idleDuration.round()),
      animationsEnabled: _motion,
      idleAnimationEnabled: _idle,
      showGlow: _glow,
      showParticles: _burst,
      particleCount: _particles.round(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _oldEditor.dispose();
    _newEditor.dispose();
    _positive.dispose();
    _restart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: _arabic ? TextDirection.rtl : TextDirection.ltr,
    child: MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(_textScale),
        disableAnimations: _reduced || MediaQuery.disableAnimationsOf(context),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Streak playground')),
        body: SafeArea(
          child: PlaygroundLayout(
            flame: StreakWidget(
              display: _full ? StreakDisplay.celebration : StreakDisplay.flame,
              isStreakReset: _isReset,
              onClose: () => setState(() => _full = false),
              onContinue: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Inline Continue tapped')),
              ),
              oldStreak: _previousCount,
              newStreak: _count,
              controller: _controller,
              strings: _strings,
              palette: _palette,
              flameStyle: _flameStyle,
              badgeStyle: _badgeStyle,
              celebrationStyle: _celebrationStyle,
              size: _size,
              transitionDelay: Duration(milliseconds: _delay.round()),
              transitionDuration: Duration(milliseconds: _duration.round()),
              idleDuration: Duration(milliseconds: _idleDuration.round()),
              animationsEnabled: _motion,
              idleAnimationEnabled: _idle,
              showGlow: _glow,
              showParticles: _burst,
              particleCount: _particles.round(),
            ),
            actions: PlaygroundActions(
              onReplay: _controller.replay,
              onPause: _controller.pause,
              onResume: _controller.resume,
              onNextDay: _nextDay,
              onRestart: () => _changeCount(1, reset: true),
              onClear: () => _changeCount(0, reset: true),
              onCelebrate: _celebrate,
            ),
            counts: PlaygroundCounts(
              formKey: _formKey,
              oldCount: _oldEditor,
              newCount: _newEditor,
              onApply: _applyCounts,
            ),
            settings: PlaygroundSettings(
              values: (
                full: _full,
                roundedBadge: _roundedBadge,
                customFrame: _customFrame,
                arabic: _arabic,
                blue: _blue,
                lightBadge: _lightBadge,
                motion: _motion,
                idle: _idle,
                glow: _glow,
                burst: _burst,
                reduced: _reduced,
                size: _size,
                duration: _duration,
                delay: _delay,
                idleDuration: _idleDuration,
                particles: _particles,
                textScale: _textScale,
              ),
              onToggle: _toggle,
              onRange: _range,
            ),
            messages: PlaygroundMessages(
              positive: _positive,
              restart: _restart,
            ),
          ),
        ),
      ),
    ),
  );
}
