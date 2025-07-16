import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme manager class to handle theme switching and persistence
class ThemeManager extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;
  bool _isDarkMode = false;
  SharedPreferences? _prefs;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeManager() {
    _loadThemePreference();
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final isDark = _prefs?.getBool(_themePreferenceKey) ?? false;
      _isDarkMode = isDark;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      // If loading fails, default to light theme
      _isDarkMode = false;
      _themeMode = ThemeMode.light;
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;

    try {
      await _prefs?.setBool(_themePreferenceKey, _isDarkMode);
    } catch (e) {
      // Handle preference saving error silently
      debugPrint('Failed to save theme preference: $e');
    }

    notifyListeners();
  }

  /// Set theme mode directly
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _isDarkMode = mode == ThemeMode.dark;

    try {
      await _prefs?.setBool(_themePreferenceKey, _isDarkMode);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
    }

    notifyListeners();
  }

  /// Set dark mode directly
  Future<void> setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    try {
      await _prefs?.setBool(_themePreferenceKey, _isDarkMode);
    } catch (e) {
      debugPrint('Failed to save theme preference: $e');
    }

    notifyListeners();
  }
}
