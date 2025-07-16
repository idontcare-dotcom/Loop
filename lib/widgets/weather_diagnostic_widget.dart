import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../services/weather_service.dart';

class WeatherDiagnosticWidget extends StatefulWidget {
  const WeatherDiagnosticWidget({super.key});

  @override
  State<WeatherDiagnosticWidget> createState() =>
      _WeatherDiagnosticWidgetState();
}

class _WeatherDiagnosticWidgetState extends State<WeatherDiagnosticWidget> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _diagnostics;
  bool _isLoading = true;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _loadDiagnostics();
  }

  Future<void> _loadDiagnostics() async {
    setState(() {
      _isLoading = true;
      _lastError = null;
    });

    try {
      final diagnostics = await _weatherService.getDiagnosticInfo();
      setState(() {
        _diagnostics = diagnostics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _lastError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Diagnostics'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildDiagnosticContent(),
      ),
    );
  }

  Widget _buildDiagnosticContent() {
    if (_diagnostics == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 2.h),
            const Text('Failed to load diagnostic information'),
            if (_lastError != null) ...[
              SizedBox(height: 1.h),
              Text(_lastError!, style: const TextStyle(color: Colors.grey)),
            ],
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: _loadDiagnostics,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic System Status
          Card(
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Status',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  _buildStatusItem(
                    'Internet Connection',
                    _diagnostics!['hasInternet'] ?? false,
                    'Check your WiFi or mobile data connection',
                  ),
                  _buildStatusItem(
                    'Location Services',
                    _diagnostics!['isLocationEnabled'] ?? false,
                    'Enable location services in device settings',
                  ),
                  _buildStatusItem(
                    'Location Permission',
                    _diagnostics!['locationPermission']?.contains('granted') ??
                        false,
                    'Grant location access to the app',
                  ),
                  _buildStatusItem(
                    'API Configuration',
                    _diagnostics!['isApiConfigured'] ?? false,
                    'Weather API key needs to be configured',
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Enhanced Network Diagnostics
          if (_diagnostics!['networkDiagnostics'] != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Network Diagnostics',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    SizedBox(height: 2.h),
                    _buildNetworkDiagnosticDetails(
                        _diagnostics!['networkDiagnostics']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // API Validation Details
          if (_diagnostics!['apiValidation'] != null) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Validation',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    SizedBox(height: 2.h),
                    _buildApiValidationDetails(_diagnostics!['apiValidation']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Network Error Details (if any)
          if (_diagnostics!['networkDiagnostics']?['errors'] != null &&
              (_diagnostics!['networkDiagnostics']['errors'] as List)
                  .isNotEmpty) ...[
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 2.w),
                        Text(
                          'Network Issues Detected',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    ..._buildNetworkErrorDetails(
                        _diagnostics!['networkDiagnostics']['errors']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],

          Card(
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Troubleshooting Steps',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  _buildTroubleshootingStep(
                    '1. Check Internet Connection',
                    'Ensure you have a stable internet connection (WiFi or mobile data)',
                  ),
                  _buildTroubleshootingStep(
                    '2. Test Network Access',
                    'Try opening a web browser and visiting a website to confirm internet access',
                  ),
                  _buildTroubleshootingStep(
                    '3. Check Network Restrictions',
                    'Ensure your network doesn\'t block weather API access (corporate/school networks)',
                  ),
                  _buildTroubleshootingStep(
                    '4. Enable Location Services',
                    'Go to Settings > Privacy & Security > Location Services and turn it on',
                  ),
                  _buildTroubleshootingStep(
                    '5. Grant App Permissions',
                    'Go to Settings > Apps > Loop Golf > Permissions and enable Location',
                  ),
                  _buildTroubleshootingStep(
                    '6. Check GPS Signal',
                    'Ensure you have a clear view of the sky for better GPS reception',
                  ),
                  _buildTroubleshootingStep(
                    '7. Switch Networks',
                    'Try switching between WiFi and mobile data to isolate network issues',
                  ),
                  _buildTroubleshootingStep(
                    '8. Restart Network Connection',
                    'Turn airplane mode on/off or restart WiFi to refresh network connection',
                  ),
                  _buildTroubleshootingStep(
                    '9. Restart the App',
                    'Close and reopen the app to refresh weather data',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loadDiagnostics,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
              child: const Text('Refresh Diagnostics'),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                _showLoadingDialog();
                try {
                  await _weatherService.getCurrentWeatherWithRetry();
                  Navigator.of(context).pop(); // Close loading dialog
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Weather data refreshed successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  Navigator.of(context).pop(); // Close loading dialog
                  if (mounted) {
                    _showDetailedErrorDialog(e);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
              child: const Text('Test Weather Fetch'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkDiagnosticDetails(
      Map<String, dynamic> networkDiagnostics) {
    return Column(
      children: [
        _buildStatusItem(
          'Connectivity Type',
          true, // Always show as informational
          networkDiagnostics['connectivityType'] ?? 'Unknown',
          isInfo: true,
        ),
        _buildStatusItem(
          'Basic Connectivity',
          networkDiagnostics['hasBasicConnectivity'] ?? false,
          'Device reports network connectivity status',
        ),
        _buildStatusItem(
          'DNS Resolution',
          networkDiagnostics['canResolveDNS'] ?? false,
          'Ability to resolve domain names to IP addresses',
        ),
        _buildStatusItem(
          'Internet Access',
          networkDiagnostics['hasInternetAccess'] ?? false,
          'Can reach external internet servers',
        ),
        _buildStatusItem(
          'Weather API Access',
          networkDiagnostics['canReachWeatherAPI'] ?? false,
          'Can successfully connect to weather service',
        ),
      ],
    );
  }

  Widget _buildApiValidationDetails(Map<String, dynamic> apiValidation) {
    return Column(
      children: [
        _buildStatusItem(
          'API Key Present',
          apiValidation['hasApiKey'] ?? false,
          'Weather API key is configured in the app',
        ),
        _buildStatusItem(
          'Key Format Valid',
          apiValidation['hasValidFormat'] ?? false,
          'API key format appears correct',
        ),
        _buildStatusItem(
          'Key Authentication',
          apiValidation['isKeyValid'] ?? false,
          'API key successfully authenticates with weather service',
        ),
        if (apiValidation['error'] != null) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 20),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    apiValidation['error'],
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildNetworkErrorDetails(List<dynamic> errors) {
    return errors.map<Widget>((error) {
      return Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              error['type']?.toString().split('.').last ?? 'Unknown Error',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              error['message'] ?? 'No error message available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildStatusItem(String title, bool status, String suggestion,
      {bool isInfo = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isInfo ? Icons.info : (status ? Icons.check_circle : Icons.error),
            color: isInfo ? Colors.blue : (status ? Colors.green : Colors.red),
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isInfo
                      ? suggestion
                      : (status ? 'Working correctly' : suggestion),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: isInfo ? FontStyle.normal : FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingStep(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Testing weather connection...'),
          ],
        ),
      ),
    );
  }

  void _showDetailedErrorDialog(dynamic error) {
    String errorMessage = error.toString();
    String troubleshootingSuggestion = 'Try again later or contact support.';

    if (error is WeatherException) {
      troubleshootingSuggestion = error.getTroubleshootingSuggestion();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 2.w),
            const Text('Weather Test Failed'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Error Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.h),
              Text(errorMessage),
              SizedBox(height: 2.h),
              const Text(
                'Recommended Action:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.h),
              Text(troubleshootingSuggestion),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadDiagnostics(); // Refresh diagnostics after error
            },
            child: const Text('Refresh Diagnostics'),
          ),
        ],
      ),
    );
  }
}
