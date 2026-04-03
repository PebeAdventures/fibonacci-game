import 'package:flutter/foundation.dart';
import '../models/leaderboard_entry.dart';
import '../services/api_service.dart';

/// State management for the leaderboard screen.
/// Fetches and caches the top 10 results.
class LeaderboardProvider extends ChangeNotifier {
  final ApiService _api;

  LeaderboardProvider(this._api);

  List<LeaderboardEntry> _entries = [];
  List<LeaderboardEntry> get entries => _entries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  /// Fetches the top 10 leaderboard entries from the backend.
  /// Can be called multiple times to refresh data.
  Future<void> loadLeaderboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _entries = await _api.getLeaderboard();
      _hasLoaded = true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _entries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reloads leaderboard - useful after a game is completed.
  Future<void> refresh() async {
    _hasLoaded = false;
    await loadLeaderboard();
  }
}
