import 'package:flutter/material.dart';

/// A labeled standard slider for a playground setting.
class PlaygroundSlider extends StatelessWidget {
  /// Creates a slider with a visible value.
  const PlaygroundSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.unit = '',
    super.key,
  });

  /// Accessible setting label.
  final String label;

  /// Current value.
  final double value;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete intervals.
  final int divisions;

  /// Change handler.
  final ValueChanged<double> onChanged;

  /// Display unit.
  final String unit;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$label: ${value.toStringAsFixed(unit == 'x' ? 1 : 0)}$unit'),
      Slider(
        key: ValueKey(label),
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: '${value.toStringAsFixed(1)}$unit',
        semanticFormatterCallback: (value) => '$label: $value$unit',
        onChanged: onChanged,
      ),
    ],
  );
}
