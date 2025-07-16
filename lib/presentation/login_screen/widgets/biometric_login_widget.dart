import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricLoginWidget extends StatelessWidget {
  final Function() onBiometricLogin;
  final bool isAvailable;
  final bool isLoading;

  const BiometricLoginWidget({
    super.key,
    required this.onBiometricLogin,
    this.isAvailable = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 3.h),
        _buildBiometricButton(context),
      ],
    );
  }

  Widget _buildBiometricButton(BuildContext context) {
    final IconData biometricIcon = defaultTargetPlatform == TargetPlatform.iOS
        ? Icons.face
        : Icons.fingerprint;

    final String biometricText = defaultTargetPlatform == TargetPlatform.iOS
        ? 'Use Face ID'
        : 'Use Fingerprint';

    return TextButton.icon(
      onPressed: isLoading ? null : onBiometricLogin,
      icon: Icon(
        biometricIcon,
        color: Theme.of(context).colorScheme.primary,
        size: 3.h,
      ),
      label: Text(
        biometricText,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 6.w,
          vertical: 1.5.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
