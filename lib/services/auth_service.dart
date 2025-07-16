import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final SupabaseClient _supabase;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _supabase = await SupabaseService().client;
    _initialized = true;
  }

  // Email and Password Registration
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    Map<String, dynamic>? additionalData,
  }) async {
    await initialize();

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          ...?additionalData,
        },
      );
      return response;
    } catch (error) {
      throw Exception('Email signup failed: $error');
    }
  }

  // Email and Password Sign In
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await initialize();

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Email signin failed: $error');
    }
  }

  // Google Sign In
  Future<AuthResponse?> signInWithGoogle() async {
    await initialize();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      return response;
    } catch (error) {
      throw Exception('Google signin failed: $error');
    }
  }

  // Apple Sign In
  Future<AuthResponse?> signInWithApple() async {
    await initialize();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken == null) {
        throw Exception('Failed to get Apple identity token');
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
      );

      return response;
    } catch (error) {
      throw Exception('Apple signin failed: $error');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await initialize();

    try {
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  // Get Current User
  User? get currentUser => _supabase.auth.currentUser;

  // Get Current Session
  Session? get currentSession => _supabase.auth.currentSession;

  // Auth State Stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Get User Profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    await initialize();

    if (!isAuthenticated) return null;

    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update User Profile
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    await initialize();

    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      await _supabase.from('user_profiles').update({
        ...updates,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', currentUser!.id);
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }
}
