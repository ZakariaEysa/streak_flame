import 'package:flutter/material.dart';

/// Optional overrides for the celebration action group.
/// Null fields retain the corresponding flat StreakCelebrationStyle settings.
@immutable
class StreakActionStyle {
  /// Creates partial overrides; only supplied values replace existing settings.
  const StreakActionStyle({
    this.show,
    this.spacing,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.overlayColor,
    this.borderColor,
    this.borderWidth,
    this.shape,
    this.textStyle,
    this.padding,
    this.minimumSize,
    this.buttonStyle,
  });

  /// Show supplied footer or default action.
  final bool? show;

  /// Gap before the action/footer.
  final double? spacing;

  /// Action fill; defaults to accent.
  final Color? backgroundColor;

  /// Action text; defaults to surface.
  final Color? foregroundColor;

  /// Disabled action fill; otherwise Flutter theme.
  final Color? disabledBackgroundColor;

  /// Disabled action text; otherwise Flutter theme.
  final Color? disabledForegroundColor;

  /// Action hover/focus/pressed overlay.
  final Color? overlayColor;

  /// Action outline; defaults to transparent.
  final Color? borderColor;

  /// Action outline width.
  final double? borderWidth;

  /// Action shape; its side is controlled by buttonBorderColor/Width.
  final OutlinedBorder? shape;

  /// Action typography.
  final TextStyle? textStyle;

  /// Action insets.
  final EdgeInsetsGeometry? padding;

  /// Preferred minimum action size.
  final Size? minimumSize;

  /// Advanced state styling. Non-null properties override other button options.
  final ButtonStyle? buttonStyle;
}
