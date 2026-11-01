import 'package:flutter/material.dart';

import 'playground_slider.dart';

/// Named boolean settings for the demo, independent of package state.
enum PlaygroundToggle {
  /// Render the full card in the preview.
  full,

  /// Replace the round count badge with a rounded square.
  roundedBadge,

  /// Demonstrate independent card/button/header and flame outline styling.
  customFrame,

  /// Preview RTL and Arabic labels.
  arabic,

  /// Use the blue flame palette.
  blue,

  /// Use the light badge palette.
  lightBadge,

  /// Enable motion.
  motion,

  /// Enable idle flickering.
  idle,

  /// Enable the halo.
  glow,

  /// Enable particles.
  burst,

  /// Simulate system reduced motion.
  reduced,
}

/// Numeric settings for the demo.
enum PlaygroundRange {
  /// Flame width.
  size,

  /// Transition duration.
  duration,

  /// Transition delay.
  delay,

  /// Idle duration.
  idleDuration,

  /// Particle budget.
  particles,

  /// Accessibility text scale.
  textScale,
}

/// Immutable snapshot of the parent-owned playground settings.
typedef PlaygroundValues = ({
  bool full,
  bool roundedBadge,
  bool customFrame,
  bool arabic,
  bool blue,
  bool lightBadge,
  bool motion,
  bool idle,
  bool glow,
  bool burst,
  bool reduced,
  double size,
  double duration,
  double delay,
  double idleDuration,
  double particles,
  double textScale,
});

/// Theme, motion, timing, and accessibility controls.
class PlaygroundSettings extends StatelessWidget {
  /// Creates the settings section.
  const PlaygroundSettings({
    required this.values,
    required this.onToggle,
    required this.onRange,
    super.key,
  });

  /// Current parent-owned values.
  final PlaygroundValues values;

  /// Changes a boolean option.
  final void Function(PlaygroundToggle setting, bool value) onToggle;

  /// Changes a numeric option.
  final void Function(PlaygroundRange setting, double value) onRange;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SwitchListTile(
        title: const Text('Full celebration preview'),
        value: values.full,
        onChanged: (value) => onToggle(PlaygroundToggle.full, value),
      ),
      SwitchListTile(
        title: const Text('Rounded square badge'),
        value: values.roundedBadge,
        onChanged: (value) => onToggle(PlaygroundToggle.roundedBadge, value),
      ),
      SwitchListTile(
        title: const Text('Custom frame / borders'),
        value: values.customFrame,
        onChanged: (value) => onToggle(PlaygroundToggle.customFrame, value),
      ),
      SwitchListTile(
        title: const Text('Arabic / RTL'),
        value: values.arabic,
        onChanged: (value) => onToggle(PlaygroundToggle.arabic, value),
      ),
      SwitchListTile(
        title: const Text('Blue palette'),
        value: values.blue,
        onChanged: (value) => onToggle(PlaygroundToggle.blue, value),
      ),
      SwitchListTile(
        title: const Text('Light badge / pink border'),
        value: values.lightBadge,
        onChanged: (value) => onToggle(PlaygroundToggle.lightBadge, value),
      ),
      SwitchListTile(
        title: const Text('Animations'),
        value: values.motion,
        onChanged: (value) => onToggle(PlaygroundToggle.motion, value),
      ),
      SwitchListTile(
        title: const Text('Idle flicker'),
        value: values.idle,
        onChanged: (value) => onToggle(PlaygroundToggle.idle, value),
      ),
      SwitchListTile(
        title: const Text('Flame glow'),
        value: values.glow,
        onChanged: (value) => onToggle(PlaygroundToggle.glow, value),
      ),
      SwitchListTile(
        title: const Text('Burst particles'),
        value: values.burst,
        onChanged: (value) => onToggle(PlaygroundToggle.burst, value),
      ),
      SwitchListTile(
        title: const Text('Simulate reduced motion'),
        value: values.reduced,
        onChanged: (value) => onToggle(PlaygroundToggle.reduced, value),
      ),
      const SizedBox(height: 12),
      PlaygroundSlider(
        label: 'Flame size',
        value: values.size,
        min: 80,
        max: 360,
        divisions: 28,
        unit: ' px',
        onChanged: (value) => onRange(PlaygroundRange.size, value),
      ),
      PlaygroundSlider(
        label: 'Transition duration',
        value: values.duration,
        min: 100,
        max: 3000,
        divisions: 29,
        unit: ' ms',
        onChanged: (value) => onRange(PlaygroundRange.duration, value),
      ),
      PlaygroundSlider(
        label: 'Transition delay',
        value: values.delay,
        min: 0,
        max: 2000,
        divisions: 20,
        unit: ' ms',
        onChanged: (value) => onRange(PlaygroundRange.delay, value),
      ),
      PlaygroundSlider(
        label: 'Idle duration',
        value: values.idleDuration,
        min: 400,
        max: 4000,
        divisions: 36,
        unit: ' ms',
        onChanged: (value) => onRange(PlaygroundRange.idleDuration, value),
      ),
      PlaygroundSlider(
        label: 'Particles',
        value: values.particles,
        min: 0,
        max: 64,
        divisions: 64,
        onChanged: (value) => onRange(PlaygroundRange.particles, value),
      ),
      PlaygroundSlider(
        label: 'Text scale',
        value: values.textScale,
        min: 1,
        max: 3,
        divisions: 20,
        unit: 'x',
        onChanged: (value) => onRange(PlaygroundRange.textScale, value),
      ),
      const SizedBox(height: 24),
    ],
  );
}
