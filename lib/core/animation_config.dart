import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Centralized animation configuration for mobile optimization
class AnimationConfig {
  AnimationConfig._();

  // Performance-based animation settings
  static bool get isHighPerformanceDevice {
    // In a real app, you'd check device specs
    return !kDebugMode;
  }

  // Base animation durations (optimized for mobile)
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration celebrationDuration = Duration(milliseconds: 800);

  // Curves optimized for mobile touch feedback
  static const Curve bounceInCurve = Curves.easeOutBack;
  static const Curve slideInCurve = Curves.easeOutCubic;
  static const Curve fadeInCurve = Curves.easeInOut;
  static const Curve scaleCurve = Curves.elasticOut;

  // Scale factors for different animation intensities
  static const double subtleScale = 0.05;
  static const double mediumScale = 0.1;
  static const double dramaticScale = 0.2;

  // Performance scaling based on device capabilities
  static Duration getScaledDuration(Duration baseDuration) {
    if (!isHighPerformanceDevice) {
      return Duration(
          milliseconds: (baseDuration.inMilliseconds * 0.7).round());
    }
    return baseDuration;
  }

  // Animation stagger delays for sequential animations
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static const Duration rippleDelay = Duration(milliseconds: 100);

  // Touch feedback constants
  static const Duration hapticDelay = Duration(milliseconds: 10);
  static const double touchScaleDown = 0.95;
  static const double touchScaleUp = 1.05;
}
