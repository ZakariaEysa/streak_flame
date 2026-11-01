# تشغيل الفليم كمشروع مستقل

خد **فولدر الباكدج بالكامل**، أو فك ملف ZIP الجاهز، وافتح الفولدر
في المكان الجديد. احتفظ بفولدر example جوّه الباكدج؛ الديمو بيستخدم path: ../
للباكدج المحلية، ومش محتاج أي ملف من chatappdify.
اسم الباكدج المعتمد هو streak_flame؛ اسم فولدر النسخة المحلية لسه
streak_flame_package، واسم الفولدر مش لازم يطابق اسم الباكدج.

## تشغيل سريع

لازم Flutter يكون متسطّب ومضاف إلى PATH. أقل نسخة معلنة: Flutter 3.38 وDart 3.10؛
التحقق الحالي على Flutter 3.44 / Dart 3.12. اتأكد بالأمر flutter doctor.

من ترمينال جوّه فولدر الباكدج:

```sh
flutter pub get
cd example
flutter pub get
flutter run -d chrome
```

على Windows تقدر تشغل نفس الخطوات بأمر واحد، من أي مسار:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\playground.ps1
```

الأمر بيشغّل Chrome افتراضيًا. استبدله بـ -Device edge أو -Device windows،
أو اكتب ID الموبايل بعد flutter devices. السكريبت مش بيغيّر إعدادات الجهاز العامة.

## صفحة تجربة مباشرة بدون إعدادات

التشغيل الافتراضي وF5 يفتحوا StreakPreviewPage. الصفحة بتستدعي الباكدج مباشرة؛
كل القيم والتعليقات بالعربي في example/lib/streak_preview_page.dart.
غيّر previousStreak / currentStreak، واختار displayMode بين flame وcelebration،
وعدّل flameAndBadgeColors / flameAppearance / badgeAppearance / celebrationAppearance
وstreakMessages من نفس الملف، ثم اعمل hot reload.

لو احتجت شاشة الإعدادات القديمة، من داخل example:

```sh
flutter run -t lib/playground_main.dart -d chrome
```

## VS Code

افتح فولدر الباكدج نفسه. ثبّت إضافتي Dart وFlutter لو مش موجودين.
من Run and Debug اختار
Streak playground (Chrome) واضغط F5. التجهيز بيشتغل تلقائيًا قبل الديمو. أو اختار choose device لتجربة موبايل.

## الويدجت الموحدة والتخصيص

استخدم StreakWidget وعدّل display بين StreakDisplay.flame وStreakDisplay.celebration.
كل إعدادات الشكل اختيارية. [دليل الباراميترز](doc/CUSTOMIZATION.md) بيفصل ألوان
الشعلة والبادج عن الكارت الخارجي والهيدر والزر، مع أمثلة كاملة.

في شاشة الإعدادات الاختيارية فعّل Full celebration preview للشكل الكامل، وRounded square badge
لتغيير البادج، وCustom frame / borders لتجربة ألوان وحدود مستقلة. Celebrate
يفتح نفس الإعدادات كـpopup. مرّر قيمك من example/lib/streak_demo_page.dart.

## تعدّل إيه وفين؟

- lib/src/streak_widget.dart: الواجهة الموحدة واختيار الشعلة أو الاحتفال.
- lib/src/streak_flame_style.dart وstreak_badge_style.dart وstreak_celebration_style.dart: إعدادات الشكل الاختيارية.
- lib/src/streak_flame_painter.dart: شكل ومسارات الفليم والحركة المرسومة.
- lib/src/big_streak_flame_widget.dart: التوقيت والتحكم وتركيب الفليم والبادج.
- lib/src/streak_badge.dart: شكل البادج والنصوص.
- lib/src/streak_palette.dart: الألوان والـgradients.
- lib/src/streak_strings.dart: رسائل النجاح وإعادة البداية.
- example/lib/streak_demo_page.dart: قيم وتجارب الديمو.

التعديلات في lib بتظهر في الديمو لأنه بيستخدم النسخة المحلية مباشرة.
أثناء flutter run اضغط r للـhot reload وR لإعادة التشغيل وq للإغلاق.
بعد تغيير constructors أو إعدادات البداية جرّب R لو الـhot reload احتفظ بالحالة القديمة.

## تجارب موجودة في شاشة الإعدادات الاختيارية

على الشاشة الواسعة، الفليم ثابتة بجانب إعدادات بتعمل scroll. على الشاشة الضيقة،
المحتوى كله قابل للـscroll.

- أي رقم قديم وجديد: زيادة، نقصان، صفر، نفس الرقم، وأرقام كبيرة.
- Replay / Pause / Resume وNext day وRestart streak وLose streak.
- Celebrate لفتح الديالوج بنفس الإعدادات.
- تغيير حجم الفليم، مدة الحركة، التأخير، مدة idle وعدد الجزيئات حتى 64.
- تشغيل وإيقاف idle وglow والجزيئات والأنيميشن.
- محاكاة reduced motion وتكبير النص حتى 3x وتجربة العربي وRTL.
- ألوان الفليم والبادج بشكل مستقل.
- تعديل رسالتي الزيادة والبداية الجديدة. النص الفاضي يستخدم اللغة الافتراضية.

لألوان أو رسائل أكثر، أو gradients مخصصة، شوف أمثلة README.md.

## الاختبارات والبناء

من جذر الفولدر:

```sh
flutter analyze --no-pub
flutter test --no-pub test/streak_widget_test.dart test/streak_unified_test.dart test/streak_refactor_test.dart test/streak_dialog_test.dart test/streak_messages_test.dart test/streak_palette_test.dart test/streak_playground_test.dart test/streak_preview_page_test.dart test/visual_preview_test.dart
cd example
flutter build web --no-pub
```

أو على Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\playground.ps1 -Action check -BuildWeb
```

check بيشغّل تجهيز الاعتمادات والتحليل وكل اختبارات الباكدج فقط.
الاختبارات بتغطي التحكم والحالات والرسائل والألوان والـRTL والـlayout والتنظيف
بعد الإغلاق، لكن اختبار الأداء الفعلي محتاج جهاز وتشغيل profile؛ شوف doc/PERFORMANCE.md.

ملفات التشغيل موجودة لـweb وAndroid وiOS وWindows وLinux وmacOS.
الأجهزة الأصلية محتاجة أدوات منصتها: Android SDK والرخص، Visual Studio C++
على Windows، وXcode على macOS لـiOS. ملفات المنصة وحدها مش إثبات إن البناء نجح.
شوف آخر نتائج وحدود التحقق في doc/VALIDATION.md.

## نسخة سهلة النقل

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\playground.ps1 -Action pack
```

الناتج: build/portable/streak_flame.zip. يحتوي السورس والديمو والاختبارات
وملفات التشغيل والإرشادات. يستبعد build و.dart_tool والـcaches وملفات مسارات
الـSDK المحلية. السكريبت يجدد الأرشيف من أحدث تعديلاتك.

لو بتنسخ الفولدر يدويًا، متحتاجش تنقل build أو .dart_tool أو example/build أو
example/.dart_tool أو example/android/local.properties. شغّل pub get من جديد
في المكان الجديد عشان ملفات الأدوات تتولد بمساراته.

كل ده للاستخدام المحلي؛ مش محتاج نشر على pub.dev عشان تجرب.
