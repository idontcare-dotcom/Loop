import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/course_model.dart';
import '../../models/player_model.dart';
import '../../models/simulation_result_model.dart';
import '../../services/monte_carlo_simulation_service.dart';
import '../../theme/app_theme.dart';
import './widgets/course_setup_widget.dart';
import './widgets/player_selector_widget.dart';
import './widgets/simulation_output_widget.dart';

class OddsCalculator extends StatefulWidget {
  const OddsCalculator({super.key});

  @override
  State<OddsCalculator> createState() => _OddsCalculatorState();
}

class _OddsCalculatorState extends State<OddsCalculator> {
  final MonteCarloSimulationService _simulationService =
      MonteCarloSimulationService();

  List<PlayerModel> _selectedPlayers = [];
  CourseModel? _courseModel;
  List<SimulationResultModel> _simulationResults = [];
  bool _isVsMode = false;
  bool _isLoading = false;
  HeadToHeadResult? _headToHeadResult;

  void _onPlayersChanged(List<PlayerModel> players) {
    setState(() {
      _selectedPlayers = players;
      _simulationResults.clear();
      _headToHeadResult = null;
    });
    _runSimulation();
  }

  void _onCourseChanged(CourseModel course) {
    setState(() {
      _courseModel = course;
      _simulationResults.clear();
      _headToHeadResult = null;
    });
    _runSimulation();
  }

  void _onToggleVsMode() {
    setState(() {
      _isVsMode = !_isVsMode;
      _headToHeadResult = null;
    });
  }

  void _onHeadToHeadSelected(PlayerModel player1, PlayerModel player2) {
    if (_courseModel != null) {
      setState(() {
        _isLoading = true;
      });

      // Simulate head-to-head in background
      Future.delayed(Duration(milliseconds: 500), () {
        final result = _simulationService.runHeadToHeadSimulation(
          player1,
          player2,
          _courseModel!,
        );

        setState(() {
          _headToHeadResult = result;
          _isLoading = false;
        });
      });
    }
  }

  void _runSimulation() {
    if (_selectedPlayers.isNotEmpty && _courseModel != null) {
      setState(() {
        _isLoading = true;
      });

      // Run simulation in background to avoid blocking UI
      Future.delayed(Duration(milliseconds: 300), () {
        final results =
            _simulationService.runSimulation(_selectedPlayers, _courseModel!);

        setState(() {
          _simulationResults = results;
          _isLoading = false;
        });
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryBackground,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Odds Calculator',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppTheme.accentGreen.withAlpha(13),
                      border: Border.all(
                        color: AppTheme.accentGreen.withAlpha(51),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.accentGreen,
                              size: 18.sp,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Monte Carlo Simulation',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'This tool runs 1,000 simulated rounds to calculate win probabilities based on handicap indices, course conditions, and weather factors.',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primaryBackground.withAlpha(204),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Player Selector
                  PlayerSelectorWidget(
                    selectedPlayers: _selectedPlayers,
                    onPlayersChanged: _onPlayersChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Course Setup
                  CourseSetupWidget(
                    course: _courseModel,
                    onCourseChanged: _onCourseChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Simulation Output
                  SimulationOutputWidget(
                    results: _simulationResults,
                    isVsMode: _isVsMode,
                    onToggleVsMode: _onToggleVsMode,
                    selectedPlayers: _selectedPlayers,
                    onHeadToHeadSelected: _onHeadToHeadSelected,
                    headToHeadResult: _headToHeadResult,
                  ),

                  SizedBox(height: 10.h), // Extra space for bottom padding
                ],
              ),
            ),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withAlpha(77),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.accentGreen),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Running simulation...',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBackground,
                          ),
                        ),
                        Text(
                          '1,000 rounds in progress',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.primaryBackground.withAlpha(179),
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
