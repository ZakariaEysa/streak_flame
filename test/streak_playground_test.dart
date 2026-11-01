import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_flame/streak_flame.dart';

import '../example/lib/main.dart';
import '../example/lib/streak_demo_page.dart';

Future<void> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const StreakExampleApp(home: StreakDemoPage()));
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  final controls = find.byKey(const ValueKey('playground-controls'));
  final scrollable = find
      .descendant(of: controls, matching: find.byType(Scrollable))
      .first;
  tester.state<ScrollableState>(scrollable).position.jumpTo(0);
  await tester.pump();
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: scrollable,
    maxScrolls: 60,
  );
  await tester.ensureVisible(finder);
  await tester.pump();
}

Future<void> _toggle(WidgetTester tester, String label) async {
  final finder = find.widgetWithText(SwitchListTile, label);
  await _reveal(tester, finder);
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _edit(WidgetTester tester, String key, String value) async {
  final finder = find.byKey(ValueKey(key));
  await _reveal(tester, finder);
  await tester.enterText(finder, value);
  await tester.pump();
}

Future<void> _max(WidgetTester tester, String label) async {
  final finder = find.byKey(ValueKey(label));
  await _reveal(tester, finder);
  await tester.drag(finder, const Offset(1000, 0));
  await tester.pump();
}

BigStreakFlameWidget _flame(WidgetTester tester) => tester
    .widget<BigStreakFlameWidget>(find.byType(BigStreakFlameWidget).first);

void main() {
  testWidgets(
    'invalid counts stay unchanged; zero, resets, equal and large counts apply',
    (tester) async {
      await _open(tester);
      await _edit(tester, 'old-count', '-1');
      await _edit(tester, 'new-count', '1.5');
      await _reveal(tester, find.text('Apply counts'));
      await tester.tap(find.text('Apply counts'));
      await tester.pump();
      expect(find.text('Enter a whole number of 0 or more'), findsNWidgets(2));
      expect(_flame(tester).oldStreak, 6);
      expect(_flame(tester).newStreak, 7);

      for (final counts in [
        (12, 1),
        (12, 0),
        (0, 1),
        (5, 5),
        (999999, 1000000),
      ]) {
        await _edit(tester, 'old-count', '${counts.$1}');
        await _edit(tester, 'new-count', '${counts.$2}');
        await _reveal(tester, find.text('Apply counts'));
        await tester.tap(find.text('Apply counts'));
        await tester.pump();
        expect(_flame(tester).oldStreak, counts.$1);
        expect(_flame(tester).newStreak, counts.$2);
        expect(find.text('Enter a whole number of 0 or more'), findsNothing);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('largest VM count does not wrap negative on next day', (
    tester,
  ) async {
    await _open(tester);
    await _edit(tester, 'old-count', '0');
    await _edit(tester, 'new-count', '9223372036854775807');
    await _reveal(tester, find.text('Apply counts'));
    await tester.tap(find.text('Apply counts'));
    await tester.pump();
    await tester.tap(find.text('Next day'));
    await tester.pump();
    expect(_flame(tester).newStreak, 9223372036854775807);
    expect(
      find.text('This count cannot be increased on this platform.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('scenario buttons keep editors and preview synchronized', (
    tester,
  ) async {
    await _open(tester);
    for (final scenario in [
      ('Next day', 8),
      ('Restart streak', 1),
      ('Lose streak', 0),
    ]) {
      await tester.tap(find.text(scenario.$1));
      await tester.pump();
      expect(_flame(tester).newStreak, scenario.$2);
      await _reveal(tester, find.byKey(const ValueKey('new-count')));
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('new-count')))
            .controller!
            .text,
        '${scenario.$2}',
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'themes, motion, timing and particle controls update the preview',
    (tester) async {
      await _open(tester);
      await _toggle(tester, 'Blue palette');
      await _toggle(tester, 'Light badge / pink border');
      expect(_flame(tester).palette.flameBase, const Color(0xFF2563EB));
      expect(_flame(tester).palette.badgeBackground, Colors.white);
      await _toggle(tester, 'Idle flicker');
      await _toggle(tester, 'Flame glow');
      await _toggle(tester, 'Burst particles');
      expect(_flame(tester).idleAnimationEnabled, isFalse);
      expect(_flame(tester).showGlow, isFalse);
      expect(_flame(tester).showParticles, isFalse);
      await _max(tester, 'Flame size');
      await _max(tester, 'Transition duration');
      await _max(tester, 'Transition delay');
      await _max(tester, 'Idle duration');
      await _max(tester, 'Particles');
      expect(_flame(tester).size, 360);
      expect(
        _flame(tester).transitionDuration,
        const Duration(milliseconds: 3000),
      );
      expect(
        _flame(tester).transitionDelay,
        const Duration(milliseconds: 2000),
      );
      expect(_flame(tester).idleDuration, const Duration(milliseconds: 4000));
      expect(_flame(tester).particleCount, 64);
      await _toggle(tester, 'Simulate reduced motion');
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(BigStreakFlameWidget),
          matching: find.text('7'),
        ),
        findsOneWidget,
      );
      expect(tester.binding.transientCallbackCount, 0);
      await _max(tester, 'Text scale');
      expect(
        MediaQuery.textScalerOf(
          tester.element(find.byType(BigStreakFlameWidget)),
        ).scale(10),
        30,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'custom increase and restart messages reach the dialog with Arabic RTL',
    (tester) async {
      await _open(tester);
      await _toggle(tester, 'Animations');
      await _edit(tester, 'positive-message', 'Great progress!');
      await _edit(tester, 'restart-message', 'Your comeback starts now!');
      await tester.tap(find.text('Next day'));
      await tester.pump();
      await tester.tap(find.text('Celebrate'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is StreakWidget &&
                widget.display == StreakDisplay.celebration,
          ),
          matching: find.text('Great progress!'),
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Continue'));
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await _toggle(tester, 'Arabic / RTL');
      await tester.tap(find.text('Restart streak'));
      await tester.pump();
      await tester.tap(find.text('Celebrate'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is StreakWidget &&
                widget.display == StreakDisplay.celebration,
          ),
          matching: find.text('Your comeback starts now!'),
        ),
        findsOneWidget,
      );
      final dialog = tester.element(
        find.byWidgetPredicate(
          (widget) =>
              widget is StreakWidget &&
              widget.display == StreakDisplay.celebration,
        ),
      );
      expect(Directionality.of(dialog), TextDirection.rtl);
      expect(find.text('يوم'), findsWidgets);
      await tester.ensureVisible(find.text('كمل'));
      await tester.tap(find.text('كمل'));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is StreakWidget &&
              widget.display == StreakDisplay.celebration,
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('pause, resume, replay and removal release animation resources', (
    tester,
  ) async {
    await _open(tester);
    await tester.tap(find.text('Replay'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Pause'));
    await tester.pump(const Duration(seconds: 3));
    expect(
      find.descendant(
        of: find.byType(BigStreakFlameWidget),
        matching: find.text('6'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(
      find.descendant(
        of: find.byType(BigStreakFlameWidget),
        matching: find.text('7'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Replay'));
    await tester.pump();
    expect(
      find.descendant(
        of: find.byType(BigStreakFlameWidget),
        matching: find.text('6'),
      ),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'narrow large-text playground remains scrollable without overflow',
    (tester) async {
      await _open(tester);
      await _toggle(tester, 'Arabic / RTL');
      await _toggle(tester, 'Animations');
      await _max(tester, 'Text scale');
      tester.view.physicalSize = const Size(280, 600);
      await tester.pump();
      await _reveal(tester, find.byKey(const ValueKey('restart-message')));
      expect(find.byKey(const ValueKey('restart-message')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'full preview and independent shape presets reach inline and popup content',
    (tester) async {
      await _open(tester);
      await _toggle(tester, 'Animations');
      await _toggle(tester, 'Full celebration preview');
      await _toggle(tester, 'Rounded square badge');
      await _toggle(tester, 'Custom frame / borders');
      final preview = tester.widget<StreakWidget>(
        find.byType(StreakWidget).first,
      );
      expect(preview.display, StreakDisplay.celebration);
      expect(preview.badgeStyle.shape, isA<RoundedRectangleBorder>());
      expect(preview.celebrationStyle.backgroundColor, const Color(0xFFFFF7ED));
      expect(preview.flameStyle.borderWidth, 2);
      await tester.ensureVisible(find.text('Celebrate'));
      await tester.tap(find.text('Celebrate'));
      await tester.pumpAndSettle();
      final popup = tester.widget<StreakWidget>(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(StreakWidget),
        ),
      );
      expect(popup.badgeStyle.shape, isA<RoundedRectangleBorder>());
      expect(popup.flameStyle.borderWidth, 2);
      expect(popup.celebrationStyle.buttonBorderWidth, 2);
      await tester.tap(find.byTooltip('Close streak celebration').last);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      await tester.ensureVisible(find.byTooltip('Close streak celebration'));
      await tester.tap(find.byTooltip('Close streak celebration'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<StreakWidget>(find.byType(StreakWidget)).display,
        StreakDisplay.flame,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
