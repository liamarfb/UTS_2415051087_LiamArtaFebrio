import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app_constants.dart';
import 'providers/flight_log_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isSupabaseConfigured =
      AppConstants.supabaseUrl.startsWith('https://') &&
      !AppConstants.supabaseUrl.contains('YOUR_PROJECT_ID') &&
      !AppConstants.supabaseAnonKey.contains('YOUR_SUPABASE');

  if (isSupabaseConfigured) {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => FlightLogProvider()),
      ],
      child: const AeroLogApp(),
    ),
  );
}

class AeroLogApp extends StatelessWidget {
  const AeroLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryMint,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}