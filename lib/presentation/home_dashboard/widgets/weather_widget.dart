import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';
import '../../../widgets/weather_diagnostic_widget.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _useFahrenheit = false;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      // Load temperature unit preference
      _useFahrenheit = await _weatherService.getTemperatureUnit();

      // Fetch weather data with retry mechanism
      final weather = await _weatherService.getCurrentWeatherWithRetry();

      setState(() {
        _weather = weather;
        _isLoading = false;
        _hasError = weather == null;
        if (weather == null) {
          _errorMessage = 'Weather data unavailable';
        }
      });
    } on WeatherException catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Weather unavailable';
      });
    }
  }

  Future<void> _toggleTemperatureUnit() async {
    setState(() {
      _useFahrenheit = !_useFahrenheit;
    });
    await _weatherService.setTemperatureUnit(_useFahrenheit);
  }

  Future<void> _showTroubleshootingDialog() async {
    final diagnostics = await _weatherService.getDiagnosticInfo();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weather Troubleshooting'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Issue: $_errorMessage\n',
                  style: const TextStyle(fontWeight: FontWeight.bold)),

              // Enhanced error details
              if (_errorMessage.contains('internet') ||
                  _errorMessage.contains('network') ||
                  _errorMessage.contains('connection')) ...[
                Container(
                  padding: EdgeInsets.all(2.w),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Network Issue Detected',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 1.h),
                      Text(
                          'Connection Type: ${diagnostics['networkDiagnostics']?['connectivityType'] ?? 'Unknown'}'),
                      Text(
                          'Internet Access: ${diagnostics['networkDiagnostics']?['hasInternetAccess'] == true ? 'Yes' : 'No'}'),
                      Text(
                          'Weather API Access: ${diagnostics['networkDiagnostics']?['canReachWeatherAPI'] == true ? 'Yes' : 'No'}'),
                    ],
                  ),
                ),
              ],

              const Text('Diagnostic Information:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDiagnosticItem(
                  'Internet Connection', diagnostics['hasInternet']),
              _buildDiagnosticItem(
                  'Location Services', diagnostics['isLocationEnabled']),
              _buildDiagnosticItem('Location Permission',
                  diagnostics['locationPermission'].contains('granted')),
              _buildDiagnosticItem(
                  'API Configuration', diagnostics['isApiConfigured']),

              // Enhanced network diagnostics
              if (diagnostics['networkDiagnostics'] != null) ...[
                SizedBox(height: 1.h),
                _buildDiagnosticItem('DNS Resolution',
                    diagnostics['networkDiagnostics']['canResolveDNS']),
                _buildDiagnosticItem('Weather API Reachable',
                    diagnostics['networkDiagnostics']['canReachWeatherAPI']),
              ],

              const SizedBox(height: 16),
              const Text('Troubleshooting Steps:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('1. Check your internet connection'),
              const Text('2. Try switching between WiFi and mobile data'),
              const Text('3. Check if you\'re behind a firewall or proxy'),
              const Text('4. Enable location services in device settings'),
              const Text('5. Grant location permission to the app'),
              const Text('6. Ensure GPS is enabled'),
              const Text('7. Try refreshing the weather data'),
              const Text('8. Restart the app if issues persist'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WeatherDiagnosticWidget()),
              );
            },
            child: const Text('Detailed Diagnostics'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadWeatherData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticItem(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.error,
            color: status ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text('$label: ${status ? 'OK' : 'Issue'}'),
        ],
      ),
    );
  }

  Future<void> _openNativeWeatherApp() async {
    try {
      // Try to open native weather app
      const String weatherAppUrl = 'weather://';
      const String fallbackUrl = 'https://weather.com';

      if (await canLaunchUrl(Uri.parse(weatherAppUrl))) {
        await launchUrl(Uri.parse(weatherAppUrl));
      } else {
        // Fallback to web weather
        await launchUrl(
          Uri.parse(fallbackUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // If all fails, show a message
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Unable to open weather app',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hasError ? _showTroubleshootingDialog : _openNativeWeatherApp,
      onLongPress: _hasError ? null : _toggleTemperatureUnit,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: _hasError
              ? Theme.of(context).colorScheme.error.withAlpha(26)
              : Theme.of(context).colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: _hasError
              ? Border.all(
                  color: Theme.of(context).colorScheme.error.withAlpha(77))
              : null,
        ),
        child: _buildWeatherContent(),
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (_isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            'Loading weather...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      );
    }

    if (_hasError || _weather == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: Theme.of(context).colorScheme.error,
            size: 18,
          ),
          SizedBox(width: 1.w),
          Flexible(
            child: Text(
              _errorMessage.isNotEmpty ? _errorMessage : 'Weather unavailable',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 1.w),
          CustomIconWidget(
            iconName: 'help_outline',
            color: Theme.of(context).colorScheme.error,
            size: 16,
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: _weather!.getWeatherIcon(),
          color: Theme.of(context).colorScheme.primary,
          size: 18,
        ),
        SizedBox(width: 1.w),
        Flexible(
          child: Text(
            '${_weather!.getFormattedDescription()}, ${_weatherService.formatTemperature(_weather!.temperature, _useFahrenheit)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
