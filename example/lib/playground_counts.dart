import 'package:flutter/material.dart';

/// Form for trying arbitrary starting and target counts.
class PlaygroundCounts extends StatelessWidget {
  /// Creates the count controls.
  const PlaygroundCounts({
    required this.formKey,
    required this.oldCount,
    required this.newCount,
    required this.onApply,
    super.key,
  });

  /// Parent-owned validation key.
  final GlobalKey<FormState> formKey;

  /// Parent-owned starting-count editor.
  final TextEditingController oldCount;

  /// Parent-owned target-count editor.
  final TextEditingController newCount;

  /// Applies valid values.
  final VoidCallback onApply;

  String? _validate(String? input) {
    final count = int.tryParse(input?.trim() ?? '');
    return count == null || count < 0
        ? 'Enter a whole number of 0 or more'
        : null;
  }

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const ValueKey('old-count'),
          controller: oldCount,
          decoration: const InputDecoration(labelText: 'Starting count'),
          keyboardType: TextInputType.number,
          validator: _validate,
          onFieldSubmitted: (_) => onApply(),
        ),
        const SizedBox(height: 12),
        TextFormField(
          key: const ValueKey('new-count'),
          controller: newCount,
          decoration: const InputDecoration(labelText: 'Target count'),
          keyboardType: TextInputType.number,
          validator: _validate,
          onFieldSubmitted: (_) => onApply(),
        ),
        const SizedBox(height: 12),
        FilledButton(onPressed: onApply, child: const Text('Apply counts')),
      ],
    ),
  );
}
