import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/weather_model.dart';

class WeatherService {
  // WeatherAPI.com API key provided by user
  static const String _apiKey = 'a4dd181401fa4f2eacd50924250107';
  static const String _baseUrl = 'https://api.weatherapi.com/v1/current.json';

  final Dio _dio = Dio();

  // Singleton pattern
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  /// Enhanced connectivity check with detailed network diagnostics
  Future<NetworkDiagnosticResult> performNetworkDiagnostics() async {
    final result = NetworkDiagnosticResult();

    try {
      // Check basic connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      result.connectivityType = connectivityResult.toString();
      result.hasBasicConnectivity =
          connectivityResult != ConnectivityResult.none;

      if (!result.hasBasicConnectivity) {
        result.addError(WeatherErrorType.noConnectivity,
            'Device reports no network connectivity. Check WiFi/Mobile data settings.');
        return result;
      }

      // Test DNS resolution
      try {
        await _dio.get('https://8.8.8.8',
            options: Options(
              receiveTimeout: const Duration(seconds: 3),
              sendTimeout: const Duration(seconds: 3),
            ));
        result.canResolveDNS = true;
      } catch (e) {
        result.canResolveDNS = false;
        result.addError(WeatherErrorType.dnsFailure,
            'DNS resolution failed. Check your network settings or try a different network.');
      }

      // Test general internet connectivity
      try {
        final response = await _dio.get('https://www.google.com',
            options: Options(
              receiveTimeout: const Duration(seconds: 5),
              sendTimeout: const Duration(seconds: 5),
            ));
        result.hasInternetAccess = response.statusCode == 200;
      } catch (e) {
        result.hasInternetAccess = false;
        if (e is DioException) {
          if (e.type == DioExceptionType.connectionTimeout) {
            result.addError(WeatherErrorType.connectionTimeout,
                'Internet connection timeout. Your network may be slow or unstable.');
          } else if (e.type == DioExceptionType.connectionError) {
            result.addError(WeatherErrorType.connectionError,
                'Cannot reach internet servers. Check firewall/proxy settings.');
          }
        }
      }

      // Test Weather API connectivity specifically
      try {
        final response =
            await _dio.get(_baseUrl.replaceAll('http://', 'https://'),
                queryParameters: {'key': _apiKey, 'q': 'London'},
                options: Options(
                  receiveTimeout: const Duration(seconds: 5),
                  sendTimeout: const Duration(seconds: 5),
                ));
        result.canReachWeatherAPI = response.statusCode == 200;
      } catch (e) {
        result.canReachWeatherAPI = false;
        if (e is DioException) {
          if (e.response?.statusCode == 401) {
            result.addError(WeatherErrorType.invalidApiKey,
                'Weather API key is invalid or expired.');
          } else if (e.response?.statusCode == 403) {
            result.addError(WeatherErrorType.apiAccessDenied,
                'Weather API access denied. Check your subscription plan.');
          } else if (e.response?.statusCode == 429) {
            result.addError(WeatherErrorType.rateLimitExceeded,
                'Weather API rate limit exceeded. Please wait before trying again.');
          } else {
            result.addError(WeatherErrorType.apiServerError,
                'Weather API server unreachable. Service may be temporarily down.');
          }
        }
      }

      return result;
    } catch (e) {
      result.addError(WeatherErrorType.unknown,
          'Unexpected error during network diagnostics: ${e.toString()}');
      return result;
    }
  }

  /// Checks internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Additional check by pinging a reliable server
      final response = await _dio.get(
        'https://www.google.com',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Validates API configuration with detailed checks
  Future<ApiValidationResult> validateApiConfiguration() async {
    final result = ApiValidationResult();

    // Check if API key is configured
    result.hasApiKey = _apiKey.isNotEmpty;
    if (!result.hasApiKey) {
      result.error = 'Weather API key is not configured';
      return result;
    }

    // Check API key format (WeatherAPI.com keys are typically 32 characters)
    result.hasValidFormat = _apiKey.length >= 20 && _apiKey.isNotEmpty;
    if (!result.hasValidFormat) {
      result.error = 'Weather API key format appears invalid';
      return result;
    }

    // Test API key by making a simple request
    try {
      final response =
          await _dio.get(_baseUrl.replaceAll('http://', 'https://'),
              queryParameters: {'key': _apiKey, 'q': 'London'},
              options: Options(
                receiveTimeout: const Duration(seconds: 10),
                sendTimeout: const Duration(seconds: 10),
              ));

      result.isKeyValid = response.statusCode == 200;
      if (result.isKeyValid) {
        result.error = null;
      } else {
        result.error =
            'API key validation failed with status: ${response.statusCode}';
      }
    } catch (e) {
      result.isKeyValid = false;
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          result.error = 'Weather API key is invalid or expired';
        } else if (e.response?.statusCode == 403) {
          result.error = 'Weather API access denied - check subscription';
        } else {
          result.error = 'Could not validate API key: ${e.message}';
        }
      } else {
        result.error = 'API validation error: ${e.toString()}';
      }
    }

