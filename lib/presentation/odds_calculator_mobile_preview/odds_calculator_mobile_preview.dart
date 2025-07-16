import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/course_model.dart';
import '../../models/player_model.dart';
import '../../models/simulation_result_model.dart';
import '../../services/monte_carlo_simulation_service.dart';
import '../../theme/app_theme.dart';
import './widgets/mobile_course_setup_widget.dart';
import './widgets/mobile_player_selector_widget.dart';
import './widgets/mobile_simulation_output_widget.dart';

class OddsCalculatorMobilePreview extends StatefulWidget {
  const OddsCalculatorMobilePreview({super.key});

  @override
  State<OddsCalculatorMobilePreview> createState() =>
      _OddsCalculatorMobilePreviewState();
}

class _OddsCalculatorMobilePreviewState
    extends State<OddsCalculatorMobilePreview> with TickerProviderStateMixin {
  final MonteCarloSimulationService _simulationService =
      MonteCarloSimulationService();

  List<PlayerModel> _selectedPlayers = [];
  CourseModel? _courseModel;
  List<SimulationResultModel> _simulationResults = [];
  bool _isVsMode = false;
  bool _isLoading = false;
  HeadToHeadResult? _headToHeadResult;

  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  void _onPlayersChanged(List<PlayerModel> players) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedPlayers = players;
      _simulationResults.clear();
      _headToHeadResult = null;
    });
    _runSimulation();
  }

  void _onCourseChanged(CourseModel course) {
    HapticFeedback.lightImpact();
    setState(() {
      _courseModel = course;
      _simulationResults.clear();
      _headToHeadResult = null;
    });
    _runSimulation();
  }

  void _onToggleVsMode() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isVsMode = !_isVsMode;
      _headToHeadResult = null;
    });
  }

  void _onHeadToHeadSelected(PlayerModel player1, PlayerModel player2) {
    if (_courseModel != null) {
      HapticFeedback.lightImpact();
      setState(() {
        _isLoading = true;
      });
      _loadingController.repeat();

      Future.delayed(Duration(milliseconds: 800), () {
        final result = _simulationService.runHeadToHeadSimulation(
          player1,
          player2,
          _courseModel!,
        );

        setState(() {
          _headToHeadResult = result;
          _isLoading = false;
        });
        _loadingController.stop();
        HapticFeedback.selectionClick();
      });
    }
  }

  void _runSimulation() {
    if (_selectedPlayers.isNotEmpty && _courseModel != null) {
      setState(() {
        _isLoading = true;
      });
      _loadingController.repeat();

      Future.delayed(Duration(milliseconds: 600), () {
        final results =
            _simulationService.runSimulation(_selectedPlayers, _courseModel!);

        setState(() {
          _simulationResults = results;
          _isLoading = false;
        });
        _loadingController.stop();
        HapticFeedback.selectionClick();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentGreen.withAlpha(26),
              border: Border.all(
                color: AppTheme.accentGreen.withAlpha(77),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.accentGreen,
              size: 18.sp,
            ),
          ),
        ),
        title: Text(
          'Odds Calculator Mobile',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBackground,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentGreen.withAlpha(26),
                  AppTheme.highlightYellow.withAlpha(26),
                ],
              ),
            ),
            child: Text(
              'Preview',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.accentGreen,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mobile Info Banner
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.accentGreen.withAlpha(13),
                          AppTheme.highlightYellow.withAlpha(13),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.accentGreen.withAlpha(51),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.accentGreen.withAlpha(26),
                          ),
                          child: Icon(
                            Icons.phone_android,
                            color: AppTheme.accentGreen,
                            size: 16.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mobile Optimized',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentGreen,
                                ),
                              ),
                              Text(
                                'Touch-friendly interface with haptic feedback',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      AppTheme.primaryBackground.withAlpha(179),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Mobile Player Selector
                  MobilePlayerSelectorWidget(
                    selectedPlayers: _selectedPlayers,
                    onPlayersChanged: _onPlayersChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Mobile Course Setup
                  MobileCourseSetupWidget(
                    course: _courseModel,
                    onCourseChanged: _onCourseChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Mobile Simulation Output
                  MobileSimulationOutputWidget(
                    results: _simulationResults,
                    isVsMode: _isVsMode,
                    onToggleVsMode: _onToggleVsMode,
                    selectedPlayers: _selectedPlayers,
                    onHeadToHeadSelected: _onHeadToHeadSelected,
                    headToHeadResult: _headToHeadResult,
                  ),

                  SizedBox(height: 12.h), // Extra space for bottom padding
                ],
              ),
            ),

            // Mobile Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withAlpha(102),
                child: Center(
                  child: Container(
                    width: 80.w,
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(51),
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: _loadingAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    AppTheme.accentGreen,
                                    AppTheme.highlightYellow,
                                    AppTheme.accentGreen,
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                  transform: GradientRotation(
                                      _loadingAnimation.value * 2 * 3.14159),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                child: Icon(
                                  Icons.calculate,
                                  color: AppTheme.accentGreen,
                                  size: 8.w,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Running Monte Carlo Simulation',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppTheme.highlightYellow.withAlpha(26),
                          ),
                          child: Text(
                            '1,000 rounds in progress...',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryBackground.withAlpha(179),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
