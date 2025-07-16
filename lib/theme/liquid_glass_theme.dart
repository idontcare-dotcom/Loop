import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './app_theme.dart';

// Import to use standardized colors

/// Liquid Glass Design Language implementation for Loop Golf
/// Features translucent, glass-like UI elements with dynamic lighting effects
class LiquidGlassTheme {
  LiquidGlassTheme._();

  // Liquid Glass Color Palette - Updated to use standardized colors
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassBlack = Color(0xFF000000);
  static const Color glassPrimary = AppTheme.primaryBackground; // #2F3130
  static const Color glassSecondary = Color(0xFF1565C0);
  static const Color glassAccent =
      AppTheme.accentGreen; // #31C177 for Book New Round

  // Glass opacity levels for layering
  static const double glassOpacityPrimary = 0.15;
  static const double glassOpacitySecondary = 0.1;
  static const double glassOpacityTertiary = 0.05;

  // Blur intensities for depth
  static const double blurIntensityHigh = 20.0;
  static const double blurIntensityMedium = 12.0;
  static const double blurIntensityLow = 6.0;

  /// Creates a glass morphism container with translucent background
  static Widget glassContainer({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 20.0,
    double opacity = glassOpacityPrimary,
    double blurIntensity = blurIntensityMedium,
    Color? backgroundColor,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
        width: width,
        height: height,
        margin: margin,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurIntensity, sigmaY: blurIntensity),
                child: Container(
                    padding: padding,
                    decoration: BoxDecoration(
                        color: (backgroundColor ?? glassWhite)
                            .withOpacity(opacity),
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: border ??
                            Border.all(
                                color: glassWhite.withAlpha(51), width: 1.0),
                        boxShadow: boxShadow ??
                            [
                              BoxShadow(
                                  color: glassBlack.withAlpha(26),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8)),
                              BoxShadow(
                                  color: glassWhite.withAlpha(204),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1)),
                            ]),
                    child: child))));
  }

  /// Creates a glass card with enhanced depth and lighting
  static Widget glassCard({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 24.0,
    VoidCallback? onTap,
    bool elevated = true,
  }) {
    return Container(
        width: width,
        height: height,
        margin: margin,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurIntensityHigh, sigmaY: blurIntensityHigh),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFF8F9FA),
                              AppTheme.primaryBackground
                                  .withAlpha(13), // Use consistent method
                              LiquidGlassTheme.glassSecondary.withAlpha(8),
                              const Color(0xFFFFFFFF),
                            ]),
                        border: Border.all(
                            color: glassWhite.withAlpha(77), width: 1.5),
                        boxShadow: elevated
                            ? [
                                BoxShadow(
                                    color: glassBlack.withAlpha(38),
                                    blurRadius: 32,
                                    offset: const Offset(0, 16)),
                                BoxShadow(
                                    color: glassWhite.withAlpha(230),
                                    blurRadius: 2,
                                    offset: const Offset(0, 2)),
                              ]
                            : null),
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(borderRadius),
                            splashColor: glassWhite.withAlpha(26),
                            highlightColor: glassWhite.withAlpha(13),
                            child: Container(
                                padding: padding ?? const EdgeInsets.all(20),
                                child: child)))))));
  }

  /// Creates a glass button with dynamic lighting effects
  static Widget glassButton({
    required Widget child,
    required VoidCallback onPressed,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    double borderRadius = 16.0,
    Color? backgroundColor,
    bool isPrimary = false,
  }) {
    final bgColor = backgroundColor ?? (isPrimary ? glassPrimary : glassWhite);

    return SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurIntensityMedium, sigmaY: blurIntensityMedium),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              bgColor.withAlpha(77),
                              bgColor.withAlpha(26),
                            ]),
                        border: Border.all(
                            color: bgColor.withAlpha(102), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                              color: bgColor.withAlpha(51),
                              blurRadius: 16,
                              offset: const Offset(0, 8)),
                        ]),
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: onPressed,
                            borderRadius: BorderRadius.circular(borderRadius),
                            splashColor: bgColor.withAlpha(26),
                            highlightColor: bgColor.withAlpha(13),
                            child: Container(
                                padding: padding ??
                                    const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                child: child)))))));
  }

  /// Creates a glass bottom navigation bar
  static Widget glassBottomNavBar({
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: blurIntensityHigh, sigmaY: blurIntensityHigh),
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          glassWhite.withAlpha(64),
                          glassWhite.withAlpha(26),
                        ]),
                    border: const Border(
                        top: BorderSide(color: Color(0x33FFFFFF), width: 1.0)),
                    boxShadow: [
                      BoxShadow(
                          color: glassBlack.withAlpha(26),
                          blurRadius: 24,
                          offset: const Offset(0, -8)),
                    ]),
                child: BottomNavigationBar(
                    items: items,
                    currentIndex: currentIndex,
                    onTap: onTap,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: glassPrimary,
                    unselectedItemColor: glassBlack.withAlpha(153)))));
  }

  /// Creates a glass app bar with translucent background
  static PreferredSizeWidget glassAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
  }) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: blurIntensityHigh, sigmaY: blurIntensityHigh),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              glassWhite.withAlpha(77),
                              glassWhite.withAlpha(26),
                            ]),
                        border: const Border(
                            bottom: BorderSide(
                                color: Color(0x33FFFFFF), width: 1.0))),
                    child: AppBar(
                        title: Text(title,
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: glassBlack.withAlpha(230))),
                        leading: leading,
                        actions: actions,
                        centerTitle: centerTitle,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        iconTheme: IconThemeData(
                            color: glassBlack.withAlpha(204)))))));
  }

  /// Creates dynamic lighting effect for interactive elements
  static Widget lightingEffect({
    required Widget child,
    bool isPressed = false,
    bool isHovered = false,
  }) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          if (isPressed || isHovered)
            BoxShadow(
                color: glassWhite.withAlpha(204),
                blurRadius: 24,
                offset: const Offset(0, 0)),
          BoxShadow(
              color: glassBlack.withOpacity(isPressed ? 0.2 : 0.1),
              blurRadius: isPressed ? 12 : 20,
              offset: Offset(0, isPressed ? 4 : 8)),
        ]),
        child: child);
  }

  /// Text styles optimized for glass backgrounds
  static TextStyle glassTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    bool isOnGlass = true,
  }) {
    return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? (isOnGlass ? glassBlack.withAlpha(230) : glassBlack),
        letterSpacing: 0.5,
        shadows: isOnGlass
            ? [
                Shadow(
                    color: glassWhite.withAlpha(204),
                    offset: const Offset(0, 1),
                    blurRadius: 2),
              ]
            : null);
  }

  /// Motion blur effect for dynamic elements
  static Widget motionBlur({
    required Widget child,
    double intensity = 8.0,
    Offset direction = const Offset(0, 1),
  }) {
    return Stack(children: [
      Positioned(
          left: direction.dx * intensity,
          top: direction.dy * intensity,
          child: Opacity(
              opacity: 0.3,
              child: ImageFiltered(
                  imageFilter:
                      ImageFilter.blur(sigmaX: intensity, sigmaY: intensity),
                  child: child))),
      child,
    ]);
  }
}