    return result;
  }

  /// Validates API configuration
  bool isApiKeyConfigured() {
    return _apiKey.isNotEmpty;
  }

  /// Checks if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Gets comprehensive diagnostic information for troubleshooting
  Future<Map<String, dynamic>> getDiagnosticInfo() async {
    final networkDiagnostics = await performNetworkDiagnostics();
    final apiValidation = await validateApiConfiguration();
    final hasInternet = await hasInternetConnection();
    final isLocationEnabled = await isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    final isApiConfigured = isApiKeyConfigured();

    return {
      'hasInternet': hasInternet,
      'isLocationEnabled': isLocationEnabled,
      'locationPermission': permission.toString(),
      'isApiConfigured': isApiConfigured,
      'timestamp': DateTime.now().toIso8601String(),
      // Enhanced diagnostics
      'networkDiagnostics': {
        'connectivityType': networkDiagnostics.connectivityType,
        'hasBasicConnectivity': networkDiagnostics.hasBasicConnectivity,
        'canResolveDNS': networkDiagnostics.canResolveDNS,
        'hasInternetAccess': networkDiagnostics.hasInternetAccess,
        'canReachWeatherAPI': networkDiagnostics.canReachWeatherAPI,
        'errors': networkDiagnostics.errors
            .map((e) => {
                  'type': e.type.toString(),
                  'message': e.message,
                })
            .toList(),
      },
      'apiValidation': {
        'hasApiKey': apiValidation.hasApiKey,
        'hasValidFormat': apiValidation.hasValidFormat,
        'isKeyValid': apiValidation.isKeyValid,
        'error': apiValidation.error,
      },
    };
  }

  /// Enhanced weather fetching with detailed error reporting
  Future<WeatherModel?> getCurrentWeather() async {
    try {
      // Perform comprehensive network diagnostics first
      final networkDiagnostics = await performNetworkDiagnostics();

      // Check for critical network issues
      if (!networkDiagnostics.hasBasicConnectivity) {
        final connectivityError = networkDiagnostics.errors.firstWhere(
          (e) => e.type == WeatherErrorType.noConnectivity,
          orElse: () => WeatherError(WeatherErrorType.noConnectivity,
              'No network connectivity detected'),
        );
        throw WeatherException(
            connectivityError.message, connectivityError.type);
      }

      if (!networkDiagnostics.hasInternetAccess) {
        final internetError = networkDiagnostics.errors.firstWhere(
          (e) =>
              e.type == WeatherErrorType.connectionError ||
              e.type == WeatherErrorType.connectionTimeout,
          orElse: () => WeatherError(WeatherErrorType.connectionError,
              'Cannot access internet services'),
        );
        throw WeatherException(internetError.message, internetError.type);
      }

      // Validate API configuration
      final apiValidation = await validateApiConfiguration();
      if (!apiValidation.hasApiKey) {
        throw WeatherException(
            'Weather API key not configured. Please contact app developer.',
            WeatherErrorType.invalidApiKey);
      }

      if (!apiValidation.isKeyValid) {
        throw WeatherException(
            apiValidation.error ?? 'Weather API key validation failed',
            WeatherErrorType.invalidApiKey);
      }

      // Check location services
      if (!await isLocationServiceEnabled()) {
        throw WeatherException(
            'Location services are disabled. Please enable location services in device settings.',
            WeatherErrorType.locationServiceDisabled);
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw WeatherException(
              'Location permissions denied. Please grant location access in app settings.',
              WeatherErrorType.locationPermissionDenied);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw WeatherException(
            'Location permissions permanently denied. Please enable location access in device settings.',
            WeatherErrorType.locationPermissionPermanentlyDenied);
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Fetch weather data from WeatherAPI.com
      final response = await _dio.get(_baseUrl,
          queryParameters: {
            'key': _apiKey,
            'q': '${position.latitude},${position.longitude}',
            'aqi': 'no',
          },
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
          ));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw WeatherException(
            'Weather API error: ${response.statusCode}. Please try again later.',
            WeatherErrorType.apiServerError);
      }
    } on WeatherException {
      rethrow;
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw WeatherException(
              'Connection timeout. Your internet connection may be slow or unstable. Try connecting to a different network.',
              WeatherErrorType.connectionTimeout);
        } else if (e.type == DioExceptionType.connectionError) {
          throw WeatherException(
              'Network connection failed. Check your internet connection, firewall, or proxy settings.',
              WeatherErrorType.connectionError);
        } else if (e.response?.statusCode == 401) {
          throw WeatherException(
              'Weather API authentication failed. The API key may be invalid or expired.',
              WeatherErrorType.invalidApiKey);
        } else if (e.response?.statusCode == 403) {
          throw WeatherException(
              'Weather API access denied. Your API subscription may have expired or reached its limit.',
              WeatherErrorType.apiAccessDenied);
        } else if (e.response?.statusCode == 429) {
          throw WeatherException(
              'Weather API rate limit exceeded. Please wait a few minutes before trying again.',
              WeatherErrorType.rateLimitExceeded);
        }
      }

      print('Error fetching weather: $e');
      throw WeatherException(
          'Failed to fetch weather data due to an unexpected error. Please try again later.',
          WeatherErrorType.unknown);
    }
  }

  /// Retries weather fetch with exponential backoff
  Future<WeatherModel?> getCurrentWeatherWithRetry({int maxRetries = 3}) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await getCurrentWeather();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }

        // Exponential backoff: 2^attempts seconds
        await Future.delayed(Duration(seconds: 2 * attempts));
      }
    }

    return null;
  }

  /// Gets the saved temperature unit preference
  Future<bool> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('use_fahrenheit') ?? false;
  }

  /// Saves the temperature unit preference
  Future<void> setTemperatureUnit(bool useFahrenheit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_fahrenheit', useFahrenheit);
  }

  /// Converts Celsius to Fahrenheit
  double convertCelsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Formats temperature based on user preference
  String formatTemperature(double temperature, bool useFahrenheit) {
    if (useFahrenheit) {
      return '${convertCelsiusToFahrenheit(temperature).round()}°F';
    } else {
      return '${temperature.round()}°C';
    }
  }
}

