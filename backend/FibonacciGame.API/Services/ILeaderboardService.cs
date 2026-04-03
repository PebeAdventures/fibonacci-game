using FibonacciGame.API.DTOs;

namespace FibonacciGame.API.Services;

/// <summary>
/// Interface for leaderboard operations.
/// Handles saving game results and retrieving top scores.
/// </summary>
public interface ILeaderboardService
{
    /// <summary>
    /// Saves a completed game result to the database.
    /// Returns the saved result with rank information.
    /// </summary>
    Task<SaveResultResponse> SaveResultAsync(SaveResultRequest request, CancellationToken cancellationToken = default);

    /// <summary>
    /// Returns the top 10 game results ordered by score descending, then by fastest time.
    /// </summary>
    Task<LeaderboardResponse> GetLeaderboardAsync(CancellationToken cancellationToken = default);
}
