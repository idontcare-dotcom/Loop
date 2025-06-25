# Loop Golf

Loop Golf is a Flutter application used for managing golf rounds and leaderboards. This repository contains the source code and tests for running the app on both mobile and web.

## Prerequisites

- **Flutter SDK**: version 3.0 or later (ensure `flutter --version` reports a compatible version)
- **Dart SDK**: version 3.6.0 or later (managed by Flutter)

Ensure Flutter is correctly installed and added to your `PATH` before continuing. For installation instructions, visit the [Flutter documentation](https://docs.flutter.dev/get-started/install).

## Setup

1. Fetch all Dart dependencies:
   ```bash
   flutter pub get
   ```
2. Configure environment values by editing `env.json` in the repository root:
   ```json
   {
     "SUPABASE_URL": "https://your-project.supabase.co",
     "SUPABASE_ANON_KEY": "your-anon-key",
     "OPENAI_API_KEY": "your-openai-api-key",
     "GEMINI_API_KEY": "your-gemini-api-key",
     "ANTHROPIC_API_KEY": "your-anthropic-api-key",
     "PERPLEXITY_API_KEY": "your-perplexity-api-key",
     "STRIPE_API_KEY": "your-stripe-api-key",
     "RESEND_API_KEY": "your-resend-api-key"
   }
   ```
   These values are loaded at runtime by `AppConfig.load()` in `lib/config/app_config.dart`.

## Running the Application

To launch the app on a connected mobile device or emulator:
```bash
flutter run
```

For web support you can run:
```bash
flutter run -d chrome
```

## Running Tests

Execute all unit and widget tests with:
```bash
flutter test
```
