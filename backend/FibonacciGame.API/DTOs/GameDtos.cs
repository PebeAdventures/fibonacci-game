using System.ComponentModel.DataAnnotations;

namespace FibonacciGame.API.DTOs;

// =====================================================================
// REQUEST DTOs - incoming data from frontend
// =====================================================================

/// <summary>
/// Request to start a new game session.
/// </summary>
public record StartGameRequest(
    [Required]
    [StringLength(100, MinimumLength = 1, ErrorMessage = "Player name must be between 1 and 100 characters.")]
    string PlayerName
);

/// <summary>
/// Request to submit a player's answer for the next Fibonacci number.
/// </summary>
public record SubmitAnswerRequest(
    [Required]
    long Answer,

    [Required]
    [Range(2, int.MaxValue, ErrorMessage = "CurrentIndex must be at least 2 (the third number in sequence).")]
    int CurrentIndex
);

/// <summary>
/// Request to save the final game result when the player loses all lives.
/// </summary>
public record SaveResultRequest(
    [Required]
    [StringLength(100, MinimumLength = 1)]
    string PlayerName,

    [Required]
    [Range(0, int.MaxValue)]
    int Score,

    [Required]
    DateTime StartedAt,

    [Required]
    [Range(0, int.MaxValue)]
    int CorrectAnswers,

    [Required]
    [Range(0, int.MaxValue)]
    int ReachedIndex
);

// =====================================================================
// RESPONSE DTOs - outgoing data to frontend
// =====================================================================

/// <summary>
/// Response when a new game session is started.
/// Contains the initial Fibonacci sequence state.
/// </summary>
public record StartGameResponse(
    string PlayerName,
    List<long> InitialSequence,
    int CurrentIndex,
    int Lives,
    int Score
);

/// <summary>
/// Response after the player submits an answer.
/// </summary>
public record SubmitAnswerResponse(
    bool IsCorrect,
    string Message,
    long CorrectAnswer,
    int Score,
    int Lives,
    bool GameOver,
    List<long> CurrentSequence,
    int NextIndex
);

/// <summary>
/// Represents a single leaderboard entry in the top 10.
/// </summary>
public record LeaderboardEntry(
    int Rank,
    string PlayerName,
    int Score,
    int ReachedIndex,
    DateTime FinishedAt,
    long DurationSeconds
);

/// <summary>
/// Response containing the top 10 leaderboard entries.
/// </summary>
public record LeaderboardResponse(
    List<LeaderboardEntry> Entries,
    DateTime GeneratedAt
);

/// <summary>
/// Response after successfully saving a game result.
/// </summary>
public record SaveResultResponse(
    Guid Id,
    string PlayerName,
    int Score,
    DateTime FinishedAt,
    int Rank
);

/// <summary>
/// Generic error response for consistent error handling across all endpoints.
/// </summary>
public record ErrorResponse(
    string Error,
    string Message,
    int StatusCode
);
