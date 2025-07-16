import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicInfoFormWidget extends StatefulWidget {
  final Function(Map<String, String>) onBasicInfoChanged;
  final Map<String, String> initialData;

  const BasicInfoFormWidget({
    super.key,
    required this.onBasicInfoChanged,
    this.initialData = const {},
  });

  @override
  State<BasicInfoFormWidget> createState() => _BasicInfoFormWidgetState();
}

class _BasicInfoFormWidgetState extends State<BasicInfoFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.initialData['fullName'] ?? '';
    _emailController.text = widget.initialData['email'] ?? '';
    _passwordController.text = widget.initialData['password'] ?? '';

    _fullNameController.addListener(_notifyChanges);
    _emailController.addListener(_notifyChanges);
    _passwordController.addListener(() {
      _notifyChanges();
      _checkPasswordStrength();
    });
    _confirmPasswordController.addListener(_notifyChanges);
  }

  void _notifyChanges() {
    widget.onBasicInfoChanged({
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'confirmPassword': _confirmPasswordController.text,
    });
  }

  void _checkPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      switch (score) {
        case 0:
        case 1:
          _passwordStrength = 'Very Weak';
          _passwordStrengthColor = Colors.red;
          break;
        case 2:
          _passwordStrength = 'Weak';
          _passwordStrengthColor = Colors.orange;
          break;
        case 3:
          _passwordStrength = 'Fair';
          _passwordStrengthColor = Colors.yellow;
          break;
        case 4:
          _passwordStrength = 'Good';
          _passwordStrengthColor = Colors.lightGreen;
          break;
        case 5:
          _passwordStrength = 'Strong';
          _passwordStrengthColor = Colors.green;
          break;
      }
    });
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool get isFormValid {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          _buildFullNameField(),
          SizedBox(height: 3.h),
          _buildEmailField(),
          SizedBox(height: 3.h),
          _buildPasswordField(),
          if (_passwordController.text.isNotEmpty) ...[
            SizedBox(height: 1.h),
            _buildPasswordStrengthIndicator(),
          ],
          SizedBox(height: 3.h),
          _buildConfirmPasswordField(),
        ],
      ),
    );
  }

  Widget _buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      validator: _validateFullName,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: Icon(
          Icons.person_outline,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: _validateEmail,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email address',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.next,
      validator: _validatePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Create a secure password',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Row(
      children: [
        SizedBox(width: 12.w),
        Expanded(
          child: LinearProgressIndicator(
            value: _getPasswordStrengthValue(),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          _passwordStrength,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: _passwordStrengthColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _getPasswordStrengthValue() {
    switch (_passwordStrength) {
      case 'Very Weak':
        return 0.2;
      case 'Weak':
        return 0.4;
      case 'Fair':
        return 0.6;
      case 'Good':
        return 0.8;
      case 'Strong':
        return 1.0;
      default:
        return 0.0;
    }
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      textInputAction: TextInputAction.done,
      validator: _validateConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
