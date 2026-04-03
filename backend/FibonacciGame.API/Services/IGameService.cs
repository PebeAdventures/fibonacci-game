using FibonacciGame.API.DTOs;

namespace FibonacciGame.API.Services;

/// <summary>
/// Interface for game session logic.
/// Handles starting games and validating answers.
/// 
/// State management decision: Game state (current sequence, lives, score) is kept
/// entirely on the FRONTEND for simplicity. The backend is stateless per request.
/// The backend only validates answers and saves final results.
/// This avoids session storage, Redis, or DB per-move writes in MVP.
/// Trade-off: trust that the frontend sends accurate state (acceptable for local MVP).
/// </summary>
public interface IGameService
{
    /// <summary>
    /// Initializes a new game and returns the starting state.
    /// </summary>
    StartGameResponse StartGame(string playerName);

    /// <summary>
    /// Validates the player's answer for the given sequence index.
    /// Returns updated game state with feedback.
    /// </summary>
    /// <param name="request">Contains the player's answer and current game state index</param>
    /// <param name="currentScore">The player's current score before this answer</param>
    /// <param name="currentLives">The player's current lives before this answer</param>
    /// <param name="currentSequence">The sequence known so far (for building the response)</param>
    SubmitAnswerResponse ValidateAnswer(
        SubmitAnswerRequest request,
        int currentScore,
        int currentLives,
        List<long> currentSequence);
}
