import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_export.dart';
import './widgets/basic_info_form_widget.dart';
import './widgets/golf_info_form_widget.dart';
import './widgets/registration_header_widget.dart';
import './widgets/social_registration_widget.dart';
import './widgets/terms_agreement_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  int _currentStep = 0;
  bool _isLoading = false;

  // Form data
  Map<String, String> _basicInfo = {};
  Map<String, dynamic> _golfInfo = {};
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  final List<String> _stepTitles = [
    'Basic Information',
    'Golf Profile',
    'Terms & Privacy',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await _authService.initialize();
    } catch (e) {
      _showErrorMessage('Failed to initialize authentication');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBasicInfoChanged(Map<String, String> basicInfo) {
    setState(() {
      _basicInfo = basicInfo;
    });
  }

  void _onGolfInfoChanged(Map<String, dynamic> golfInfo) {
    setState(() {
      _golfInfo = golfInfo;
    });
  }

  void _onAgreementChanged(bool termsAccepted, bool privacyAccepted) {
    setState(() {
      _termsAccepted = termsAccepted;
      _privacyAccepted = privacyAccepted;
    });
  }

  bool _isCurrentStepValid() {
    switch (_currentStep) {
      case 0:
        return _basicInfo['fullName']?.isNotEmpty == true &&
            _basicInfo['email']?.isNotEmpty == true &&
            _basicInfo['password']?.isNotEmpty == true &&
            _basicInfo['confirmPassword']?.isNotEmpty == true &&
            _basicInfo['password'] == _basicInfo['confirmPassword'] &&
            _isValidEmail(_basicInfo['email'] ?? '') &&
            (_basicInfo['password']?.length ?? 0) >= 8;
      case 1:
        return true; // Golf info is optional
      case 2:
        return _termsAccepted && _privacyAccepted;
      default:
        return false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email);
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _handleRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _skipToEnd() {
    // Skip golf info if user chooses to
    if (_currentStep == 1) {
      setState(() {
        _currentStep = 2;
      });
      _pageController.animateToPage(2,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _handleSocialRegistration(String provider) async {
    if (!_termsAccepted || !_privacyAccepted) {
      _showErrorMessage('Please accept the terms and privacy policy first');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      AuthResponse? response;

      if (provider == 'google') {
        response = await _authService.signInWithGoogle();
      } else if (provider == 'apple') {
        response = await _authService.signInWithApple();
      }

      if (response?.user != null) {
        // Update profile with golf info if available
        if (_golfInfo.isNotEmpty) {
          await _authService.updateUserProfile(_golfInfo);
        }

        Fluttertoast.showToast(
            msg: "Registration successful! Welcome to Loop Golf!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.HOME_DASHBOARD);
        }
      }
    } catch (e) {
      _showErrorMessage("Social registration failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRegistration() async {
    if (!_isCurrentStepValid()) {
      _showErrorMessage('Please complete all required fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signUpWithEmail(
        email: _basicInfo['email']!,
        password: _basicInfo['password']!,
        fullName: _basicInfo['fullName']!,
        additionalData: _golfInfo,
      );

      if (response.user != null) {
        Fluttertoast.showToast(
            msg: "Registration successful! Welcome to Loop Golf!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);

        if (mounted) {
          _showWelcomeDialog();
        }
      } else {
        _showErrorMessage("Registration failed. Please try again.");
      }
    } catch (e) {
      _showErrorMessage("Registration failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showWelcomeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Welcome to Loop Golf!',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary)),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                CustomImageWidget(height: 8.h, width: 8.h, imageUrl: ''),
                SizedBox(height: 2.h),
                Text(
                    'Your account has been created successfully!\n\nPlease check your email for verification instructions.',
                    style: GoogleFonts.inter(fontSize: 14),
                    textAlign: TextAlign.center),
              ]),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.HOME_DASHBOARD);
                    },
                    child: Text('Get Started',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500))),
              ]);
        });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      RegistrationHeaderWidget(onSkip: _currentStep == 1 ? _skipToEnd : null),
      _buildProgressIndicator(),
      Expanded(
          child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
            _buildBasicInfoStep(),
            _buildGolfInfoStep(),
            _buildTermsStep(),
          ])),
      _buildBottomSection(),
    ])));
  }

  Widget _buildProgressIndicator() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(children: [
          Row(
              children: List.generate(_stepTitles.length, (index) {
            final isActive = index <= _currentStep;
            final isCompleted = index < _currentStep;

            return Expanded(
                child: Container(
                    height: 0.5.h,
                    margin: EdgeInsets.only(
                        right: index < _stepTitles.length - 1 ? 1.w : 0),
                    decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2))));
          })),
          SizedBox(height: 1.h),
          Text(
              'Step ${_currentStep + 1} of ${_stepTitles.length}: ${_stepTitles[_currentStep]}',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]));
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          children: [
            BasicInfoFormWidget(
                onBasicInfoChanged: _onBasicInfoChanged,
                initialData: _basicInfo),
            SizedBox(height: 4.h),
            SocialRegistrationWidget(
              onSocialLogin: _handleSocialRegistration,
              isLoading: _isLoading,
            ),
          ],
        ));
  }

  Widget _buildGolfInfoStep() {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: GolfInfoFormWidget(
            onGolfInfoChanged: _onGolfInfoChanged, initialData: _golfInfo));
  }

  Widget _buildTermsStep() {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          children: [
            TermsAgreementWidget(
                onAgreementChanged: _onAgreementChanged,
                initialTermsAccepted: _termsAccepted,
                initialPrivacyAccepted: _privacyAccepted),
            SizedBox(height: 4.h),
            if (_termsAccepted && _privacyAccepted) ...[
              SocialRegistrationWidget(
                onSocialLogin: _handleSocialRegistration,
                isLoading: _isLoading,
              ),
            ],
          ],
        ));
  }

  Widget _buildBottomSection() {
    return Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(children: [
          Row(children: [
            if (_currentStep > 0) ...[
              Expanded(
                  child: OutlinedButton(
                      onPressed: _isLoading ? null : _previousStep,
                      child: Text('Back',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w500)))),
              SizedBox(width: 4.w),
            ],
            Expanded(
                flex: _currentStep > 0 ? 2 : 1,
                child: ElevatedButton(
                    onPressed:
                        _isLoading || !_isCurrentStepValid() ? null : _nextStep,
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h)),
                    child: _isLoading
                        ? SizedBox(
                            height: 2.5.h,
                            width: 2.5.h,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary))
                        : Text(
                            _currentStep == _stepTitles.length - 1
                                ? 'Create Account'
                                : 'Continue',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w600)))),
          ]),
          if (_currentStep == 0) ...[
            SizedBox(height: 2.h),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Already have an account? ',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, AppRoutes.LOGIN_SCREEN),
                  child: Text('Sign In',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary))),
            ]),
          ],
        ]));
  }
}
