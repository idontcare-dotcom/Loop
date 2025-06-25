import '../config/app_config.dart';

class AuthService {
  final String _baseUrl = AppConfig.instance.supabaseUrl;
  final String _anonKey = AppConfig.instance.supabaseAnonKey;

  void initialize() {
    // Placeholder for service initialization using the config values
    // e.g. SupabaseClient(_baseUrl, _anonKey);
    print('AuthService initialized with $_baseUrl and $_anonKey');
  }
}
