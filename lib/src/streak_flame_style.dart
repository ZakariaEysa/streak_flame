import 'package:flutter/material.dart';

/// Optional flame outline and effect geometry. Colors live in StreakPalette.
@immutable
class StreakFlameStyle {
  /// Dimensions use the design canvas at flame size 220 and scale with size.
  const StreakFlameStyle({
    this.borderColor,
    this.borderWidth = 0,
    this.strokeJoin = StrokeJoin.round,
    this.glowRadius = 98,
    this.particleSize = 1,
  });

  /// Outer flame outline; falls back to palette.flameBase.
  final Color? borderColor;

  /// Zero hides the outline.
  final double borderWidth;

  /// Join used by the outer outline.
  final StrokeJoin strokeJoin;

  /// Ambient halo radius. Zero hides it.
  final double glowRadius;

  /// Particle radius multiplier. Zero hides the particles.
  final double particleSize;

  /// Rejects nonfinite or negative dimensions before painting.
  void validate() {
    for (final entry in {
      'borderWidth': borderWidth,
      'glowRadius': glowRadius,
      'particleSize': particleSize,
    }.entries) {
      if (!entry.value.isFinite || entry.value < 0) {
        throw ArgumentError.value(
          entry.value,
          entry.key,
          'Must be finite and nonnegative',
        );
      }
    }
  }
}
