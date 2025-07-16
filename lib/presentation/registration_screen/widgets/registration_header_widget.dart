import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class RegistrationHeaderWidget extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const RegistrationHeaderWidget({
    super.key,
    this.onBack,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildNavigationRow(context),
      SizedBox(height: 4.h),
      _buildWelcomeContent(context),
    ]);
  }

  Widget _buildNavigationRow(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconButton(
          onPressed: onBack ?? () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onSurface, size: 2.5.h)),
      TextButton(
          onPressed: onSkip,
          child: Text('Skip',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary))),
    ]);
  }

  Widget _buildWelcomeContent(BuildContext context) {
    return Column(children: [
      CustomImageWidget(imageUrl: '', height: 12.h, width: 12.h),
      SizedBox(height: 3.h),
      Text('Join Loop Golf',
          style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.5)),
      SizedBox(height: 1.h),
      Text('Connect with golfers and track your game',
          style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center),
    ]);
  }
}
