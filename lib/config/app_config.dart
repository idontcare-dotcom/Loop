import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String openaiApiKey;
  final String geminiApiKey;
  final String anthropicApiKey;
  final String perplexityApiKey;
  final String stripeApiKey;
  final String resendApiKey;

  AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.openaiApiKey,
    required this.geminiApiKey,
    required this.anthropicApiKey,
    required this.perplexityApiKey,
    required this.stripeApiKey,
    required this.resendApiKey,
  });

  static AppConfig? _instance;
  static AppConfig get instance => _instance!;

  static Future<void> load({String path = 'env.json'}) async {
    final data = await rootBundle.loadString(path);
    final json = jsonDecode(data) as Map<String, dynamic>;
    _instance = AppConfig(
      supabaseUrl: json['SUPABASE_URL'] ?? '',
      supabaseAnonKey: json['SUPABASE_ANON_KEY'] ?? '',
      openaiApiKey: json['OPENAI_API_KEY'] ?? '',
      geminiApiKey: json['GEMINI_API_KEY'] ?? '',
      anthropicApiKey: json['ANTHROPIC_API_KEY'] ?? '',
      perplexityApiKey: json['PERPLEXITY_API_KEY'] ?? '',
      stripeApiKey: json['STRIPE_API_KEY'] ?? '',
      resendApiKey: json['RESEND_API_KEY'] ?? '',
    );
  }
}
