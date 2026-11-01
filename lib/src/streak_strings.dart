import 'package:flutter/foundation.dart';

/// Formats a count, for example with localized digits.
typedef StreakNumberFormatter = String Function(int count);

/// Text supplied by the host app; no localization framework is required.
@immutable
class StreakStrings {
  /// Creates English defaults or a complete set of translated labels.
  const StreakStrings({
    this.day = 'day',
    this.days = 'days',
    this.badge = 'Daily streak',
    this.title = 'Keep the flame alive!',
    this.updatedTitle = 'Streak updated!',
    this.subtitle = 'Every day counts. Keep going!',
    this.resetTitle = "Let's start again",
    this.resetUpdatedTitle = 'New streak, new start!',
    this.resetSubtitle =
        'Your previous effort still counts. Take it one day at a time.',
    this.button = 'Continue',
    this.dismissLabel = 'Close streak celebration',
  });

  /// Singular unit.
  final String day;

  /// Plural unit. For complex plural rules use the widget's unitLabelBuilder.
  final String days;

  /// Short dialog header label.
  final String badge;

  /// Positive title before an increase or unchanged-count transition.
  final String title;

  /// Positive title after an increase or unchanged-count transition.
  final String updatedTitle;

  /// Supporting text for an increase or unchanged count.
  final String subtitle;

  /// Restart title before the count transition completes.
  final String resetTitle;

  /// Restart title after completion, including reduced-motion display.
  final String resetUpdatedTitle;

  /// Supporting text when a streak is lost or restarted.
  final String resetSubtitle;

  /// Dialog action text.
  final String button;

  /// Accessible close tooltip and modal barrier label.
  final String dismissLabel;

  /// Default singular/plural rule; override for other language rules.
  String unitFor(int count) => count == 1 ? day : days;
}
