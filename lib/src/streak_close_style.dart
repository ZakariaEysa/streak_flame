import 'package:flutter/material.dart';

/// Optional overrides for the celebration closeButton group.
/// Null fields retain the corresponding flat StreakCelebrationStyle settings.
@immutable
class StreakCloseStyle {
  /// Creates partial overrides; only supplied values replace existing settings.
  const StreakCloseStyle({
    this.show,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.shape,
    this.buttonStyle,
    this.iconSize,
  });

  /// Show close when onClose is supplied.
  final bool? show;

  /// Close icon; defaults to foreground.
  final Color? foregroundColor;

  /// Close control background.
  final Color? backgroundColor;

  /// Close control outline.
  final Color? borderColor;

  /// Close control outline width.
  final double? borderWidth;

  /// Close control shape.
  final OutlinedBorder? shape;

  /// Advanced close control states; overrides non-null close style properties.
  final ButtonStyle? buttonStyle;

  /// Close icon size; touch target stays at least 48.
  final double? iconSize;
}
