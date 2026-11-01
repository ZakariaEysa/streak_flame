import 'package:streak_flame/streak_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dialog action dismisses once and forwards custom text', (
    tester,
  ) async {
    var dismissals = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => StreakCelebrationDialog.show(
                context,
                oldStreak: 2,
                newStreak: 3,
                animationsEnabled: false,
                strings: const StreakStrings(
                  button: 'Done',
                  updatedTitle: 'Great work',
                ),
                onDismiss: () => dismissals++,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Great work'), findsOneWidget);
    expect(find.byTooltip('Close streak celebration'), findsOneWidget);
    await tester.ensureVisible(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.byType(StreakCelebrationDialog), findsNothing);
    expect(dismissals, 1);
  });

  testWidgets('barrier and close button both invoke dismissal', (tester) async {
    var dismissals = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => StreakCelebrationDialog.show(
                context,
                oldStreak: 0,
                newStreak: 1,
                animationsEnabled: false,
                onDismiss: () => dismissals++,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Close streak celebration'));
    await tester.pumpAndSettle();
    expect(dismissals, 1);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    expect(dismissals, 2);
  });

  testWidgets(
    'narrow short RTL viewport with large text scrolls without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(240, 320);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.5)),
            child: const Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: StreakCelebrationDialog(
                  oldStreak: 0,
                  newStreak: 1,
                  animationsEnabled: false,
                  strings: StreakStrings(
                    day: 'يوم',
                    days: 'أيام',
                    badge: 'الاستريك اليومي',
                    title: 'كمل',
                    updatedTitle: 'كل يوم بيفرق',
                    subtitle: 'استمر كل يوم',
                    button: 'متابعة',
                    dismissLabel: 'إغلاق',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('متابعة'));
      expect(tester.takeException(), isNull);
      expect(find.text('متابعة'), findsOneWidget);
    },
  );

  testWidgets('modal preserves local RTL and accessibility preferences', (
    tester,
  ) async {
    var completions = 0;
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
                  onPressed: () => StreakCelebrationDialog.show(
                    context,
                    oldStreak: 1,
                    newStreak: 2,
                    onTransitionComplete: () => completions++,
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
    final dialogContext = tester.element(find.byType(StreakCelebrationDialog));
    expect(Directionality.of(dialogContext), TextDirection.rtl);
    expect(MediaQuery.textScalerOf(dialogContext).scale(10), 20);
    expect(find.text('2'), findsOneWidget);
    expect(completions, 1);
    expect(tester.binding.transientCallbackCount, 0);
  });
  testWidgets('custom header and footer replace defaults', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StreakCelebrationDialog(
            oldStreak: 3,
            newStreak: 3,
            animationsEnabled: false,
            header: Text('Custom header'),
            footer: Text('Custom action'),
          ),
        ),
      ),
    );
    expect(find.text('Custom header'), findsOneWidget);
    expect(find.text('Custom action'), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
  });
}
