import 'package:flutter/material.dart';

/// Utility extension to modify color channel values conveniently.
extension ColorValuesExtension on Color {
  /// Returns a copy of this color with the provided channel overrides.
  Color withValues({int? alpha, int? red, int? green, int? blue}) {
    return Color.fromARGB(
      alpha ?? this.alpha,
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }
}
