import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leaderboard_entry.dart';
import '../models/save_result_response.dart';

/// Exception thrown when an API call fails.
/// Wraps HTTP errors with human-readable messages.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// API service layer - handles all communication with the ASP.NET Core backend.
/// All methods are async and throw [ApiException] on failure.
/// 
/// Base URL: http://localhost:5000 (backend default port)
/// Change [baseUrl] if backend runs on a different port.
class ApiService {
  // Backend base URL - must match the port in backend's launchSettings.json
  static const String baseUrl = 'http://localhost:5000';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Common headers for all requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // =====================================================================
  // GAME ENDPOINTS
  // =====================================================================

  /// POST /api/game/start
  /// Starts a new game session and returns the initial state.
  /// Returns a Map with fields: playerName, initialSequence, currentIndex, lives, score
  Future<Map<String, dynamic>> startGame(String playerName) async {
    final response = await _post(
      '/api/game/start',
      {'playerName': playerName},
    );
    return response;
  }

  /// POST /api/game/answer
  /// Submits the player's answer along with current game state.
  /// Returns a Map with fields: isCorrect, message, correctAnswer, score, lives, gameOver, currentSequence, nextIndex
  Future<Map<String, dynamic>> submitAnswer({
    required int answer,
    required int currentIndex,
    required int currentScore,
    required int currentLives,
    required List<int> currentSequence,
  }) async {
    final response = await _post('/api/game/answer', {
      'answer': answer,
      'currentIndex': currentIndex,
      'currentScore': currentScore,
      'currentLives': currentLives,
      'currentSequence': currentSequence,
    });
    return response;
  }

  // =====================================================================
  // LEADERBOARD ENDPOINTS
  // =====================================================================

  /// POST /api/leaderboard/save
  /// Saves the final game result to the database.
  Future<SaveResultResponse> saveResult({
    required String playerName,
    required int score,
    required DateTime startedAt,
    required int correctAnswers,
    required int reachedIndex,
  }) async {
    final response = await _post('/api/leaderboard/save', {
      'playerName': playerName,
      'score': score,
      'startedAt': startedAt.toIso8601String(),
      'correctAnswers': correctAnswers,
      'reachedIndex': reachedIndex,
    });
    return SaveResultResponse.fromJson(response);
  }

  /// GET /api/leaderboard
  /// Returns the top 10 leaderboard entries.
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final uri = Uri.parse('$baseUrl/api/leaderboard');

    try {
      final response = await _client.get(uri, headers: _headers);
      _checkStatus(response);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final entries = (data['entries'] as List)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      return entries;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Cannot connect to the backend. Is the server running at $baseUrl?',
      );
    }
  }

  // =====================================================================
  // PRIVATE HELPERS
  // =====================================================================

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      _checkStatus(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Cannot connect to the backend. Is the server running at $baseUrl?',
      );
    }
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String message = 'HTTP ${response.statusCode}';
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      message = body['message'] as String? ?? message;
    } catch (_) {
      // Could not parse error body - use status code message
    }

    throw ApiException(message, statusCode: response.statusCode);
  }
}
