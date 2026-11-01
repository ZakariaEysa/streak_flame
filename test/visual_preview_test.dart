import 'dart:io';
import 'dart:ui' as ui;
import 'package:streak_flame/streak_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a package preview for visual inspection', (
    tester,
  ) async {
    final key = GlobalKey();
    final fontPath = Platform.environment['STREAK_PREVIEW_FONT'];
    if (fontPath != null) {
      await tester.runAsync(() async {
        final bytes = await File(fontPath).readAsBytes();
        final loader = FontLoader('StreakPreview');
        loader.addFont(Future.value(ByteData.sublistView(bytes)));
        await loader.load();
      });
    }
    final iconFontPath = Platform.environment['STREAK_PREVIEW_ICON_FONT'];
    if (iconFontPath != null) {
      await tester.runAsync(() async {
        final bytes = await File(iconFontPath).readAsBytes();
        final loader = FontLoader('MaterialIcons');
        loader.addFont(Future.value(ByteData.sublistView(bytes)));
        await loader.load();
      });
    }
    const themes = {
      'streak_preview': StreakPalette(),
      'streak_customization': StreakPalette(
        flameBase: Color(0xFF2563EB),
        flameMiddle: Color(0xFF0891B2),
        flameTip: Color(0xFF67E8F9),
        flameCore: Color(0xFFECFEFF),
        accent: Color(0xFF22D3EE),
        badgeBackground: Colors.white,
        badgeHighlight: Color(0xFFFDF2F8),
        badgeBorder: Color(0xFFDB2777),
        badgeGlow: Color(0x66DB2777),
        badgeOldNumber: Color(0xFF475569),
        badgeNumber: Color(0xFFBE185D),
        badgeLabel: Color(0xFF475569),
      ),
    };
    final previews = {
      ...themes,
      'streak_full': themes['streak_preview']!,
      'streak_full_custom': themes['streak_customization']!,
    };
    for (final entry in previews.entries) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            fontFamily: fontPath == null ? null : 'StreakPreview',
          ),
          home: Scaffold(
            backgroundColor: const Color(0xFF091222),
            body: Center(
              child: RepaintBoundary(
                key: key,
                child: StreakWidget(
                  display: entry.key.startsWith('streak_full')
                      ? StreakDisplay.celebration
                      : StreakDisplay.flame,
                  size: entry.key.startsWith('streak_full') ? 160 : 220,
                  onContinue: () {},
                  onClose: () {},
                  badgeStyle: entry.key == 'streak_full_custom'
                      ? const StreakBadgeStyle(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            side: BorderSide(
                              color: Color(0xFFDB2777),
                              width: 4,
                            ),
                          ),
                        )
                      : const StreakBadgeStyle(),
                  celebrationStyle: entry.key == 'streak_full_custom'
                      ? const StreakCelebrationStyle(
                          backgroundColor: Color(0xFFFFF7ED),
                          borderColor: Color(0xFFDB2777),
                          borderWidth: 2,
                          titleColor: Color(0xFF831843),
                          subtitleColor: Color(0xFF475569),
                          headerBackgroundColor: Color(0xFFFCE7F3),
                          headerForegroundColor: Color(0xFF9D174D),
                          closeColor: Color(0xFF9D174D),
                          buttonBackgroundColor: Color(0xFFBE185D),
                          buttonForegroundColor: Colors.white,
                        )
                      : const StreakCelebrationStyle(),
                  oldStreak: 6,
                  newStreak: 7,
                  animationsEnabled: false,
                  palette: entry.value,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2);
        try {
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory('build').create(recursive: true);
          await File(
            'build/${entry.key}.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
        } finally {
          image.dispose();
        }
      });
      expect(tester.takeException(), isNull);
    }
  });
}
