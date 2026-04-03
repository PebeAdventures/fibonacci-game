import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/save_result_response.dart';
import '../services/api_service.dart';

/// State management for the game screen using Provider + ChangeNotifier.
///
/// Why Provider?
/// - Simple and well-established Flutter pattern
/// - ChangeNotifier is sufficient for this linear game flow
/// - No need for Bloc/Riverpod complexity in an MVP with 3 screens
/// - Easy to test with MockApiService
///
/// This provider owns:
/// - Active game state (sequence, lives, score)
/// - Loading/error states
/// - Communication with ApiService
class GameProvider extends ChangeNotifier {
  final ApiService _api;

  GameProvider(this._api);

  // Current game state - null means no active game
  GameState? _gameState;
  GameState? get gameState => _gameState;
  bool get hasActiveGame => _gameState != null && !(_gameState!.isGameOver);

  // Error message displayed to user
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Result after saving to leaderboard
  SaveResultResponse? _savedResult;
  SaveResultResponse? get savedResult => _savedResult;

  // Loading state for network requests
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // =====================================================================
  // GAME ACTIONS
  // =====================================================================

  /// Starts a new game for the given player name.
  /// Calls POST /api/game/start and initializes game state.
  Future<void> startGame(String playerName) async {
    _setLoading(true);
    _errorMessage = null;
    _savedResult = null;
    notifyListeners();

    try {
      final data = await _api.startGame(playerName);

      final rawSequence = data['initialSequence'] as List;
      final sequence = rawSequence.map((e) => (e as num).toInt()).toList();

      _gameState = GameState.initial(
        playerName: data['playerName'] as String,
        sequence: sequence,
        currentIndex: data['currentIndex'] as int,
        lives: data['lives'] as int,
        score: data['score'] as int,
      );
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _gameState = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Submits the player's answer for the current sequence position.
  /// Calls POST /api/game/answer and updates game state.
  /// If the game is over, automatically saves the result.
  Future<void> submitAnswer(int answer) async {
    if (_gameState == null || _gameState!.isGameOver) return;

    // Set loading state without losing current game info
    _gameState = _gameState!.copyWith(isLoading: true);
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.submitAnswer(
        answer: answer,
        currentIndex: _gameState!.currentIndex,
        currentScore: _gameState!.score,
        currentLives: _gameState!.lives,
        currentSequence: _gameState!.sequence,
      );

      final isCorrect = data['isCorrect'] as bool;
      final message = data['message'] as String;
      final newScore = data['score'] as int;
      final newLives = data['lives'] as int;
      final gameOver = data['gameOver'] as bool;
      final rawSeq = data['currentSequence'] as List;
      final newSequence = rawSeq.map((e) => (e as num).toInt()).toList();
      final nextIndex = data['nextIndex'] as int;

      _gameState = _gameState!.copyWith(
        sequence: newSequence,
        currentIndex: nextIndex,
        score: newScore,
        lives: newLives,
        isGameOver: gameOver,
        isLoading: false,
        lastMessage: message,
        lastAnswerCorrect: isCorrect,
      );

      // If game is over, save result to leaderboard
      if (gameOver) {
        await _saveResult();
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _gameState = _gameState!.copyWith(isLoading: false);
    } finally {
      _setLoading(false);
    }
  }

  /// Resets provider state for a completely new game session.
  void resetGame() {
    _gameState = null;
    _errorMessage = null;
    _savedResult = null;
    _isLoading = false;
    notifyListeners();
  }

  // =====================================================================
  // PRIVATE HELPERS
  // =====================================================================

  /// Saves the completed game result to the backend leaderboard.
  Future<void> _saveResult() async {
    if (_gameState == null) return;

    try {
      _savedResult = await _api.saveResult(
        playerName: _gameState!.playerName,
        score: _gameState!.score,
        startedAt: _gameState!.startedAt,
        correctAnswers: _gameState!.score, // Score equals correct answers in MVP
        reachedIndex: _gameState!.currentIndex,
      );
    } on ApiException catch (e) {
      // Not critical - game result is shown but not saved to leaderboard
      _errorMessage = 'Score saved locally but failed to submit to leaderboard: ${e.message}';
    }

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
