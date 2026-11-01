import 'package:flutter/material.dart';

/// Optional overrides for the celebration text group.
/// Null fields retain the corresponding flat StreakCelebrationStyle settings.
@immutable
class StreakTextStyle {
  /// Creates partial overrides; only supplied values replace existing settings.
  const StreakTextStyle({
    this.titleColor,
    this.subtitleColor,
    this.titleStyle,
    this.subtitleStyle,
    this.align,
    this.spacing,
  });

  /// Title color; defaults to foreground.
  final Color? titleColor;

  /// Subtitle color; defaults to secondaryForeground.
  final Color? subtitleColor;

  /// Title typography; explicit color wins.
  final TextStyle? titleStyle;

  /// Subtitle typography; explicit color wins.
  final TextStyle? subtitleStyle;

  /// Title, subtitle and button text alignment.
  final TextAlign? align;

  /// Gap between title and subtitle.
  final double? spacing;
}
