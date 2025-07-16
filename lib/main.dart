import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'core/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await SupabaseService().client;
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DistanceUnitManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeManager(),
        ),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return Consumer<ThemeManager>(
          builder: (context, themeManager, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: MaterialApp(
                title: 'Loop Golf',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeManager.themeMode,
                initialRoute: AppRoutes.initial,
                routes: AppRoutes.routes,
                onGenerateRoute: AppRoutes.generateRoute,
              ),
            );
          },
        );
      }),
    );
  }
}
