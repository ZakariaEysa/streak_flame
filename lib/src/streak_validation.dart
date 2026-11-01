import 'streak_badge_style.dart';
import 'streak_flame_style.dart';
import 'streak_celebration_style.dart';

/// Validates configuration in release mode as well as debug mode.
void validateStreakConfiguration({
  required int oldStreak,
  required int newStreak,
  required double size,
  required Duration transitionDelay,
  required Duration transitionDuration,
  required int particleCount,
  Duration idleDuration = const Duration(milliseconds: 2200),
  StreakFlameStyle? flameStyle,
  StreakBadgeStyle? badgeStyle,
  StreakCelebrationStyle? celebrationStyle,
  double? maxWidth,
}) {
  if (oldStreak < 0 || newStreak < 0) {
    throw ArgumentError('Streak counts must be nonnegative');
  }
  if (!size.isFinite || size <= 0) {
    throw ArgumentError.value(size, 'size', 'Must be finite and positive');
  }
  if (transitionDelay.isNegative) {
    throw ArgumentError.value(
      transitionDelay,
      'transitionDelay',
      'Must be nonnegative',
    );
  }
  if (transitionDuration <= Duration.zero || idleDuration <= Duration.zero) {
    throw ArgumentError('Animation durations must be positive');
  }
  if (particleCount < 0 || particleCount > 64) {
    throw ArgumentError.value(
      particleCount,
      'particleCount',
      'Must be between 0 and 64',
    );
  }
  flameStyle?.validate();
  badgeStyle?.validate();
  celebrationStyle?.validate();
  if (maxWidth != null && (!maxWidth.isFinite || maxWidth <= 0)) {
    throw ArgumentError.value(
      maxWidth,
      'maxWidth',
      'Must be finite and positive',
    );
  }
}
