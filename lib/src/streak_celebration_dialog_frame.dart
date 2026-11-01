import 'package:flutter/material.dart';

/// Internal modal layout; visible appearance belongs to the inline card.
class StreakCelebrationDialogFrame extends StatelessWidget {
  /// Creates the internal presentation component.
  const StreakCelebrationDialogFrame({
    required this.maxWidth,
    required this.insetPadding,
    required this.child,
    super.key,
  });

  /// Configuration supplied by the shared widget.
  final double maxWidth;

  /// Configuration supplied by the shared widget.
  final EdgeInsets insetPadding;

  /// Configuration supplied by the shared widget.
  final Widget child;
  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    insetPadding: insetPadding,
    constraints: BoxConstraints(maxWidth: maxWidth),
    child: child,
  );
}
