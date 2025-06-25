import 'package:flutter/material.dart';

/// Color definitions used for the app's dark theme.
///
/// These values mirror the configuration in `AppTheme.darkTheme`
/// and can be reused across the codebase when a direct reference to
/// a dark mode color is needed.
class DarkPalette {
  DarkPalette._();

  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryVariant = Color(0xFF2E7D32);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color secondaryVariant = Color(0xFF1565C0);
  static const Color background = Color(0xFF121212); // Material Design dark
  static const Color surface = Color(0xFF121212);
  static const Color error = Color(0xFFEF5350);
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFB74D);
  static const Color accent = Color(0xFFFF8F00);
  static const Color onPrimary = Color(0xFF000000);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFFE6E1E5);
  static const Color onSurface = Color(0xFFE6E1E5);
  static const Color onError = Color(0xFF000000);

  static const Color card = Color(0xFF1E1E1E);
  static const Color dialog = Color(0xFF2D2D2D);
  static const Color shadow = Color(0x1AFFFFFF);
  static const Color divider = Color(0x1FE6E1E5);
  static const Color textHighEmphasis = Color(0xDEE6E1E5);
  static const Color textMediumEmphasis = Color(0x99E6E1E5);
  static const Color textDisabled = Color(0x61E6E1E5);
}
