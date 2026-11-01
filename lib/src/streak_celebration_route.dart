import 'dart:ui';
import 'package:flutter/material.dart';
import 'streak_strings.dart';

/// Internal shared route, preserving the caller's accessibility preferences.
Future<void> showStreakCelebrationRoute(
  BuildContext context, {
  required WidgetBuilder builder,
  required StreakStrings strings,
  required bool animationsEnabled,
  required bool respectReducedMotion,
  required bool barrierDismissible,
  required bool useRootNavigator,
  required Color barrierColor,
  required double blurSigma,
  VoidCallback? onDismiss,
}) async {
  if (!blurSigma.isFinite || blurSigma < 0)
    throw ArgumentError.value(
      blurSigma,
      'blurSigma',
      'Must be finite and nonnegative',
    );
  final direction = Directionality.of(context);
  final textScaler = MediaQuery.textScalerOf(context);
  final hostReduced = MediaQuery.disableAnimationsOf(context);
  final reduced = !animationsEnabled || (respectReducedMotion && hostReduced);
  await showGeneralDialog<void>(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: barrierDismissible,
    barrierLabel: strings.dismissLabel,
    barrierColor: barrierColor,
    transitionDuration: reduced
        ? Duration.zero
        : const Duration(milliseconds: 380),
    pageBuilder: (routeContext, animation, secondaryAnimation) => MediaQuery(
      data: MediaQuery.of(routeContext).copyWith(
        textScaler: textScaler,
        disableAnimations:
            hostReduced || MediaQuery.disableAnimationsOf(routeContext),
      ),
      child: Directionality(
        textDirection: direction,
        child: SafeArea(
          child: blurSigma == 0
              ? builder(routeContext)
              : BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: builder(routeContext),
                ),
        ),
      ),
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation
                .drive(CurveTween(curve: Curves.easeOutCubic))
                .drive(Tween<double>(begin: 0.9, end: 1)),
            child: child,
          ),
        ),
  );
  onDismiss?.call();
}
