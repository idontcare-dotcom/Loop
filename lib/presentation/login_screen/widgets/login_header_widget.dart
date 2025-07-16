import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildLogo(context),
      SizedBox(height: 2.h),
      _buildTagline(context),
      SizedBox(height: 6.h),
      _buildWelcomeText(context),
    ]);
  }

  Widget _buildLogo(BuildContext context) {
    return CustomImageWidget(imageUrl: '', height: 15.h, width: 15.h);
  }

  Widget _buildTagline(BuildContext context) {
    return Text('Your Golf Community',
        style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5));
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(children: [
      Text('Welcome Back',
          style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.5)),
      SizedBox(height: 1.h),
      Text('Sign in to continue your golf journey',
          style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center),
    ]);
  }
}
