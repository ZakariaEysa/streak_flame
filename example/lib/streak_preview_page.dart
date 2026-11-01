import 'package:flutter/material.dart';
import 'package:streak_flame/streak_flame.dart';

/// صفحة تجربة مباشرة للباكدج؛ عدّل القيم هنا ثم اعمل hot reload.
class StreakPreviewPage extends StatelessWidget {
  /// ينشئ صفحة الشعلة من غير لوحة إعدادات خارجية.
  const StreakPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1) الأرقام: لو الرقم الجديد أقل، رسائل البداية الجديدة تظهر تلقائيًا.
    const previousStreak = 6;
    const currentStreak = 10;

    // 2) celebration = الشعلة داخل الكارت الكامل، flame = الشعلة والبادج فقط.
    const displayMode = StreakDisplay.celebration;
    const flameSize = 220.0;
    const celebrationMaxWidth = 400.0;

    // 3) ألوان جسم الشعلة والتوهج والجزيئات.
    // badge* تخص البادج اللي فيها الرقم، مش الكارت الخارجي.
    const flameAndBadgeColors = StreakPalette(
      flameBase: Color(0xFFDC2626), // أسفل الشعلة.
      flameMiddle: Color(0xFFEA580C), // وسط الشعلة.
      flameTip: Color(0xFFFBBF24), // رأس الشعلة.
      flameCore: Color(0xFFFFF9C4), // داخل الشعلة.
      flameGlow: Color(0x59FF9100), // هالة الشعلة؛ أول رقمين للشفافية.
      flameGlowSecondary: Color(0x1FDC2626),
      particlePrimary: Color(0xFFFBBF24),
      particleSecondary: Color(0xFFFF9100),

      // ألوان البادج مستقلة عن الشعلة والكارت.
      badgeBackground: Color(0xFF0F172A),
      badgeHighlight: Color(0xFF1B2335),
      badgeBorder: Color(0xFFFF9100),
      badgeGlow: Color(0x66FF9100),
      badgeOldNumber: Colors.white,
      badgeNumber: Color(0xFFFFF9C4),
      badgeLabel: Color(0xFFFDBA74),

      // اختياري: استبدل تدرّج أي طبقة أو البادج بالكامل.
      // outerFlameGradient: LinearGradient(colors: [Colors.blue, Colors.cyan]),
      // middleFlameGradient: LinearGradient(colors: [Colors.cyan, Colors.white]),
      // innerFlameGradient: LinearGradient(colors: [Colors.white, Colors.blue]),
      // badgeGradient: LinearGradient(colors: [Colors.white, Colors.pink]),
    );

    // 4) حدود وتأثيرات جسم الشعلة؛ الأبعاد بتكبر وتصغر مع flameSize.
    const flameAppearance = StreakFlameStyle(
      borderWidth: 0, // زوّدها مثلًا إلى 2 لإظهار حدود الشعلة.
      borderColor: Colors.orange,
      glowRadius: 98, // نصف قطر الهالة؛ 0 يخفيها.
      particleSize: 1, // معامل حجم الجزيئات.
    );

    // 5) شكل البادج اللي فيها الرقم.
    const badgeAppearance = StreakBadgeStyle(
      size: 116,
      offset: Offset.zero, // ده المركز المصحح؛ غيّره لتحريك البادج.
      borderWidth: 3.2, // 0 يخفي حدود الدائرة الافتراضية.
      padding: EdgeInsets.all(14),
      glowBlurRadius: 12,

      // شيل التعليق لتغيير الدائرة إلى مربع بزوايا.
      // shape بتغلب حدود الدائرة؛ حدّد لونها وعرضها في side.
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(24)),
      //   side: BorderSide(color: Colors.pink, width: 4),
      // ),

      // shadows: [], // شيل التعليق لإلغاء ظل البادج.
    );

    // 6) الشكل الخارجي فقط؛ المجموعة دي تظهر مع celebration.
    const celebrationAppearance = StreakCelebrationStyle(
      backgroundColor: Color(0xFF0F172A),
      borderColor: Color(0x59FF9100),
      borderWidth: 1,
      borderRadius: BorderRadius.all(Radius.circular(28)),
      padding: EdgeInsets.all(20),

      // الهيدر الصغير أعلى الكارت.
      headerBackgroundColor: Color(0x26FF9100),
      headerForegroundColor: Color(0xFFFDBA74),
      headerBorderWidth: 0,
      headerBorderColor: Colors.orange,
      headerBorderRadius: BorderRadius.all(Radius.circular(20)),

      // عنوان الاحتفال والوصف.
      titleColor: Colors.white,
      subtitleColor: Color(0xFFFDBA74),
      titleStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
      subtitleStyle: TextStyle(fontSize: 14, height: 1.5),

      // زر المتابعة وزر الإغلاق الخاصان بالكارت.
      buttonBackgroundColor: Color(0xFFFF9100),
      buttonForegroundColor: Color(0xFF0F172A),
      buttonBorderWidth: 0,
      buttonBorderColor: Colors.orange,
      buttonShape: StadiumBorder(),
      closeColor: Colors.white,

      // false يخفي الجزء المقابل.
      showHeader: true,
      showAction: true,
      showCloseButton: true,

      // اختياري: شكل الكارت أو تدرّج خلفيته أو ظلاله.
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(16)),
      //   side: BorderSide(color: Colors.pink, width: 2),
      // ),
      // backgroundGradient: LinearGradient(colors: [Colors.black, Colors.blue]),
      // shadows: [BoxShadow(color: Colors.black26, blurRadius: 16)],
    );

    // 7) الكلام: رسائل الزيادة ورسائل فقدان الاستريك منفصلين.
    const streakMessages = StreakStrings(
      day: 'يوم',
      days: 'أيام',
      badge: 'الاستريك اليومي',
      title: 'خلي الشعلة منورة!',
      updatedTitle: 'الاستريك زاد!',
      subtitle: 'كل يوم بيفرق. كمل!',
      resetTitle: 'نبدأ من جديد',
      resetUpdatedTitle: 'استريك جديد، بداية جديدة!',
      resetSubtitle: 'مجهودك اللي فات لسه له قيمة. كمل يوم بيوم.',
      button: 'كمل',
      dismissLabel: 'إغلاق الاحتفال',
    );

    // 8) الحركة: false يثبت الرقم الجديد فورًا، وidle يتحكم في الوميض المستمر.
    const enableAnimation = true;
    const enableIdleFlicker = true;
    const enableFlameGlow = true;
    const enableBurstParticles = true;

    // دي خلفية صفحة التجربة نفسها، مش خلفية البادج ولا الكارت.
    const pageBackgroundColor = Color(0xFF091222);

    return Directionality(
      textDirection: TextDirection.rtl, // غيّرها إلى ltr لو بتجرب كلام إنجليزي.
      child: Scaffold(
        backgroundColor: pageBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StreakWidget(
                oldStreak: previousStreak,
                newStreak: currentStreak,
                display: displayMode,
                size: flameSize,
                maxWidth: celebrationMaxWidth,
                palette: flameAndBadgeColors,
                flameStyle: flameAppearance,
                badgeStyle: badgeAppearance,
                celebrationStyle: celebrationAppearance,
                strings: streakMessages,
                // null يكتشف فقدان الاستريك من نقصان الرقم؛ true يفرض رسالة البداية.
                isStreakReset: null,
                // تغيير الخط هنا يحافظ على ألوان palette؛ مرّر color لتجاوزها.
                numberStyle: const TextStyle(fontWeight: FontWeight.w900),
                unitStyle: const TextStyle(fontSize: 16),
                animationsEnabled: enableAnimation,
                idleAnimationEnabled: enableIdleFlicker,
                showGlow: enableFlameGlow,
                showParticles: enableBurstParticles,
                particleCount: 28, // من 0 إلى 64.
                transitionDelay: const Duration(milliseconds: 700),
                transitionDuration: const Duration(milliseconds: 1400),
                idleDuration: const Duration(milliseconds: 2200),
                respectReducedMotion:
                    true, // احترم تقليل الحركة في إعدادات الجهاز.
                enableHaptics: false,
                onContinue: () {
                  // حط تصرف زر المتابعة هنا؛ صفحة التجربة تفضل ظاهرة افتراضيًا.
                },
                onClose: () {
                  // حط تصرف زر الإغلاق هنا؛ الصفحة مش popup.
                  // لو شلت onClose، زر الإغلاق مش هيظهر.
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