/// Enhanced exception class for weather-related errors with categorization
class WeatherException implements Exception {
  final String message;
  final WeatherErrorType errorType;

  WeatherException(this.message, [this.errorType = WeatherErrorType.unknown]);

  @override
  String toString() => message;

  /// Gets user-friendly troubleshooting suggestions based on error type
  String getTroubleshootingSuggestion() {
    switch (errorType) {
      case WeatherErrorType.noConnectivity:
        return 'Check your WiFi or mobile data connection and ensure it\'s enabled.';
      case WeatherErrorType.connectionTimeout:
        return 'Your internet connection is slow. Try moving closer to your WiFi router or switching to mobile data.';
      case WeatherErrorType.connectionError:
        return 'Cannot reach weather servers. Check if you\'re behind a firewall or proxy that may be blocking the connection.';
      case WeatherErrorType.dnsFailure:
        return 'DNS resolution failed. Try switching to a different WiFi network or contact your network administrator.';
      case WeatherErrorType.invalidApiKey:
        return 'Weather service configuration issue. Please contact app support for assistance.';
      case WeatherErrorType.apiAccessDenied:
        return 'Weather service access issue. The service may be temporarily unavailable.';
      case WeatherErrorType.rateLimitExceeded:
        return 'Too many weather requests. Please wait 5-10 minutes before trying again.';
      case WeatherErrorType.apiServerError:
        return 'Weather service is temporarily down. Please try again in a few minutes.';
      case WeatherErrorType.locationServiceDisabled:
        return 'Enable location services in your device settings to get weather for your current location.';
      case WeatherErrorType.locationPermissionDenied:
        return 'Grant location permission to the app in your device settings.';
      case WeatherErrorType.locationPermissionPermanentlyDenied:
        return 'Go to app settings and manually enable location permissions.';
      default:
        return 'Try closing and reopening the app, or restart your device if the problem persists.';
    }
  }
}

/// Enum for categorizing different types of weather-related errors
enum WeatherErrorType {
  noConnectivity,
  connectionTimeout,
  connectionError,
  dnsFailure,
  invalidApiKey,
  apiAccessDenied,
  rateLimitExceeded,
  apiServerError,
  locationServiceDisabled,
  locationPermissionDenied,
  locationPermissionPermanentlyDenied,
  unknown,
}

/// Result class for network diagnostic operations
class NetworkDiagnosticResult {
  String connectivityType = 'unknown';
  bool hasBasicConnectivity = false;
  bool canResolveDNS = false;
  bool hasInternetAccess = false;
  bool canReachWeatherAPI = false;
  List<WeatherError> errors = [];

  void addError(WeatherErrorType type, String message) {
    errors.add(WeatherError(type, message));
  }

  bool get hasErrors => errors.isNotEmpty;
  bool get isHealthy =>
      hasBasicConnectivity &&
      canResolveDNS &&
      hasInternetAccess &&
      canReachWeatherAPI;
}

/// Result class for API validation operations
class ApiValidationResult {
  bool hasApiKey = false;
  bool hasValidFormat = false;
  bool isKeyValid = false;
  String? error;

  bool get isValid =>
      hasApiKey && hasValidFormat && isKeyValid && error == null;
}

/// Error class for structured error reporting
class WeatherError {
  final WeatherErrorType type;
  final String message;

  WeatherError(this.type, this.message);
}
