import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  late final SupabaseClient _client;

  Future<void> init() async {
    if (Supabase.instance.isInitialized) {
      _client = Supabase.instance.client;
      return;
    }
    final data = await rootBundle.loadString('env.json');
    final Map<String, dynamic> env = json.decode(data);
    await Supabase.initialize(
      url: env['SUPABASE_URL'] as String,
      anonKey: env['SUPABASE_ANON_KEY'] as String,
    );
    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  bool get isSignedIn => _client.auth.currentSession != null;

  Future<AuthResponse> signIn(String email, String password) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
