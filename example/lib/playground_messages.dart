import 'package:flutter/material.dart';

/// Edits the two completed-state messages used by the dialog.
class PlaygroundMessages extends StatelessWidget {
  /// Creates the message editors.
  const PlaygroundMessages({
    required this.positive,
    required this.restart,
    super.key,
  });

  /// Parent-owned positive title. Empty uses the language default.
  final TextEditingController positive;

  /// Parent-owned restart title. Empty uses the language default.
  final TextEditingController restart;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Dialog messages', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      const Text('Leave blank to use the selected language defaults.'),
      TextField(
        key: const ValueKey('positive-message'),
        controller: positive,
        decoration: const InputDecoration(labelText: 'Increase message'),
        maxLength: 200,
        maxLines: 2,
      ),
      TextField(
        key: const ValueKey('restart-message'),
        controller: restart,
        decoration: const InputDecoration(labelText: 'Restart message'),
        maxLength: 200,
        maxLines: 2,
      ),
    ],
  );
}
