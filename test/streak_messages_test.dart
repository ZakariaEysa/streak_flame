import 'package:streak_flame/streak_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const messages = StreakStrings(
  title: 'Growing before',
  updatedTitle: 'Growing after',
  subtitle: 'Growing support',
  resetTitle: 'Restart before',
  resetUpdatedTitle: 'Restart after',
  resetSubtitle: 'Restart support',
);

Widget host(Widget child, {bool reduced = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Scaffold(body: child),
  ),
);

void main() {
  for (final scenario in [
    (name: 'decrease to one', old: 12, next: 1, override: null, reset: true),
    (name: 'decrease to zero', old: 12, next: 0, override: null, reset: true),
    (name: 'first increase', old: 0, next: 1, override: null, reset: false),
    (name: 'equal counts', old: 1, next: 1, override: null, reset: false),
    (
      name: 'explicit restart on increase',
      old: 0,
      next: 1,
      override: true,
      reset: true,
    ),
    (
      name: 'explicit restart on equal counts',
      old: 1,
      next: 1,
      override: true,
      reset: true,
    ),
    (
      name: 'explicit positive correction',
      old: 12,
      next: 1,
      override: false,
      reset: false,
    ),
  ]) {
    testWidgets('custom completed messages: ${scenario.name}', (tester) async {
      await tester.pumpWidget(
        host(
          StreakCelebrationDialog(
            oldStreak: scenario.old,
            newStreak: scenario.next,
            isStreakReset: scenario.override,
            strings: messages,
            animationsEnabled: false,
          ),
        ),
      );
      expect(
        find.text(scenario.reset ? 'Restart after' : 'Growing after'),
        findsOneWidget,
      );
      expect(
        find.text(scenario.reset ? 'Restart support' : 'Growing support'),
        findsOneWidget,
      );
      expect(
        find.text(scenario.reset ? 'Growing after' : 'Restart after'),
        findsNothing,
      );
      expect(
        find.text(scenario.reset ? 'Growing support' : 'Restart support'),
        findsNothing,
      );
    });
  }

  for (final reset in [false, true]) {
    testWidgets(
      'custom pre/post titles for ${reset ? 'restart' : 'increase'}',
      (tester) async {
        await tester.pumpWidget(
          host(
            StreakCelebrationDialog(
              oldStreak: 7,
              newStreak: reset ? 1 : 8,
              strings: messages,
              idleAnimationEnabled: false,
              transitionDelay: const Duration(milliseconds: 50),
              transitionDuration: const Duration(milliseconds: 100),
            ),
          ),
        );
        expect(
          find.text(reset ? 'Restart before' : 'Growing before'),
          findsOneWidget,
        );
        expect(
          find.text(reset ? 'Restart support' : 'Growing support'),
          findsOneWidget,
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();
        expect(
          find.text(reset ? 'Restart after' : 'Growing after'),
          findsOneWidget,
        );
        expect(
          find.text(reset ? 'Restart before' : 'Growing before'),
          findsNothing,
        );
      },
    );
  }

  testWidgets('reduced-motion restart displays completed custom wording', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const StreakCelebrationDialog(
          oldStreak: 7,
          newStreak: 1,
          strings: messages,
        ),
        reduced: true,
      ),
    );
    expect(find.text('Restart after'), findsOneWidget);
    expect(find.text('Restart before'), findsNothing);
    expect(find.text('Restart support'), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets(
    'wording follows live count and text changes on the same dialog',
    (tester) async {
      Widget dialog(int old, int next, {StreakStrings strings = messages}) =>
          host(
            StreakCelebrationDialog(
              oldStreak: old,
              newStreak: next,
              strings: strings,
              animationsEnabled: false,
            ),
          );
      await tester.pumpWidget(dialog(6, 7));
      expect(find.text('Growing after'), findsOneWidget);
      await tester.pumpWidget(dialog(7, 1));
      await tester.pump();
      expect(find.text('Restart after'), findsOneWidget);
      expect(find.text('Growing after'), findsNothing);
      await tester.pumpWidget(dialog(1, 2));
      await tester.pump();
      expect(find.text('Growing after'), findsOneWidget);
      expect(find.text('Restart after'), findsNothing);
      await tester.pumpWidget(
        dialog(
          1,
          2,
          strings: const StreakStrings(
            updatedTitle: 'Edited by the host',
            subtitle: 'Edited supporting text',
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Edited by the host'), findsOneWidget);
      expect(find.text('Edited supporting text'), findsOneWidget);
    },
  );

  testWidgets('show helper forwards reset override and custom strings', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => StreakCelebrationDialog.show(
                context,
                oldStreak: 0,
                newStreak: 1,
                isStreakReset: true,
                strings: messages,
                animationsEnabled: false,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Restart after'), findsOneWidget);
    expect(find.text('Restart support'), findsOneWidget);
    expect(find.text('Growing after'), findsNothing);
  });

  testWidgets(
    'default restart text is supportive rather than an increase message',
    (tester) async {
      await tester.pumpWidget(
        host(
          const StreakCelebrationDialog(
            oldStreak: 10,
            newStreak: 1,
            animationsEnabled: false,
          ),
        ),
      );
      expect(find.text('New streak, new start!'), findsOneWidget);
      expect(find.text('Streak updated!'), findsNothing);
      expect(
        find.text(
          'Your previous effort still counts. Take it one day at a time.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('reset messages can be translated in an RTL dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: StreakCelebrationDialog(
            oldStreak: 8,
            newStreak: 1,
            animationsEnabled: false,
            strings: StreakStrings(
              resetTitle: 'نبدأ من جديد',
              resetUpdatedTitle: 'بداية جديدة',
              resetSubtitle: 'كمل يوم بيوم',
            ),
          ),
        ),
      ),
    );
    expect(find.text('بداية جديدة'), findsOneWidget);
    expect(find.text('كمل يوم بيوم'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
