import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_flame/streak_flame.dart';
import 'package:streak_flame/src/streak_badge.dart';
import 'package:streak_flame/src/streak_celebration_frame.dart';
import 'package:streak_flame/src/streak_dialog_header.dart';

Widget _host(Widget child, {bool reduced = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('default presentation is flame only and full is an inline card', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const StreakWidget(
          oldStreak: 2,
          newStreak: 3,
          animationsEnabled: false,
        ),
      ),
    );
    expect(find.byType(BigStreakFlameWidget), findsOneWidget);
    expect(find.byType(StreakCelebrationFrame), findsNothing);
    await tester.pumpWidget(
      _host(
        const StreakWidget(
          oldStreak: 2,
          newStreak: 3,
          display: StreakDisplay.celebration,
          animationsEnabled: false,
        ),
      ),
    );
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Streak updated!'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('inline callbacks do not pop the host route', (tester) async {
    var actions = 0;
    var closes = 0;
    await tester.pumpWidget(
      _host(
        StreakWidget(
          oldStreak: 2,
          newStreak: 3,
          display: StreakDisplay.celebration,
          animationsEnabled: false,
          size: 150,
          onContinue: () => actions++,
          onClose: () => closes++,
        ),
      ),
    );
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.ensureVisible(find.byType(IconButton));
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(actions, 1);
    expect(closes, 1);
    expect(find.byType(StreakWidget), findsOneWidget);
  });

  testWidgets('independent frame, badge, typography and action overrides win', (
    tester,
  ) async {
    const badgeShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      side: BorderSide(color: Colors.purple, width: 5),
    );
    const style = StreakCelebrationStyle(
      backgroundColor: Colors.white,
      borderColor: Colors.red,
      borderWidth: 3,
      titleColor: Colors.orange,
      titleStyle: TextStyle(color: Colors.green),
      subtitleColor: Colors.blue,
      headerForegroundColor: Colors.purple,
      buttonBackgroundColor: Colors.red,
      buttonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.teal),
      ),
      closeColor: Colors.red,
      closeButtonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.blue),
      ),
    );
    await tester.pumpWidget(
      _host(
        StreakWidget(
          oldStreak: 3,
          newStreak: 3,
          display: StreakDisplay.celebration,
          size: 140,
          animationsEnabled: false,
          celebrationStyle: style,
          badgeStyle: const StreakBadgeStyle(shape: badgeShape, shadows: []),
          numberStyle: const TextStyle(color: Colors.pink),
          onContinue: () {},
          onClose: () {},
        ),
      ),
    );
    expect(
      tester.widget<Text>(find.text('Streak updated!')).style!.color,
      Colors.green,
    );
    final badgeBox = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(StreakBadge),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = badgeBox.decoration as ShapeDecoration;
    expect(decoration.shape, badgeShape);
    expect(decoration.shadows, isEmpty);
    expect(tester.widget<Text>(find.text('3')).style!.color, Colors.pink);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.style!.backgroundColor!.resolve({}), Colors.teal);
    final close = tester.widget<IconButton>(find.byType(IconButton));
    expect(close.style!.foregroundColor!.resolve({}), Colors.blue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('header/footer can be replaced or hidden independently', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const StreakWidget(
          oldStreak: 0,
          newStreak: 1,
          display: StreakDisplay.celebration,
          animationsEnabled: false,
          header: Text('Own header'),
          footer: Text('Own footer'),
        ),
      ),
    );
    expect(find.text('Own header'), findsOneWidget);
    expect(find.text('Own footer'), findsOneWidget);
    expect(find.byType(StreakDialogHeader), findsNothing);
    await tester.pumpWidget(
      _host(
        const StreakWidget(
          oldStreak: 0,
          newStreak: 1,
          display: StreakDisplay.celebration,
          animationsEnabled: false,
          header: Text('Own header'),
          footer: Text('Own footer'),
          celebrationStyle: StreakCelebrationStyle(
            showHeader: false,
            showAction: false,
          ),
        ),
      ),
    );
    expect(find.text('Own header'), findsNothing);
    expect(find.text('Own footer'), findsNothing);
  });

  testWidgets(
    'tiny custom badge and narrow RTL large text fit without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(220, 280);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(3)),
            child: const Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: StreakWidget(
                  oldStreak: 8,
                  newStreak: 1,
                  display: StreakDisplay.celebration,
                  animationsEnabled: false,
                  badgeStyle: StreakBadgeStyle(
                    size: 24,
                    padding: EdgeInsets.all(2),
                  ),
                  numberFormatter: null,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.ensureVisible(find.text('Continue'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('frame respects maxWidth even in a tight wide parent', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 800,
          child: StreakWidget(
            oldStreak: 1,
            newStreak: 1,
            display: StreakDisplay.celebration,
            animationsEnabled: false,
            maxWidth: 320,
          ),
        ),
      ),
    );
    final decorated = find
        .descendant(
          of: find.byType(StreakCelebrationFrame),
          matching: find.byType(DecoratedBox),
        )
        .first;
    expect(tester.getSize(decorated).width, 320);
    expect(tester.takeException(), isNull);
  });

  testWidgets('manual restart words complete and reset on replay', (
    tester,
  ) async {
    final controller = StreakAnimationController();
    addTearDown(controller.dispose);
    var completions = 0;
    await tester.pumpWidget(
      _host(
        StreakWidget(
          oldStreak: 9,
          newStreak: 1,
          display: StreakDisplay.celebration,
          autoStart: false,
          idleAnimationEnabled: false,
          transitionDuration: const Duration(milliseconds: 100),
          controller: controller,
          onTransitionComplete: () => completions++,
          strings: const StreakStrings(
            resetTitle: 'Before restart',
            resetUpdatedTitle: 'After restart',
          ),
        ),
      ),
    );
    expect(find.text('Before restart'), findsOneWidget);
    controller.replay();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(find.text('After restart'), findsOneWidget);
    expect(completions, 1);
    controller.replay();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(completions, 2);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.replay();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion opt-out is honored by both title and flame', (
    tester,
  ) async {
    final controller = StreakAnimationController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        StreakWidget(
          oldStreak: 8,
          newStreak: 1,
          display: StreakDisplay.celebration,
          autoStart: false,
          idleAnimationEnabled: false,
          respectReducedMotion: false,
          controller: controller,
          strings: const StreakStrings(
            resetTitle: 'Before',
            resetUpdatedTitle: 'After',
          ),
        ),
        reduced: true,
      ),
    );
    expect(find.text('Before'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    await tester.pumpWidget(
      _host(
        StreakWidget(
          oldStreak: 8,
          newStreak: 1,
          display: StreakDisplay.celebration,
          autoStart: false,
          idleAnimationEnabled: false,
          controller: controller,
          strings: const StreakStrings(
            resetTitle: 'Before',
            resetUpdatedTitle: 'After',
          ),
        ),
        reduced: true,
      ),
    );
    await tester.pump();
    expect(find.text('After'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets(
    'live style and header visibility updates preserve animation state',
    (tester) async {
      var completions = 0;
      for (final hidden in [false, true]) {
        await tester.pumpWidget(
          _host(
            StreakWidget(
              oldStreak: 1,
              newStreak: 2,
              display: StreakDisplay.celebration,
              idleAnimationEnabled: false,
              transitionDelay: Duration.zero,
              transitionDuration: const Duration(milliseconds: 100),
              badgeStyle: StreakBadgeStyle(borderWidth: hidden ? 5 : 3),
              celebrationStyle: StreakCelebrationStyle(
                showHeader: !hidden,
                backgroundColor: hidden ? Colors.black : null,
              ),
              onTransitionComplete: () => completions++,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('2'), findsOneWidget);
      }
      expect(completions, 1);
    },
  );

  testWidgets('popup forwards styling, controls, inherited RTL and dismissal', (
    tester,
  ) async {
    var actions = 0;
    var dismissals = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: const MediaQueryData(
              disableAnimations: true,
              textScaler: TextScaler.linear(2),
            ),
            child: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => StreakWidget.showCelebration(
                    context,
                    oldStreak: 9,
                    newStreak: 1,
                    badgeStyle: const StreakBadgeStyle(borderWidth: 7),
                    celebrationStyle: const StreakCelebrationStyle(
                      backgroundColor: Colors.pink,
                    ),
                    numberFormatter: (n) => 'count $n',
                    unitLabelBuilder: (n) => 'unit $n',
                    onContinue: () => actions++,
                    onDismiss: () => dismissals++,
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    final flame = tester.widget<BigStreakFlameWidget>(
      find.byType(BigStreakFlameWidget),
    );
    expect(flame.badgeStyle.borderWidth, 7);
    expect(find.text('count 1'), findsOneWidget);
    expect(find.text('unit 1'), findsOneWidget);
    final context = tester.element(find.byType(StreakWidget));
    expect(Directionality.of(context), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(context).scale(10), 20);
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(actions, 1);
    expect(dismissals, 1);
    expect(find.byType(StreakWidget), findsNothing);
  });

  test('invalid custom geometry is rejected', () {
    expect(
      () => const StreakFlameStyle(borderWidth: -1).validate(),
      throwsArgumentError,
    );
    expect(
      () => const StreakFlameStyle(glowRadius: double.infinity).validate(),
      throwsArgumentError,
    );
    expect(
      () => const StreakBadgeStyle(size: 0).validate(),
      throwsArgumentError,
    );
    expect(
      () => const StreakBadgeStyle(offset: Offset(double.nan, 0)).validate(),
      throwsArgumentError,
    );
    expect(
      () => const StreakCelebrationStyle(buttonBorderWidth: -1).validate(),
      throwsArgumentError,
    );
  });

  testWidgets('custom outline paints its color with transparent flame fills', (
    tester,
  ) async {
    const clear = LinearGradient(
      colors: [Colors.transparent, Colors.transparent],
    );
    final key = GlobalKey();
    await tester.pumpWidget(
      _host(
        RepaintBoundary(
          key: key,
          child: const StreakWidget(
            oldStreak: 1,
            newStreak: 1,
            animationsEnabled: false,
            showGlow: false,
            showParticles: false,
            palette: StreakPalette(
              outerFlameGradient: clear,
              middleFlameGradient: clear,
              innerFlameGradient: clear,
            ),
            flameStyle: StreakFlameStyle(
              borderColor: Colors.green,
              borderWidth: 6,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    var greenPixels = 0;
    await tester.runAsync(() async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage();
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        for (var i = 0; i < data!.lengthInBytes; i += 4) {
          if (data.getUint8(i + 1) > data.getUint8(i) * 2 &&
              data.getUint8(i + 1) > data.getUint8(i + 2) * 2 &&
              data.getUint8(i + 3) > 200)
            greenPixels++;
        }
      } finally {
        image.dispose();
      }
    });
    expect(greenPixels, greaterThan(500));
  });
}
