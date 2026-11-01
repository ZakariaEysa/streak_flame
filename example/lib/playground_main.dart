import 'package:flutter/material.dart';
import 'main.dart';
import 'streak_demo_page.dart';

// ملف تشغيل منفصل لشاشة الإعدادات القديمة عند الحاجة.
// flutter run -t lib/playground_main.dart -d chrome
void main() => runApp(const StreakExampleApp(home: StreakDemoPage()));
