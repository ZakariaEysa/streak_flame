import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_flame/streak_flame.dart';

import '../example/lib/main.dart';

void main() {
  testWidgets('default example opens only the direct package preview', (
    tester,
  ) async {
    await tester.pumpWidget(const StreakExampleApp());
    expect(find.byType(StreakWidget), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);
    expect(find.byType(Slider), findsNothing);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Celebrate'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 3));
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets(
    'direct preview scrolls on a short narrow screen with large text',
    (tester) async {
      tester.view.physicalSize = const Size(240, 320);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const StreakExampleApp());
      await tester.ensureVisible(find.text('كمل'));
      await tester.pump();
      expect(find.text('كمل').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
