import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function(String provider) onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    super.key,
    required this.onSocialLogin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildDivider(context),
      SizedBox(height: 3.h),
      _buildSocialButtons(context),
    ]);
  }

  Widget _buildDivider(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Divider(
              color: Theme.of(context).colorScheme.outline, thickness: 1)),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text('Or continue with',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant))),
      Expanded(
          child: Divider(
              color: Theme.of(context).colorScheme.outline, thickness: 1)),
    ]);
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Column(children: [
      if (defaultTargetPlatform == TargetPlatform.iOS) ...[
        _buildAppleButton(context),
        SizedBox(height: 2.h),
      ],
      _buildGoogleButton(context),
    ]);
  }

  Widget _buildAppleButton(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
            onPressed: isLoading ? null : () => onSocialLogin('apple'),
            icon: Icon(Icons.apple,
                color: Theme.of(context).colorScheme.onSurface, size: 2.5.h),
            label: Text('Continue with Apple',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface)),
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outline, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)))));
  }

  Widget _buildGoogleButton(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
            onPressed: isLoading ? null : () => onSocialLogin('google'),
            icon: CustomImageWidget(
                imageUrl: 'google_icon.png', height: 2.5.h, width: 2.5.h),
            label: Text('Continue with Google',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface)),
            style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outline, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)))));
  }
}
