import 'package:flutter/material.dart';

/// Optional overrides for the celebration header group.
/// Null fields retain the corresponding flat StreakCelebrationStyle settings.
@immutable
class StreakHeaderStyle {
  /// Creates partial overrides; only supplied values replace existing settings.
  const StreakHeaderStyle({
    this.show,
    this.backgroundColor,
    this.gradient,
    this.shape,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });

  /// Show the supplied or default header.
  final bool? show;

  /// Header pill fill; defaults to accent at 15% opacity.
  final Color? backgroundColor;

  /// Header pill gradient overrides its fill.
  final Gradient? gradient;

  /// Custom header pill shape and border override radius and border options.
  final ShapeBorder? shape;

  /// Header pill text; defaults to secondaryForeground.
  final Color? foregroundColor;

  /// Header pill border; defaults to transparent.
  final Color? borderColor;

  /// Header pill outline width.
  final double? borderWidth;

  /// Header pill corners.
  final BorderRadiusGeometry? borderRadius;

  /// Header pill insets.
  final EdgeInsetsGeometry? padding;

  /// Header typography; explicit color wins.
  final TextStyle? textStyle;
}
