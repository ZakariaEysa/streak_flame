import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_flame/streak_flame.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

Future<Uint8List> _pixels(WidgetTester tester, GlobalKey key) async {
  Uint8List? pixels;
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    try {
      pixels = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  });
  return pixels!;
}

void main() {
  testWidgets(
    'grouped and flat styling render identically with partial overrides',
    (tester) async {
      const flat = StreakCelebrationStyle(
        backgroundColor: Colors.white,
        borderColor: Colors.purple,
        borderWidth: 3,
        padding: EdgeInsets.all(12),
        headerBackgroundColor: Colors.pink,
        headerForegroundColor: Colors.white,
        headerBorderColor: Colors.blue,
        headerBorderWidth: 2,
        closeColor: Colors.green,
        closeBackgroundColor: Colors.orange,
        closeBorderColor: Colors.green,
        closeBorderWidth: 2,
        closeIconSize: 20,
        titleColor: Colors.green,
        subtitleColor: Colors.blue,
        textAlign: TextAlign.start,
        titleSubtitleSpacing: 12,
        actionSpacing: 15,
        buttonBackgroundColor: Colors.teal,
        buttonForegroundColor: Colors.white,
        buttonBorderColor: Colors.green,
        buttonBorderWidth: 2,
        buttonPadding: EdgeInsets.all(10),
        buttonMinimumSize: Size(48, 50),
      );
      const grouped = StreakCelebrationStyle(
        // Unspecified grouped properties retain flat settings.
        padding: EdgeInsets.all(12),
        headerBorderColor: Colors.blue,
        headerBorderWidth: 2,
        buttonMinimumSize: Size(48, 50),
        // Explicit grouped properties override these competing flat values.
        backgroundColor: Colors.black,
        titleColor: Colors.red,
        card: StreakCardStyle(
          backgroundColor: Colors.white,
          borderColor: Colors.purple,
          borderWidth: 3,
        ),
        header: StreakHeaderStyle(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        closeButton: StreakCloseStyle(
          foregroundColor: Colors.green,
          backgroundColor: Colors.orange,
          borderColor: Colors.green,
          borderWidth: 2,
          iconSize: 20,
        ),
        text: StreakTextStyle(
          titleColor: Colors.green,
          subtitleColor: Colors.blue,
          align: TextAlign.start,
          spacing: 12,
        ),
        action: StreakActionStyle(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          borderColor: Colors.green,
          borderWidth: 2,
          padding: EdgeInsets.all(10),
          spacing: 15,
        ),
      );
      final key = GlobalKey();
      final rasters = <Uint8List>[];
      for (final style in [flat, grouped]) {
        await tester.pumpWidget(
          _host(
            RepaintBoundary(
              key: key,
              child: StreakWidget(
                oldStreak: 3,
                newStreak: 3,
                size: 140,
                display: StreakDisplay.celebration,
                animationsEnabled: false,
                celebrationStyle: style,
                onContinue: () {},
                onClose: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        rasters.add(await _pixels(tester, key));
      }
      expect(rasters[1], orderedEquals(rasters[0]));
    },
  );

  test(
    'validation checks effective grouped overrides and preserves flat fallback',
    () {
      expect(
        () => const StreakCelebrationStyle(
          card: StreakCardStyle(borderWidth: -1),
        ).validate(),
        throwsArgumentError,
      );
      expect(
        () => const StreakCelebrationStyle(
          closeButton: StreakCloseStyle(iconSize: double.infinity),
        ).validate(),
        throwsArgumentError,
      );
      expect(
        () => const StreakCelebrationStyle(
          action: StreakActionStyle(minimumSize: Size(-1, 48)),
        ).validate(),
        throwsArgumentError,
      );
      expect(
        () => const StreakCelebrationStyle(
          headerBorderWidth: -1,
          header: StreakHeaderStyle(backgroundColor: Colors.green),
        ).validate(),
        throwsArgumentError,
      );
      const StreakCelebrationStyle(
        borderWidth: -1,
        card: StreakCardStyle(borderWidth: 2),
      ).validate();
    },
  );

  testWidgets('idle and count ticks leave static header and footer untouched', (
    tester,
  ) async {
    var headerBuilds = 0;
    var footerBuilds = 0;
    var formats = 0;
    var completions = 0;
    final controller = StreakAnimationController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        StreakWidget(
          oldStreak: 6,
          newStreak: 7,
          display: StreakDisplay.celebration,
          autoStart: false,
          controller: controller,
          transitionDuration: const Duration(milliseconds: 300),
          numberFormatter: (n) {
            formats++;
            return '$n';
          },
          header: Builder(
            builder: (context) {
              headerBuilds++;
              return const Text('Static header');
            },
          ),
          footer: Builder(
            builder: (context) {
              footerBuilds++;
              return const Text('Static footer');
            },
          ),
          onTransitionComplete: () => completions++,
        ),
      ),
    );
    final initialFormats = formats;
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(formats, initialFormats);
    expect(headerBuilds, 1);
    expect(footerBuilds, 1);
    controller.replay();
    await tester.pump();
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(completions, 1);
    expect(headerBuilds, 1);
    expect(footerBuilds, 1);
    final completedFormats = formats;
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(formats, completedFormats);
    controller.pause();
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.replay();
    await tester.pump();
    expect(completions, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'live grouped appearance updates preserve completed animation and shared legacy engine',
    (tester) async {
      var completions = 0;
      final controller = StreakAnimationController();
      addTearDown(controller.dispose);
      for (final color in [Colors.red, Colors.blue]) {
        await tester.pumpWidget(
          _host(
            StreakCelebrationDialog(
              oldStreak: 2,
              newStreak: 3,
              controller: controller,
              transitionDelay: Duration.zero,
              transitionDuration: const Duration(milliseconds: 100),
              idleAnimationEnabled: false,
              celebrationStyle: StreakCelebrationStyle(
                action: StreakActionStyle(backgroundColor: color),
              ),
              onTransitionComplete: () => completions++,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(BigStreakFlameWidget), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(find.byType(FilledButton))
              .style!
              .backgroundColor!
              .resolve({}),
          color,
        );
      }
      expect(completions, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.replay();
      await tester.pump();
      expect(completions, 1);
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.takeException(), isNull);
    },
  );
}
