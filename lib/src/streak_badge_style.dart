import 'package:flutter/material.dart';

/// Shape and layout of the count badge inside the flame.
@immutable
class StreakBadgeStyle {
  /// Defaults retain the centered circular badge. Design units scale with size.
  const StreakBadgeStyle({
    this.size = 116,
    this.offset = Offset.zero,
    this.shape,
    this.borderWidth = 3.2,
    this.borderStyle = BorderStyle.solid,
    this.padding = const EdgeInsets.all(14),
    this.shadows,
    this.glowBlurRadius = 12,
    this.glowSpreadRadius = 0,
    this.glowOffset = Offset.zero,
  });

  /// Diameter/side at flame size 220.
  final double size;

  /// Offset from the centered default badge position.
  final Offset offset;

  /// Custom shape including its border. Overrides borderWidth/borderStyle.
  final ShapeBorder? shape;

  /// Default circle border width; its color is palette.badgeBorder.
  final double borderWidth;

  /// Set none to hide the default circle border.
  final BorderStyle borderStyle;

  /// Insets around badge text, resolved using host direction.
  final EdgeInsetsGeometry padding;

  /// Overrides default glow. Use an empty list to remove it; treat as immutable.
  final List<BoxShadow>? shadows;

  /// Blur of the default badge glow, independently of the flame halo.
  final double glowBlurRadius;

  /// Spread of the default badge glow.
  final double glowSpreadRadius;

  /// Position of the default badge glow.
  final Offset glowOffset;

  /// Rejects invalid badge geometry before layout.
  void validate() {
    if (!size.isFinite || size <= 0)
      throw ArgumentError.value(size, 'size', 'Must be finite and positive');
    for (final entry in {
      'borderWidth': borderWidth,
      'glowBlurRadius': glowBlurRadius,
    }.entries) {
      if (!entry.value.isFinite || entry.value < 0)
        throw ArgumentError.value(
          entry.value,
          entry.key,
          'Must be finite and nonnegative',
        );
    }
    if (!glowSpreadRadius.isFinite ||
        !offset.dx.isFinite ||
        !offset.dy.isFinite ||
        !glowOffset.dx.isFinite ||
        !glowOffset.dy.isFinite ||
        !padding.isNonNegative) {
      throw ArgumentError(
        'Badge offsets/spread must be finite and padding nonnegative',
      );
    }
  }
}
