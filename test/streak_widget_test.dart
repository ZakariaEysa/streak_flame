import 'package:streak_flame/streak_flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {bool reduced = false, bool tickers = true}) =>
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: TickerMode(
          enabled: tickers,
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );

void main() {
  test('rejects invalid counts, sizes, durations and particle budgets', () {
    expect(
      () => BigStreakFlameWidget(oldStreak: -1, newStreak: 1),
      throwsAssertionError,
    );
    expect(
      () => BigStreakFlameWidget(
        oldStreak: 0,
        newStreak: 1,
        size: double.infinity,
      ),
      throwsAssertionError,
    );

    expect(
      () => BigStreakFlameWidget(oldStreak: 0, newStreak: 1, particleCount: 65),
      throwsAssertionError,
    );
  });

  testWidgets('invalid duration is rejected before animation starts', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const BigStreakFlameWidget(
          oldStreak: 0,
          newStreak: 1,
          transitionDuration: Duration.zero,
        ),
      ),
    );
    expect(tester.takeException(), isArgumentError);
  });
  testWidgets('transitions once and responds to changed counts', (
    tester,
  ) async {
    var completions = 0;
    Widget flame(int oldCount, int count) => BigStreakFlameWidget(
      oldStreak: oldCount,
      newStreak: count,
      idleAnimationEnabled: false,
      transitionDelay: Duration.zero,
      transitionDuration: const Duration(milliseconds: 100),
      onTransitionComplete: () => completions++,
    );
    await tester.pumpWidget(host(flame(7, 8)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('8'), findsOneWidget);
    expect(find.text('7'), findsNothing);
    expect(completions, 1);
    await tester.pumpWidget(host(flame(8, 9)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('9'), findsOneWidget);
    expect(completions, 2);
    await tester.pump(const Duration(seconds: 1));
    expect(completions, 2);
  });

  testWidgets('reduced motion finishes immediately with one callback', (
    tester,
  ) async {
    var completions = 0;
    await tester.pumpWidget(
      host(
        BigStreakFlameWidget(
          oldStreak: 0,
          newStreak: 1,
          onTransitionComplete: () => completions++,
        ),
        reduced: true,
      ),
    );
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(find.text('day'), findsOneWidget);
    expect(completions, 1);
    await tester.pump(const Duration(seconds: 2));
    expect(completions, 1);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('manual replay works and pause retains progress', (tester) async {
    final controller = StreakAnimationController();
    addTearDown(controller.dispose);
    var completions = 0;
    await tester.pumpWidget(
      host(
        BigStreakFlameWidget(
          oldStreak: 2,
          newStreak: 3,
          autoStart: false,
          idleAnimationEnabled: false,
          controller: controller,
          transitionDuration: const Duration(milliseconds: 200),
          onTransitionComplete: () => completions++,
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('2'), findsOneWidget);
    expect(completions, 0);
    controller.replay();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    controller.pause();
    await tester.pump(const Duration(seconds: 1));
    expect(completions, 0);
    controller.resume();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('3'), findsOneWidget);
    expect(completions, 1);
    controller.replay();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(completions, 2);
  });

  testWidgets('obsolete delayed transitions are cancelled on count update', (
    tester,
  ) async {
    var completions = 0;
    Widget flame(int count) => BigStreakFlameWidget(
      oldStreak: count - 1,
      newStreak: count,
      idleAnimationEnabled: false,
      transitionDelay: const Duration(milliseconds: 500),
      transitionDuration: const Duration(milliseconds: 100),
      onTransitionComplete: () => completions++,
    );
    await tester.pumpWidget(host(flame(4)));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpWidget(host(flame(5)));
    await tester.pump(const Duration(milliseconds: 250));
    expect(completions, 0);
    expect(find.text('4'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('5'), findsOneWidget);
    expect(completions, 1);
  });

  testWidgets(
    'disposal cancels pending work and detaches external controller',
    (tester) async {
      final controller = StreakAnimationController();
      addTearDown(controller.dispose);
      var completions = 0;
      await tester.pumpWidget(
        host(
          BigStreakFlameWidget(
            oldStreak: 0,
            newStreak: 1,
            controller: controller,
            onTransitionComplete: () => completions++,
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox());
      controller.replay();
      await tester.pump(const Duration(seconds: 3));
      expect(completions, 0);
      expect(tester.takeException(), isNull);
      expect(tester.binding.transientCallbackCount, 0);
    },
  );

  testWidgets('disabled TickerMode retains a transition until visible', (
    tester,
  ) async {
    var completions = 0;
    final flame = BigStreakFlameWidget(
      oldStreak: 1,
      newStreak: 2,
      idleAnimationEnabled: false,
      transitionDelay: Duration.zero,
      transitionDuration: const Duration(milliseconds: 100),
      onTransitionComplete: () => completions++,
    );
    await tester.pumpWidget(host(flame, tickers: false));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('1'), findsOneWidget);
    expect(completions, 0);
    await tester.pumpWidget(host(flame));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(completions, 1);
  });

  testWidgets('background lifecycle pauses motion and resumes safely', (
    tester,
  ) async {
    var completions = 0;
    await tester.pumpWidget(
      host(
        BigStreakFlameWidget(
          oldStreak: 1,
          newStreak: 2,
          idleAnimationEnabled: false,
          transitionDelay: Duration.zero,
          transitionDuration: const Duration(milliseconds: 200),
          onTransitionComplete: () => completions++,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(seconds: 1));
    expect(completions, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(completions, 1);
  });

  testWidgets(
    'localized numbers and plural rules have stable accessible text',
    (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        host(
          BigStreakFlameWidget(
            oldStreak: 1,
            newStreak: 2,
            animationsEnabled: false,
            numberFormatter: (count) => count == 2 ? '٢' : '١',
            unitLabelBuilder: (count) => count == 2 ? 'يومين' : 'يوم',
          ),
        ),
      );
      expect(find.text('٢'), findsOneWidget);
      expect(find.text('يومين'), findsOneWidget);
      expect(find.bySemanticsLabel('٢ يومين'), findsOneWidget);
      semantics.dispose();
    },
  );

  testWidgets('idle frames do not rebuild count content', (tester) async {
    var formatCalls = 0;
    await tester.pumpWidget(
      host(
        BigStreakFlameWidget(
          oldStreak: 4,
          newStreak: 4,
          numberFormatter: (count) {
            formatCalls++;
            return '$count';
          },
        ),
      ),
    );
    final initialCalls = formatCalls;
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(formatCalls, initialCalls);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('disabling motion during a transition completes exactly once', (
    tester,
  ) async {
    var completions = 0;
    Widget flame(bool enabled) => BigStreakFlameWidget(
      oldStreak: 8,
      newStreak: 9,
      animationsEnabled: enabled,
      idleAnimationEnabled: false,
      transitionDelay: Duration.zero,
      transitionDuration: const Duration(milliseconds: 500),
      onTransitionComplete: () => completions++,
    );
    await tester.pumpWidget(host(flame(true)));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.pumpWidget(host(flame(false)));
    expect(find.text('9'), findsOneWidget);
    expect(completions, 1);
    await tester.pumpWidget(host(flame(true)));
    await tester.pump(const Duration(seconds: 1));
    expect(completions, 1);
  });

  testWidgets('swapping controllers detaches old replay commands', (
    tester,
  ) async {
    final first = StreakAnimationController();
    final second = StreakAnimationController();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    Widget flame(StreakAnimationController controller) => BigStreakFlameWidget(
      oldStreak: 1,
      newStreak: 2,
      autoStart: false,
      idleAnimationEnabled: false,
      controller: controller,
      transitionDuration: const Duration(milliseconds: 100),
    );
    await tester.pumpWidget(host(flame(first)));
    first.replay();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpWidget(host(flame(second)));
    first.replay();
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    second.replay();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('disposing an active transition suppresses completion', (
    tester,
  ) async {
    var completions = 0;
    await tester.pumpWidget(
      host(
        BigStreakFlameWidget(
          oldStreak: 1,
          newStreak: 2,
          transitionDelay: Duration.zero,
          onTransitionComplete: () => completions++,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    expect(completions, 0);
    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });
  testWidgets('explicit reduced-motion override keeps configured timing', (
    tester,
  ) async {
    var completions = 0;
    await tester.pumpWidget(
      host(
        BigStreakFlameWidget(
          oldStreak: 1,
          newStreak: 2,
          respectReducedMotion: false,
          idleAnimationEnabled: false,
          transitionDelay: Duration.zero,
          transitionDuration: const Duration(milliseconds: 200),
          onTransitionComplete: () => completions++,
        ),
        reduced: true,
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));
    expect(completions, 0);
    await tester.pump(const Duration(milliseconds: 250));
    expect(completions, 1);
  });
  testWidgets('fits tiny bounds with large counts and scaled text', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: BigStreakFlameWidget(
                oldStreak: 999999,
                newStreak: 1000000,
                animationsEnabled: false,
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('1000000'), findsOneWidget);
    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byType(BigStreakFlameWidget));
    expect(size.width, lessThanOrEqualTo(100));
    expect(size.height, lessThanOrEqualTo(100));
  });
}
