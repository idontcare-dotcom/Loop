import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/logo_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _screenFadeAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  String _loadingStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _screenFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _logoController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Hide system UI for immersive experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await AuthService.instance.init();

      // Simulate app initialization tasks
      await _performInitializationTasks();

      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    final List<Map<String, dynamic>> initTasks = [
      {'task': 'Checking authentication...', 'duration': 600},
      {'task': 'Loading user preferences...', 'duration': 500},
      {'task': 'Fetching golf course updates...', 'duration': 800},
      {'task': 'Preparing scoring data...', 'duration': 400},
      {'task': 'Finalizing setup...', 'duration': 300},
    ];

    for (final task in initTasks) {
      if (mounted) {
        setState(() {
          _loadingStatus = task['task'] as String;
        });
        await Future.delayed(Duration(milliseconds: task['duration'] as int));
      }
    }
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      _fadeController.forward();
      await Future.delayed(const Duration(milliseconds: 800));

      // Restore system UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      if (mounted) {
        // Navigate based on authentication status
        final bool isAuthenticated = await _checkAuthenticationStatus();
        final String nextRoute = isAuthenticated
            ? AppRoutes.homeDashboard
            : AppRoutes.login;

        Navigator.pushReplacementNamed(context, nextRoute);
      }
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    return AuthService.instance.isSignedIn;
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _loadingStatus = 'Retrying...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _screenFadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _screenFadeAnimation.value,
            child: _buildSplashContent(),
          );
        },
      ),
    );
  }

  Widget _buildSplashContent() {
    return Stack(
      children: [
        const BackgroundGradientWidget(),
        SafeArea(
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildLogoSection(),
                SizedBox(height: 8.h),
                _buildLoadingSection(),
                const Spacer(flex: 3),
                _buildStatusSection(),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoFadeAnimation.value,
            child: LogoAnimationWidget(
              size: 25.w,
              isAnimating: _isLoading && !_hasError,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return _hasError
        ? _buildErrorSection()
        : LoadingIndicatorWidget(
            isVisible: _isLoading,
            size: 6.w,
          );
  }

  Widget _buildErrorSection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 6.w,
        ),
        SizedBox(height: 2.h),
        Text(
          'Connection Error',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        SizedBox(height: 1.h),
        TextButton(
          onPressed: _retryInitialization,
          child: Text(
            'Retry',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return AnimatedOpacity(
      opacity: _isLoading && !_hasError ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          Text(
            _loadingStatus,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Loop Golf',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
