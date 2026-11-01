import 'package:flutter/material.dart';

/// Immutable color and gradient overrides for streak presentation.
///
/// Unspecified badge/effect colors follow the shared palette for compatibility.
/// Overrides isolate the badge, flame layers, and particles from each other.
@immutable
class StreakPalette {
  /// Creates a palette. Defaults preserve the original orange flame design.
  const StreakPalette({
    this.flameBase = const Color(0xFFDC2626),
    this.flameMiddle = const Color(0xFFEA580C),
    this.flameTip = const Color(0xFFFBBF24),
    this.flameCore = const Color(0xFFFFF9C4),
    this.accent = const Color(0xFFFF9100),
    this.surface = const Color(0xFF0F172A),
    this.foreground = Colors.white,
    this.secondaryForeground = const Color(0xFFFDBA74),
    this.outerFlameGradient,
    this.middleFlameGradient,
    this.innerFlameGradient,
    this.flameGlow,
    this.flameGlowSecondary,
    this.particlePrimary,
    this.particleSecondary,
    this.badgeBackground,
    this.badgeHighlight,
    this.badgeGradient,
    this.badgeBorder,
    this.badgeGlow,
    this.badgeOldNumber,
    this.badgeNumber,
    this.badgeLabel,
  });

  /// Bottom of the outer flame.
  final Color flameBase;

  /// Middle of the outer flame and bottom of the middle layer.
  final Color flameMiddle;

  /// Top of the outer flame.
  final Color flameTip;

  /// Bright inner flame; fallback for the completed badge number.
  final Color flameCore;

  /// Shared fallback for borders, glow, particles, and dialog actions.
  final Color accent;

  /// Dialog background and fallback badge background.
  final Color surface;

  /// Main dialog text and fallback starting-count color.
  final Color foreground;

  /// Supporting dialog text and fallback badge unit color.
  final Color secondaryForeground;

  /// Full outer-layer gradient override, including its stops and direction.
  final Gradient? outerFlameGradient;

  /// Full middle-layer gradient override.
  final Gradient? middleFlameGradient;

  /// Full inner-layer gradient override.
  final Gradient? innerFlameGradient;

  /// Inner halo color, including alpha. Defaults to accent at 35% opacity.
  final Color? flameGlow;

  /// Outer halo color, including alpha. Defaults to flameBase at 12% opacity.
  final Color? flameGlowSecondary;

  /// First alternating particle color; defaults to flameTip.
  final Color? particlePrimary;

  /// Second alternating particle color; defaults to accent.
  final Color? particleSecondary;

  /// Badge background, independent of the dialog surface.
  final Color? badgeBackground;

  /// Center color of the default badge gradient.
  ///
  /// Defaults to badgeBackground tinted 5% toward foreground.
  final Color? badgeHighlight;

  /// Full badge fill override; takes precedence over background and highlight.
  final Gradient? badgeGradient;

  /// Badge border color; defaults to accent. Transparent hides the border.
  final Color? badgeBorder;

  /// Badge shadow color, including alpha. Defaults to accent at 40% opacity.
  final Color? badgeGlow;

  /// Starting count color; defaults to foreground.
  final Color? badgeOldNumber;

  /// Completed count color; defaults to flameCore.
  final Color? badgeNumber;

  /// Unit-label color; defaults to secondaryForeground.
  final Color? badgeLabel;

  /// Copies this palette while replacing selected colors or gradients.
  ///
  /// Null arguments retain existing values. Create a new StreakPalette to
  /// remove an override. Supplied gradients and their color lists must remain
  /// immutable; use a new palette/gradient when changing a theme.
  StreakPalette copyWith({
    Color? flameBase,
    Color? flameMiddle,
    Color? flameTip,
    Color? flameCore,
    Color? accent,
    Color? surface,
    Color? foreground,
    Color? secondaryForeground,
    Gradient? outerFlameGradient,
    Gradient? middleFlameGradient,
    Gradient? innerFlameGradient,
    Color? flameGlow,
    Color? flameGlowSecondary,
    Color? particlePrimary,
    Color? particleSecondary,
    Color? badgeBackground,
    Color? badgeHighlight,
    Gradient? badgeGradient,
    Color? badgeBorder,
    Color? badgeGlow,
    Color? badgeOldNumber,
    Color? badgeNumber,
    Color? badgeLabel,
  }) => StreakPalette(
    flameBase: flameBase ?? this.flameBase,
    flameMiddle: flameMiddle ?? this.flameMiddle,
    flameTip: flameTip ?? this.flameTip,
    flameCore: flameCore ?? this.flameCore,
    accent: accent ?? this.accent,
    surface: surface ?? this.surface,
    foreground: foreground ?? this.foreground,
    secondaryForeground: secondaryForeground ?? this.secondaryForeground,
    outerFlameGradient: outerFlameGradient ?? this.outerFlameGradient,
    middleFlameGradient: middleFlameGradient ?? this.middleFlameGradient,
    innerFlameGradient: innerFlameGradient ?? this.innerFlameGradient,
    flameGlow: flameGlow ?? this.flameGlow,
    flameGlowSecondary: flameGlowSecondary ?? this.flameGlowSecondary,
    particlePrimary: particlePrimary ?? this.particlePrimary,
    particleSecondary: particleSecondary ?? this.particleSecondary,
    badgeBackground: badgeBackground ?? this.badgeBackground,
    badgeHighlight: badgeHighlight ?? this.badgeHighlight,
    badgeGradient: badgeGradient ?? this.badgeGradient,
    badgeBorder: badgeBorder ?? this.badgeBorder,
    badgeGlow: badgeGlow ?? this.badgeGlow,
    badgeOldNumber: badgeOldNumber ?? this.badgeOldNumber,
    badgeNumber: badgeNumber ?? this.badgeNumber,
    badgeLabel: badgeLabel ?? this.badgeLabel,
  );
}
