import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_flame/streak_flame.dart';
import 'package:streak_flame/src/streak_flame_painter.dart';

Widget _host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    MaterialApp(
      home: Directionality(
        textDirection: direction,
        child: Center(child: child),
      ),
    );

Future<_Raster> _capture(WidgetTester tester, GlobalKey key) async {
  final raster = await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      return _Raster(image.width, bytes!.buffer.asUint8List());
    } finally {
      image.dispose();
    }
  });
  return raster!;
}

class _Raster {
  _Raster(this.width, this.bytes);
  final int width;
  final Uint8List bytes;

  Color at(int x, int y) {
    final offset = (y * width + x) * 4;
    return Color.fromARGB(
      bytes[offset + 3],
      bytes[offset],
      bytes[offset + 1],
      bytes[offset + 2],
    );
  }

  int count(Color color) {
    var matches = 0;
    final value = color.toARGB32();
    for (var offset = 0; offset < bytes.length; offset += 4) {
      final pixel =
          (bytes[offset + 3] << 24) |
          (bytes[offset] << 16) |
          (bytes[offset + 1] << 8) |
          bytes[offset + 2];
      if (pixel == value) matches++;
    }
    return matches;
  }
}

void main() {
  test(
    'copyWith changes selected colors while retaining independent overrides',
    () {
      const original = StreakPalette(
        badgeNumber: Colors.pink,
        outerFlameGradient: LinearGradient(colors: [Colors.blue, Colors.cyan]),
      );
      final updated = original.copyWith(
        flameBase: Colors.green,
        badgeBackground: Colors.white,
      );
      expect(updated.flameBase, Colors.green);
      expect(updated.badgeBackground, Colors.white);
      expect(updated.badgeNumber, Colors.pink);
      expect(updated.outerFlameGradient, original.outerFlameGradient);
      expect(original.flameBase, const Color(0xFFDC2626));
      expect(original.badgeBackground, isNull);
    },
  );

  testWidgets('old, completed, and unit colors support partial typography', (
    tester,
  ) async {
    const palette = StreakPalette(
      badgeOldNumber: Colors.blue,
      badgeNumber: Colors.pink,
      badgeLabel: Colors.green,
    );
    await tester.pumpWidget(
      _host(
        const BigStreakFlameWidget(
          oldStreak: 6,
          newStreak: 7,
          autoStart: false,
          idleAnimationEnabled: false,
          palette: palette,
          numberStyle: TextStyle(fontSize: 32),
          unitStyle: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
    );
    expect(tester.widget<Text>(find.text('6')).style!.color, Colors.blue);
    expect(tester.widget<Text>(find.text('6')).style!.fontSize, 32);
    expect(tester.widget<Text>(find.text('days')).style!.color, Colors.green);

    await tester.pumpWidget(
      _host(
        const BigStreakFlameWidget(
          oldStreak: 6,
          newStreak: 7,
          animationsEnabled: false,
          palette: palette,
          numberStyle: TextStyle(fontSize: 32),
          unitStyle: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
    );
    expect(tester.widget<Text>(find.text('7')).style!.color, Colors.pink);
    expect(
      tester.widget<Text>(find.text('days')).style!.fontWeight,
      FontWeight.w400,
    );
  });

  testWidgets(
    'explicit typography colors take precedence over palette colors',
    (tester) async {
      await tester.pumpWidget(
        _host(
          const BigStreakFlameWidget(
            oldStreak: 6,
            newStreak: 7,
            animationsEnabled: false,
            palette: StreakPalette(
              badgeNumber: Colors.pink,
              badgeLabel: Colors.green,
            ),
            numberStyle: TextStyle(color: Colors.blue),
            unitStyle: TextStyle(color: Colors.purple),
          ),
        ),
      );
      expect(tester.widget<Text>(find.text('7')).style!.color, Colors.blue);
      expect(
        tester.widget<Text>(find.text('days')).style!.color,
        Colors.purple,
      );
    },
  );

  testWidgets(
    'all three custom flame gradients and badge fill render independently',
    (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        _host(
          RepaintBoundary(
            key: key,
            child: const BigStreakFlameWidget(
              oldStreak: 6,
              newStreak: 7,
              animationsEnabled: false,
              showGlow: false,
              showParticles: false,
              palette: StreakPalette(
                outerFlameGradient: LinearGradient(
                  colors: [Colors.green, Colors.green],
                ),
                middleFlameGradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue],
                ),
                innerFlameGradient: LinearGradient(
                  colors: [Colors.purple, Colors.purple],
                ),
                badgeBackground: Colors.white,
                badgeHighlight: Colors.white,
                badgeGradient: LinearGradient(
                  colors: [Colors.yellow, Colors.yellow],
                ),
                badgeBorder: Colors.pink,
                badgeGlow: Colors.transparent,
              ),
            ),
          ),
        ),
      );
      final raster = await _capture(tester, key);
      for (final color in [
        Colors.green,
        Colors.blue,
        Colors.purple,
        Colors.yellow,
        Colors.pink,
      ]) {
        expect(
          raster.count(color),
          greaterThan(100),
          reason: 'Visible $color region',
        );
      }
      expect(
        raster.count(Colors.white),
        0,
        reason: 'Badge gradient overrides background',
      );
    },
  );

  testWidgets(
    'badge background changes without altering flame or dialog surface',
    (tester) async {
      final key = GlobalKey();
      const palette = StreakPalette(
        surface: Colors.black,
        badgeBackground: Colors.yellow,
        badgeHighlight: Colors.yellow,
        badgeBorder: Colors.transparent,
        badgeGlow: Colors.transparent,
      );
      await tester.pumpWidget(
        _host(
          RepaintBoundary(
            key: key,
            child: const BigStreakFlameWidget(
              oldStreak: 6,
              newStreak: 7,
              animationsEnabled: false,
              showGlow: false,
              palette: palette,
            ),
          ),
        ),
      );
      final raster = await _capture(tester, key);
      expect(raster.count(Colors.yellow), greaterThan(1000));
      expect(raster.count(Colors.black), 0);
      expect(palette.surface, Colors.black);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'live theme changes repaint shaders without replaying count completion',
    (tester) async {
      final key = GlobalKey();
      var completions = 0;
      const initial = StreakPalette(
        outerFlameGradient: LinearGradient(
          colors: [Colors.green, Colors.green],
        ),
        middleFlameGradient: LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        ),
        innerFlameGradient: LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        ),
      );
      for (final palette in [
        initial,
        initial.copyWith(
          outerFlameGradient: const LinearGradient(
            colors: [Colors.blue, Colors.blue],
          ),
          badgeNumber: Colors.pink,
        ),
      ]) {
        await tester.pumpWidget(
          _host(
            RepaintBoundary(
              key: key,
              child: BigStreakFlameWidget(
                oldStreak: 6,
                newStreak: 7,
                idleAnimationEnabled: false,
                transitionDelay: Duration.zero,
                transitionDuration: const Duration(milliseconds: 100),
                showGlow: false,
                palette: palette,
                onTransitionComplete: () => completions++,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final raster = await _capture(tester, key);
        final color = identical(palette, initial) ? Colors.green : Colors.blue;
        expect(raster.count(color), greaterThan(1000));
        expect(find.text('6'), findsNothing);
        expect(find.text('7'), findsOneWidget);
        expect(completions, 1);
      }
      expect(tester.widget<Text>(find.text('7')).style!.color, Colors.pink);
    },
  );

  testWidgets('directional custom flame gradients follow live RTL changes', (
    tester,
  ) async {
    final key = GlobalKey();
    final rasters = <_Raster>[];
    for (final direction in [TextDirection.ltr, TextDirection.rtl]) {
      await tester.pumpWidget(
        _host(
          RepaintBoundary(
            key: key,
            child: const BigStreakFlameWidget(
              oldStreak: 6,
              newStreak: 7,
              animationsEnabled: false,
              showGlow: false,
              palette: StreakPalette(
                outerFlameGradient: LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [Colors.red, Colors.blue],
                ),
                middleFlameGradient: LinearGradient(
                  colors: [Colors.transparent, Colors.transparent],
                ),
                innerFlameGradient: LinearGradient(
                  colors: [Colors.transparent, Colors.transparent],
                ),
              ),
            ),
          ),
          direction: direction,
        ),
      );
      expect(tester.takeException(), isNull);
      rasters.add(await _capture(tester, key));
    }
    final ltrLeft = rasters[0].at(85, 245);
    final rtlLeft = rasters[1].at(85, 245);
    expect(ltrLeft.a, 1);
    expect(rtlLeft.a, 1);
    expect(ltrLeft.r, greaterThan(ltrLeft.b));
    expect(rtlLeft.b, greaterThan(rtlLeft.r));
  });

  testWidgets('transparent particles do not fade or tint the flame', (
    tester,
  ) async {
    final key = GlobalKey();
    const progress = AlwaysStoppedAnimation(0.6);
    const idle = AlwaysStoppedAnimation(0.0);
    final rasters = <_Raster>[];
    for (final particles in [false, true]) {
      await tester.pumpWidget(
        _host(
          RepaintBoundary(
            key: key,
            child: SizedBox(
              width: 352,
              height: 396,
              child: CustomPaint(
                painter: StreakFlamePainter(
                  idle: idle,
                  transition: progress,
                  repaint: progress,
                  textDirection: TextDirection.ltr,
                  particleCount: 28,
                  showGlow: false,
                  showParticles: particles,
                  palette: const StreakPalette(
                    particlePrimary: Colors.transparent,
                    particleSecondary: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      rasters.add(await _capture(tester, key));
    }
    expect(rasters[1].bytes, orderedEquals(rasters[0].bytes));
  });

  testWidgets('independent halo and particle colors preserve effect opacity', (
    tester,
  ) async {
    final key = GlobalKey();
    const idle = AlwaysStoppedAnimation(0.0);
    const progress = AlwaysStoppedAnimation(0.6);
    const invisibleLayers = LinearGradient(
      colors: [Colors.transparent, Colors.transparent],
    );
    const halo = StreakPalette(
      outerFlameGradient: invisibleLayers,
      middleFlameGradient: invisibleLayers,
      innerFlameGradient: invisibleLayers,
      flameGlow: Colors.green,
      flameGlowSecondary: Colors.green,
    );
    final rasters = <_Raster>[];
    for (final palette in [
      halo,
      halo.copyWith(
        flameGlow: Colors.transparent,
        flameGlowSecondary: Colors.transparent,
        particlePrimary: Colors.purpleAccent,
        particleSecondary: Colors.cyanAccent,
      ),
      halo.copyWith(
        flameGlow: Colors.transparent,
        flameGlowSecondary: Colors.transparent,
        particlePrimary: Colors.purpleAccent.withValues(alpha: 0.5),
        particleSecondary: Colors.cyanAccent.withValues(alpha: 0.5),
      ),
    ]) {
      await tester.pumpWidget(
        _host(
          RepaintBoundary(
            key: key,
            child: SizedBox(
              width: 352,
              height: 396,
              child: CustomPaint(
                painter: StreakFlamePainter(
                  idle: idle,
                  transition: progress,
                  repaint: progress,
                  textDirection: TextDirection.ltr,
                  particleCount: 28,
                  showGlow: true,
                  showParticles: !identical(palette, halo),
                  palette: palette,
                ),
              ),
            ),
          ),
        ),
      );
      rasters.add(await _capture(tester, key));
    }
    expect(rasters[0].at(176, 282).toARGB32(), Colors.green.toARGB32());
    int peakAlpha(_Raster raster) {
      var peak = 0;
      for (var offset = 3; offset < raster.bytes.length; offset += 4) {
        if (raster.bytes[offset] > peak) peak = raster.bytes[offset];
      }
      return peak;
    }

    expect(peakAlpha(rasters[1]), greaterThan(0));
    expect(peakAlpha(rasters[2]), greaterThan(0));
    expect(peakAlpha(rasters[2]), lessThan(peakAlpha(rasters[1])));
    // Both alternating color families must be visible in the burst.
    var purple = 0;
    var cyan = 0;
    for (var offset = 0; offset < rasters[1].bytes.length; offset += 4) {
      final r = rasters[1].bytes[offset];
      final g = rasters[1].bytes[offset + 1];
      final b = rasters[1].bytes[offset + 2];
      if (r > g && b > g) purple++;
      if (g > r && b > r) cyan++;
    }
    expect(purple, greaterThan(10));
    expect(cyan, greaterThan(10));
  });
}
