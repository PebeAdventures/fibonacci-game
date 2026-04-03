/// Represents the current state of an active game session.
/// This model is the single source of truth for game state in the frontend.
/// The backend is stateless - this state is sent with each answer request.
class GameState {
  final String playerName;
  final List<int> sequence;
  final int currentIndex;
  final int score;
  final int lives;
  final bool isGameOver;
  final bool isLoading;
  final String? lastMessage;
  final bool? lastAnswerCorrect;
  final DateTime startedAt;

  const GameState({
    required this.playerName,
    required this.sequence,
    required this.currentIndex,
    required this.score,
    required this.lives,
    required this.isGameOver,
    required this.isLoading,
    this.lastMessage,
    this.lastAnswerCorrect,
    required this.startedAt,
  });

  /// Maximum lives a player can have
  static const int maxLives = 3;

  /// Factory: creates fresh game state from backend start response
  factory GameState.initial({
    required String playerName,
    required List<int> sequence,
    required int currentIndex,
    required int lives,
    required int score,
  }) {
    return GameState(
      playerName: playerName,
      sequence: sequence,
      currentIndex: currentIndex,
      score: score,
      lives: lives,
      isGameOver: false,
      isLoading: false,
      lastMessage: null,
      lastAnswerCorrect: null,
      startedAt: DateTime.now().toUtc(),
    );
  }

  /// Creates a copy with modified fields - immutable state pattern
  GameState copyWith({
    String? playerName,
    List<int>? sequence,
    int? currentIndex,
    int? score,
    int? lives,
    bool? isGameOver,
    bool? isLoading,
    String? lastMessage,
    bool? lastAnswerCorrect,
    DateTime? startedAt,
  }) {
    return GameState(
      playerName: playerName ?? this.playerName,
      sequence: sequence ?? this.sequence,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      isGameOver: isGameOver ?? this.isGameOver,
      isLoading: isLoading ?? this.isLoading,
      lastMessage: lastMessage,
      lastAnswerCorrect: lastAnswerCorrect,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}
