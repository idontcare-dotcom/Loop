import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_export.dart';
import './widgets/biometric_login_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_header_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
    _checkBiometricAvailability();
  }

  Future<void> _initializeAuth() async {
    try {
      await _authService.initialize();
    } catch (e) {
      _showErrorMessage('Failed to initialize authentication');
    }
  }

  Future<void> _checkBiometricAvailability() async {
    // Mock biometric availability check
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isBiometricAvailable = true; // Mock availability
      });
    }
  }

  Future<void> _handleEmailLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
        }
      } else {
        _showErrorMessage("Login failed. Please check your credentials.");
      }
    } catch (e) {
      _showErrorMessage("Login failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
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
        Fluttertoast.showToast(
          msg: "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
        }
      }
    } catch (e) {
      _showErrorMessage("Social login failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mock biometric authentication delay
      await Future.delayed(const Duration(seconds: 1));

      Fluttertoast.showToast(
        msg: "Biometric authentication successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
      }
    } catch (e) {
      _showErrorMessage("Biometric authentication failed.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _navigateToForgotPassword() {
    // Mock navigation to forgot password
    Fluttertoast.showToast(
      msg: "Password reset functionality coming soon!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _navigateToRegistration() {
    Navigator.pushNamed(context, AppRoutes.registrationScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: SizedBox(
            height: 95.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 6.h),
                const LoginHeaderWidget(),
                SizedBox(height: 4.h),
                LoginFormWidget(
                  onLogin: _handleEmailLogin,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 2.h),
                _buildForgotPasswordLink(),
                SizedBox(height: 3.h),
                SocialLoginWidget(
                  onSocialLogin: _handleSocialLogin,
                  isLoading: _isLoading,
                ),
                BiometricLoginWidget(
                  onBiometricLogin: _handleBiometricLogin,
                  isAvailable: _isBiometricAvailable,
                  isLoading: _isLoading,
                ),
                const Spacer(),
                _buildSignUpSection(),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _navigateToForgotPassword,
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to Loop Golf? ',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: _navigateToRegistration,
          child: Text(
            'Create Account',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
