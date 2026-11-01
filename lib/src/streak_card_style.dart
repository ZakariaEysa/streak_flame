import 'package:flutter/material.dart';

/// Optional overrides for the celebration card group.
/// Null fields retain the corresponding flat StreakCelebrationStyle settings.
@immutable
class StreakCardStyle {
  /// Creates partial overrides; only supplied values replace existing settings.
  const StreakCardStyle({
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.shape,
    this.shadows,
    this.padding,
    this.margin,
    this.dialogInsetPadding,
  });

  /// Card fill; defaults to palette.surface.
  final Color? backgroundColor;

  /// Card gradient overrides backgroundColor.
  final Gradient? backgroundGradient;

  /// Default card outline; defaults to accent at 35% opacity.
  final Color? borderColor;

  /// Default card outline width; zero removes it.
  final double? borderWidth;

  /// Default card corners.
  final BorderRadiusGeometry? borderRadius;

  /// Card shape and border; overrides borderRadius/borderColor/borderWidth.
  final ShapeBorder? shape;

  /// Card shadows. Keep this list immutable.
  final List<BoxShadow>? shadows;

  /// Card content padding.
  final EdgeInsetsGeometry? padding;

  /// Space outside the card.
  final EdgeInsetsGeometry? margin;

  /// Popup distance from viewport edges.
  final EdgeInsets? dialogInsetPadding;
}
