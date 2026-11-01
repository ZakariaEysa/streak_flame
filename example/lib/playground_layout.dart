import 'package:flutter/material.dart';

/// Keeps the flame beside scrollable controls when enough width is available.
class PlaygroundLayout extends StatelessWidget {
  /// Creates the adaptive playground layout.
  const PlaygroundLayout({
    required this.flame,
    required this.actions,
    required this.counts,
    required this.settings,
    required this.messages,
    super.key,
  });

  /// Flame preview.
  final Widget flame;

  /// Scenario buttons.
  final Widget actions;

  /// Count form.
  final Widget counts;

  /// Visual and motion controls.
  final Widget settings;

  /// Message editors.
  final Widget messages;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final controls = [
        counts,
        const SizedBox(height: 24),
        settings,
        const SizedBox(height: 24),
        messages,
      ];
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: constraints.maxWidth >= 960
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(children: [flame, actions]),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        key: const ValueKey('playground-controls'),
                        padding: const EdgeInsets.all(24),
                        children: controls,
                      ),
                    ),
                  ],
                )
              : ListView(
                  key: const ValueKey('playground-controls'),
                  padding: const EdgeInsets.all(24),
                  children: [
                    flame,
                    actions,
                    const SizedBox(height: 24),
                    ...controls,
                  ],
                ),
        ),
      );
    },
  );
}
