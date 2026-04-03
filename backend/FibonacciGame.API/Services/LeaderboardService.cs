using FibonacciGame.API.Data;
using FibonacciGame.API.DTOs;
using FibonacciGame.API.Entities;
using Microsoft.EntityFrameworkCore;

namespace FibonacciGame.API.Services;

/// <summary>
/// Handles persisting game results and building the leaderboard.
/// 
/// Repository pattern decision: For this MVP with a single entity and simple
/// queries, a Repository layer would add complexity without value.
/// The service directly uses AppDbContext, which is already an abstraction over
/// the database. This keeps the code readable and easy to follow.
/// </summary>
public class LeaderboardService : ILeaderboardService
{
    private readonly AppDbContext _db;
    private const int LeaderboardSize = 10;

    public LeaderboardService(AppDbContext db)
    {
        _db = db;
    }

    /// <inheritdoc />
    public async Task<SaveResultResponse> SaveResultAsync(SaveResultRequest request, CancellationToken cancellationToken = default)
    {
        var result = new GameResult
        {
            Id = Guid.NewGuid(),
            PlayerName = request.PlayerName.Trim(),
            Score = request.Score,
            StartedAt = request.StartedAt.ToUniversalTime(),
            FinishedAt = DateTime.UtcNow,
            CorrectAnswers = request.CorrectAnswers,
            ReachedIndex = request.ReachedIndex
        };

        _db.GameResults.Add(result);
        await _db.SaveChangesAsync(cancellationToken);

        // Calculate player's rank on the leaderboard
        int rank = await _db.GameResults
            .CountAsync(r => r.Score > result.Score, cancellationToken) + 1;

        return new SaveResultResponse(
            Id: result.Id,
            PlayerName: result.PlayerName,
            Score: result.Score,
            FinishedAt: result.FinishedAt,
            Rank: rank
        );
    }

    /// <inheritdoc />
   public async Task<LeaderboardResponse> GetLeaderboardAsync(CancellationToken cancellationToken = default)
{
    // Fetch top candidates ordered by score (SQL-safe query).
    // ThenBy duration is done in memory after ToListAsync because
    // EF Core / SQLite cannot translate TimeSpan arithmetic to SQL.
    var topResults = await _db.GameResults
        .OrderByDescending(r => r.Score)
        .Take(LeaderboardSize)
        .ToListAsync(cancellationToken);

    // In-memory sort: same score → shorter game session ranks higher
    var sorted = topResults
        .OrderByDescending(r => r.Score)
        .ThenBy(r => (r.FinishedAt - r.StartedAt).TotalSeconds)
        .ToList();

    var entries = sorted.Select((result, index) => new LeaderboardEntry(
        Rank: index + 1,
        PlayerName: result.PlayerName,
        Score: result.Score,
        ReachedIndex: result.ReachedIndex,
        FinishedAt: result.FinishedAt,
        DurationSeconds: (long)(result.FinishedAt - result.StartedAt).TotalSeconds
    )).ToList();

    return new LeaderboardResponse(
        Entries: entries,
        GeneratedAt: DateTime.UtcNow
    );
}
}
