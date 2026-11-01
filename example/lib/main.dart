import 'package:flutter/material.dart';
import 'streak_preview_page.dart';

/// تشغيل صفحة التجربة المباشرة. عدّل الباراميترز في streak_preview_page.dart.
void main() => runApp(const StreakExampleApp());

/// Example application with a direct package preview by default.
class StreakExampleApp extends StatelessWidget {
  /// Creates the example app; an alternate home can host the optional playground.
  const StreakExampleApp({this.home = const StreakPreviewPage(), super.key});

  /// Page to display. The default preview has no external settings controls.
  final Widget home;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorSchemeSeed: Colors.orange,
      brightness: Brightness.dark,
    ),
    home: home,
  );
}
