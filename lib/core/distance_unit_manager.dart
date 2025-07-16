import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Distance unit manager class to handle distance unit switching and persistence
class DistanceUnitManager extends ChangeNotifier {
  static const String _distanceUnitPreferenceKey = 'distance_unit';

  bool _isMetric = false; // false for yards, true for metres
  SharedPreferences? _prefs;

  bool get isMetric => _isMetric;
  String get unitLabel => _isMetric ? 'metres' : 'yards';
  String get unitSymbol => _isMetric ? 'm' : 'y';

  DistanceUnitManager() {
    _loadDistanceUnitPreference();
  }

  /// Load distance unit preference from SharedPreferences
  Future<void> _loadDistanceUnitPreference() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final isMetric = _prefs?.getBool(_distanceUnitPreferenceKey) ?? false;
      _isMetric = isMetric;
      notifyListeners();
    } catch (e) {
      // If loading fails, default to yards
      _isMetric = false;
    }
  }

  /// Toggle between yards and metres
  Future<void> toggleDistanceUnit() async {
    _isMetric = !_isMetric;

    try {
      await _prefs?.setBool(_distanceUnitPreferenceKey, _isMetric);
    } catch (e) {
      // Handle preference saving error silently
      debugPrint('Failed to save distance unit preference: $e');
    }

    notifyListeners();
  }

  /// Set distance unit directly
  Future<void> setMetric(bool isMetric) async {
    _isMetric = isMetric;

    try {
      await _prefs?.setBool(_distanceUnitPreferenceKey, _isMetric);
    } catch (e) {
      debugPrint('Failed to save distance unit preference: $e');
    }

    notifyListeners();
  }

  /// Convert yards to metres
  int yardsToMetres(int yards) {
    return (yards * 0.9144).round();
  }

  /// Convert distance based on current unit preference
  int convertDistance(int yardsValue) {
    return _isMetric ? yardsToMetres(yardsValue) : yardsValue;
  }

  /// Get formatted distance string with unit
  String getFormattedDistance(int yardsValue) {
    final convertedValue = convertDistance(yardsValue);
    return '$convertedValue $unitLabel';
  }

  /// Get formatted distance string with unit for short display
  String getFormattedDistanceShort(int yardsValue) {
    final convertedValue = convertDistance(yardsValue);
    return '$convertedValue $unitSymbol';
  }
}
