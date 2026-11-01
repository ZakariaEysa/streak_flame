import 'package:flutter/material.dart';

/// Standard keyboard-accessible controls for test scenarios.
class PlaygroundActions extends StatelessWidget {
  /// Creates the scenario buttons.
  const PlaygroundActions({
    required this.onReplay,
    required this.onPause,
    required this.onResume,
    required this.onNextDay,
    required this.onRestart,
    required this.onClear,
    required this.onCelebrate,
    super.key,
  });

  /// Replays the current transition.
  final VoidCallback onReplay;

  /// Pauses the animation.
  final VoidCallback onPause;

  /// Resumes the animation.
  final VoidCallback onResume;

  /// Increases the count.
  final VoidCallback onNextDay;

  /// Simulates losing the streak and restarting at one.
  final VoidCallback onRestart;

  /// Simulates losing the streak and dropping to zero.
  final VoidCallback onClear;

  /// Opens the dialog with inherited playground settings.
  final ValueChanged<BuildContext> onCelebrate;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    spacing: 8,
    runSpacing: 8,
    children: [
      FilledButton(onPressed: onReplay, child: const Text('Replay')),
      OutlinedButton(onPressed: onPause, child: const Text('Pause')),
      OutlinedButton(onPressed: onResume, child: const Text('Resume')),
      OutlinedButton(onPressed: onNextDay, child: const Text('Next day')),
      OutlinedButton(onPressed: onRestart, child: const Text('Restart streak')),
      OutlinedButton(onPressed: onClear, child: const Text('Lose streak')),
      OutlinedButton(
        onPressed: () => onCelebrate(context),
        child: const Text('Celebrate'),
      ),
    ],
  );
}
