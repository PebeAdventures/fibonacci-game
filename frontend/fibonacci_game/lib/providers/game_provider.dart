import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/save_result_response.dart';
import '../services/api_service.dart';

/// State management for the game screen using Provider + ChangeNotifier.
/// Sequence is stored as List<String> to preserve precision for large Fibonacci
/// numbers on Flutter Web (JavaScript 53-bit integer limit).
class GameProvider extends ChangeNotifier {
  final ApiService _api;

  GameProvider(this._api);

  GameState? _gameState;
  GameState? get gameState => _gameState;
  bool get hasActiveGame => _gameState != null && !(_gameState!.isGameOver);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SaveResultResponse? _savedResult;
  SaveResultResponse? get savedResult => _savedResult;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // =====================================================================
  // GAME ACTIONS
  // =====================================================================

  Future<void> startGame(String playerName) async {
    _setLoading(true);
    _errorMessage = null;
    _savedResult = null;
    notifyListeners();

    try {
      final data = await _api.startGame(playerName);

      // Sequence comes back as List<String> from ApiService
      final sequence = (data['initialSequence'] as List)
          .map((e) => e.toString())
          .toList();

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

  Future<void> submitAnswer(String answer) async {
    if (_gameState == null || _gameState!.isGameOver) return;

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
      final newSequence = (data['currentSequence'] as List)
          .map((e) => e.toString())
          .toList();
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

  void resetGame() {
    _gameState = null;
    _errorMessage = null;
    _savedResult = null;
    _isLoading = false;
    notifyListeners();
  }

  // =====================================================================
  // PRIVATE
  // =====================================================================

  Future<void> _saveResult() async {
    if (_gameState == null) return;
    try {
      _savedResult = await _api.saveResult(
        playerName: _gameState!.playerName,
        score: _gameState!.score,
        startedAt: _gameState!.startedAt,
        correctAnswers: _gameState!.score,
        reachedIndex: _gameState!.currentIndex,
      );
    } on ApiException catch (e) {
      _errorMessage =
          'Score saved locally but leaderboard submission failed: ${e.message}';
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
