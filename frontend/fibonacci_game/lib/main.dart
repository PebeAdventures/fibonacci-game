import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'screens/main_layout.dart';
import 'services/api_service.dart';
import 'utils/app_theme.dart';

/// Entry point of the Fibonacci Game Flutter Web application.
/// 
/// Architecture:
/// - Provider is used for state management (simple, well-supported in Flutter)
/// - ApiService is a singleton created once and injected into providers
/// - Two providers: GameProvider (game state) and LeaderboardProvider (leaderboard data)
void main() {
  runApp(const FibonacciGameApp());
}

class FibonacciGameApp extends StatelessWidget {
  const FibonacciGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create ApiService once - shared between providers
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        // GameProvider: manages active game state
        ChangeNotifierProvider(
          create: (_) => GameProvider(apiService),
        ),
        // LeaderboardProvider: manages leaderboard data
        ChangeNotifierProvider(
          create: (_) => LeaderboardProvider(apiService),
        ),
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
