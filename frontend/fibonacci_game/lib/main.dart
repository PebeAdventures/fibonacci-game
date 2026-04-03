import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/language_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'screens/main_layout.dart';
import 'services/api_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const FibonacciGameApp());
}

class FibonacciGameApp extends StatelessWidget {
  const FibonacciGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        // Language must be first — other providers may read strings
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider(apiService)),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider(apiService)),
      ],
      child: MaterialApp(
        title: 'Fibonacci Game',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainLayout(),
      ),
    );
  }
}
