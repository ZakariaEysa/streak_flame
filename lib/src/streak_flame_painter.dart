import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'streak_palette.dart';
import 'streak_badge_style.dart';
import 'streak_flame_style.dart';

/// Paints the original layered flame directly on animation notifications.
class StreakFlamePainter extends CustomPainter {
  /// Creates a painter with cached gradients and bounded particle work.
  StreakFlamePainter({
    required this.idle,
    required this.transition,
    required this.palette,
    required this.textDirection,
    required this.particleCount,
    required this.showGlow,
    required this.showParticles,
    this.flameStyle = const StreakFlameStyle(),
    this.badgeStyle = const StreakBadgeStyle(),
    required Listenable repaint,
  }) : super(repaint: repaint) {
    const rect = Rect.fromLTWH(0, 0, 224, 282);
    _outerShader =
        (palette.outerFlameGradient ??
                LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    palette.flameBase,
                    palette.flameMiddle,
                    Color.lerp(palette.flameMiddle, palette.flameTip, 0.5)!,
                    palette.flameTip,
                  ],
                  stops: const [0, 0.4, 0.75, 1],
                ))
            .createShader(rect, textDirection: textDirection);
    _middleShader =
        (palette.middleFlameGradient ??
                LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    palette.flameMiddle,
                    palette.flameTip,
                    palette.flameCore,
                  ],
                ))
            .createShader(rect, textDirection: textDirection);
    _coreShader =
        (palette.innerFlameGradient ??
                LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [palette.flameTip, palette.flameCore],
                ))
            .createShader(rect, textDirection: textDirection);
    _shaders = [_outerShader, _middleShader, _coreShader];
    _glowShader =
        RadialGradient(
          colors: [
            palette.flameGlow ?? palette.accent.withValues(alpha: 0.35),
            palette.flameGlowSecondary ??
                palette.flameBase.withValues(alpha: 0.12),
            Colors.transparent,
          ],
          stops: const [0, 0.55, 1],
        ).createShader(
          Rect.fromCircle(
            center: effectCenter,
            radius: math.max(flameStyle.glowRadius, 0.001),
          ),
        );
  }

  /// Idle animation source.
  final Animation<double> idle;

  /// Count transition source.
  final Animation<double> transition;

  /// Visual colors.
  final StreakPalette palette;

  /// Optional flame outline and effect geometry.
  final StreakFlameStyle flameStyle;

  /// Badge geometry shared with the effect origin.
  final StreakBadgeStyle badgeStyle;

  /// Badge center after applying the optional position offset.
  Offset get effectCenter => badgeCenter + badgeStyle.offset;

  /// Host direction for gradients using directional alignments.
  final TextDirection textDirection;

  /// Bounded number of celebration particles.
  final int particleCount;

  /// Whether to paint the ambient halo.
  final bool showGlow;

  /// Whether to paint burst particles.
  final bool showParticles;

  /// Badge/effect center with the original 39-pixel bottom inset at size 220.
  static const badgeCenter = Offset(176, 243);

  static const _layerScales = [1.0, 0.76, 0.48];
  late final List<Shader> _shaders;
  late final Shader _outerShader;
  late final Shader _middleShader;
  late final Shader _coreShader;
  late final Shader _glowShader;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    // A previous particle paint must not tint or fade gradient shaders.
    _paint.color = Colors.white;
    final phase = idle.value * 2 * math.pi;
    final progress = transition.value;
    final pulse = 0.9 + math.sin(phase) * 0.1;
    if (showGlow && flameStyle.glowRadius > 0) {
      canvas.save();
      canvas.translate(effectCenter.dx, effectCenter.dy);
      canvas.scale(pulse);
      canvas.translate(-effectCenter.dx, -effectCenter.dy);
      _paint.shader = _glowShader;
      canvas.drawCircle(effectCenter, flameStyle.glowRadius, _paint);
      canvas.restore();
    }
    _paint.shader = null;
    final burst = ((progress - 0.35) / 0.65).clamp(0.0, 1.0);
    if (showParticles && burst > 0 && burst < 1) {
      for (var i = 0; i < particleCount; i++) {
        final angle = i * 2 * math.pi / particleCount;
        final distance =
            (55 + (i % 7) * 6) * Curves.easeOutCubic.transform(burst);
        final particleColor = i.isEven
            ? (palette.particlePrimary ?? palette.flameTip)
            : (palette.particleSecondary ?? palette.accent);
        _paint.color = particleColor.withValues(
          alpha: particleColor.a * (1 - burst),
        );
        canvas.drawCircle(
          Offset(
            effectCenter.dx + math.cos(angle) * distance,
            effectCenter.dy + math.sin(angle) * distance + burst * burst * 14,
          ),
          (3 + i % 4) * (1 - burst * 0.5) * flameStyle.particleSize,
          _paint,
        );
      }
    }
    _paint.color = Colors.white;
    final scale = progress < 0.2
        ? 1 - progress * 0.4
        : progress < 0.55
        ? 0.92 + Curves.easeOutBack.transform((progress - 0.2) / 0.35) * 0.26
        : 1.18 - Curves.easeOutCubic.transform((progress - 0.55) / 0.45) * 0.18;
    canvas.save();
    canvas.translate(176, 332);
    canvas.scale(scale);
    canvas.translate(-112, -274);
    Path? outerPath;
    for (var layer = 0; layer < 3; layer++) {
      final layerScale = _layerScales[layer];
      _paint.shader = _shaders[layer];
      final path = _createFlamePath(
        w: 224,
        h: 282,
        tipOffset: math.sin(phase) * 224 * 0.04 * layerScale,
        leftOffset: math.cos(phase) * 224 * 0.025 * layerScale,
        rightOffset: math.sin(phase + 1.2) * 224 * 0.025 * layerScale,
        scale: layerScale,
      );
      if (layer == 0) outerPath = path;
      canvas.drawPath(path, _paint);
    }
    if (flameStyle.borderWidth > 0 && outerPath != null) {
      _paint.shader = null;
      _paint.color = flameStyle.borderColor ?? palette.flameBase;
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = flameStyle.borderWidth;
      _paint.strokeJoin = flameStyle.strokeJoin;
      canvas.drawPath(outerPath, _paint);
      _paint.style = PaintingStyle.fill;
    }
    canvas.restore();
    _paint.shader = null;
  }

  Path _createFlamePath({
    required double w,
    required double h,
    required double tipOffset,
    required double leftOffset,
    required double rightOffset,
    required double scale,
  }) {
    final cx = w / 2;
    final cy = h * 0.72;

    final path = Path();

    // Scale from the lower center (cx, cy)
    final matrix = Matrix4.identity();
    if (scale != 1.0) {
      matrix.setEntry(0, 0, scale);
      matrix.setEntry(1, 1, scale);
      matrix.setEntry(0, 3, cx * (1.0 - scale));
      matrix.setEntry(1, 3, cy * (1.0 - scale));
    }

    final localPath = Path();

    // Bottom base point
    localPath.moveTo(cx, h * 0.97);

    // Left base curve to left belly
    localPath.cubicTo(
      cx - w * 0.35 + leftOffset * 0.3,
      h * 0.96,
      cx - w * 0.52 + leftOffset * 0.5,
      h * 0.78,
      cx - w * 0.48 + leftOffset * 0.6,
      h * 0.56,
    );

    // Left tongue up towards outer left crest
    localPath.cubicTo(
      cx - w * 0.46 + leftOffset * 0.7,
      h * 0.40,
      cx - w * 0.38 + leftOffset * 0.9,
      h * 0.26,
      cx - w * 0.26 + leftOffset,
      h * 0.18,
    );

    // Left tongue into inner left scoop / valley
    localPath.cubicTo(
      cx - w * 0.22 + leftOffset * 0.8,
      h * 0.23,
      cx - w * 0.16 + leftOffset * 0.4,
      h * 0.30,
      cx - w * 0.10 + leftOffset * 0.3,
      h * 0.27,
    );

    // Valley up to the soaring central apex tip
    localPath.cubicTo(
      cx - w * 0.06 + tipOffset * 0.3,
      h * 0.18,
      cx - w * 0.02 + tipOffset * 0.7,
      h * 0.07,
      cx + tipOffset,
      h * 0.008,
    );

    // Central apex down to inner right scoop / valley
    localPath.cubicTo(
      cx + w * 0.04 + tipOffset * 0.7,
      h * 0.07,
      cx + w * 0.08 + rightOffset * 0.2,
      h * 0.17,
      cx + w * 0.13 + rightOffset * 0.3,
      h * 0.26,
    );

    // Inner right valley up to outer right tongue crest
    localPath.cubicTo(
      cx + w * 0.18 + rightOffset * 0.5,
      h * 0.27,
      cx + w * 0.26 + rightOffset * 0.8,
      h * 0.22,
      cx + w * 0.33 + rightOffset,
      h * 0.20,
    );

    // Right tongue down into right belly
    localPath.cubicTo(
      cx + w * 0.36 + rightOffset * 0.9,
      h * 0.34,
      cx + w * 0.47 + rightOffset * 0.7,
      h * 0.44,
      cx + w * 0.48 + rightOffset * 0.6,
      h * 0.58,
    );

    // Right belly down to bottom base
    localPath.cubicTo(
      cx + w * 0.50 + rightOffset * 0.4,
      h * 0.76,
      cx + w * 0.35,
      h * 0.96,
      cx,
      h * 0.97,
    );

    localPath.close();

    path.addPath(localPath.transform(matrix.storage), Offset.zero);
    return path;
  }

  @override
  bool shouldRepaint(covariant StreakFlamePainter oldDelegate) =>
      oldDelegate.idle != idle ||
      oldDelegate.transition != transition ||
      oldDelegate.palette != palette ||
      oldDelegate.flameStyle != flameStyle ||
      oldDelegate.badgeStyle != badgeStyle ||
      oldDelegate.textDirection != textDirection ||
      oldDelegate.particleCount != particleCount ||
      oldDelegate.showGlow != showGlow ||
      oldDelegate.showParticles != showParticles;
}
