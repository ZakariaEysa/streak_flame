import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:streak_flame/streak_flame.dart';

import '../lib/main.dart';
import '../lib/streak_demo_page.dart';

Future<void> showPreview(WidgetTester tester) async {
  final controls = find.byKey(const ValueKey('playground-controls'));
  final scrollable = find
      .descendant(of: controls, matching: find.byType(Scrollable))
      .first;
  tester.state<ScrollableState>(scrollable).position.jumpTo(0);
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> reveal(WidgetTester tester, Finder target) async {
  await showPreview(tester);
  if (target.evaluate().isEmpty) {
    final controls = find.byKey(const ValueKey('playground-controls'));
    final scrollable = find
        .descendant(of: controls, matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(
      target,
      240,
      scrollable: scrollable,
      maxScrolls: 40,
    );
  }
  await tester.ensureVisible(target);
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> pressAction(WidgetTester tester, String label) async {
  final action = find.text(label);
  await reveal(tester, action);
  await tester.tap(action);
  await tester.pump(const Duration(milliseconds: 200));
}

Future<void> toggleSetting(WidgetTester tester, String label) async {
  final setting = find.widgetWithText(SwitchListTile, label);
  await reveal(tester, setting);
  await tester.tap(setting);
  await tester.pump(const Duration(milliseconds: 200));
}

StreakWidget preview(WidgetTester tester) =>
    tester.widget<StreakWidget>(find.byType(StreakWidget).first);

Future<void> openPlayground(WidgetTester tester) async {
  await tester.pumpWidget(const StreakExampleApp(home: StreakDemoPage()));
  await tester.pump(const Duration(seconds: 3));
}

Future<void> waitForMessage(WidgetTester tester, Finder message) async {
  for (var frame = 0; frame < 100 && message.evaluate().isEmpty; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('native replay, pause, resume, next day, and reset controls', (
    tester,
  ) async {
    await openPlayground(tester);
    expect(preview(tester).newStreak, 7);
    expect(preview(tester).palette.flameBase, const Color(0xFFDC2626));

    await pressAction(tester, 'Replay');
    await pressAction(tester, 'Pause');
    await showPreview(tester);
    expect(preview(tester).controller!.isPaused, isTrue);
    await pressAction(tester, 'Resume');
    await showPreview(tester);
    expect(preview(tester).controller!.isPaused, isFalse);

    await pressAction(tester, 'Next day');
    await showPreview(tester);
    expect(preview(tester).oldStreak, 7);
    expect(preview(tester).newStreak, 8);

    await pressAction(tester, 'Restart streak');
    await showPreview(tester);
    expect(preview(tester).oldStreak, 8);
    expect(preview(tester).newStreak, 1);
    expect(preview(tester).isStreakReset, isTrue);

    await pressAction(tester, 'Lose streak');
    await showPreview(tester);
    expect(preview(tester).newStreak, 0);
    expect(preview(tester).isStreakReset, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets(
    'native full card, modal actions, Arabic RTL, and reduced motion',
    (tester) async {
      await openPlayground(tester);
      await toggleSetting(tester, 'Full celebration preview');
      await showPreview(tester);
      expect(preview(tester).display, StreakDisplay.celebration);

      await pressAction(tester, 'Celebrate');
      await tester.pump(const Duration(milliseconds: 500));
      var dialog = find.byType(Dialog);
      expect(dialog, findsOneWidget);
      final completedMessage = find.descendant(
        of: dialog,
        matching: find.text('Streak updated!'),
      );
      await waitForMessage(tester, completedMessage);
      expect(
        completedMessage,
        findsOneWidget,
        reason: tester
            .widgetList<Text>(
              find.descendant(of: dialog, matching: find.byType(Text)),
            )
            .map((text) => text.data ?? text.textSpan?.toPlainText())
            .join(' | '),
      );
      var continueButton = find.descendant(
        of: dialog,
        matching: find.text('Continue'),
      );
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Dialog), findsNothing);

      await pressAction(tester, 'Celebrate');
      await tester.pump(const Duration(milliseconds: 500));
      dialog = find.byType(Dialog);
      final closeButton = find.descendant(
        of: dialog,
        matching: find.byTooltip('Close streak celebration'),
      );
      await tester.ensureVisible(closeButton);
      await tester.tap(closeButton);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Dialog), findsNothing);

      await toggleSetting(tester, 'Arabic / RTL');
      await toggleSetting(tester, 'Simulate reduced motion');
      await showPreview(tester);
      final previewContext = tester.element(find.byType(StreakWidget).first);
      expect(Directionality.of(previewContext), TextDirection.rtl);
      expect(MediaQuery.disableAnimationsOf(previewContext), isTrue);
      expect(preview(tester).palette.flameBase, const Color(0xFFDC2626));

      await pressAction(tester, 'Celebrate');
      await tester.pump(const Duration(milliseconds: 500));
      dialog = find.byType(Dialog);
      expect(dialog, findsOneWidget);
      expect(
        find.descendant(of: dialog, matching: find.text('الاستريك زاد!')),
        findsOneWidget,
      );
      continueButton = find.descendant(of: dialog, matching: find.text('كمل'));
      await tester.ensureVisible(continueButton);
      await tester.tap(continueButton);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(Dialog), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 200));
    },
  );
}
