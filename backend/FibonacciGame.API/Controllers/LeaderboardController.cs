using FibonacciGame.API.DTOs;
using FibonacciGame.API.Services;
using Microsoft.AspNetCore.Mvc;

namespace FibonacciGame.API.Controllers;

/// <summary>
/// Handles leaderboard operations: saving results and retrieving top scores.
/// </summary>
[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public class LeaderboardController : ControllerBase
{
    private readonly ILeaderboardService _leaderboardService;
    private readonly ILogger<LeaderboardController> _logger;

    public LeaderboardController(ILeaderboardService leaderboardService, ILogger<LeaderboardController> logger)
    {
        _leaderboardService = leaderboardService;
        _logger = logger;
    }

    /// <summary>
    /// POST /api/leaderboard/save
    /// Saves a completed game result to the database.
    /// Called by frontend when the player loses all lives.
    /// </summary>
    /// <example>
    /// Request:  { "playerName": "Jasiu", "score": 5, "startedAt": "2024-01-01T10:00:00Z", "correctAnswers": 5, "reachedIndex": 6 }
    /// Response: { "id": "guid", "playerName": "Jasiu", "score": 5, "finishedAt": "...", "rank": 3 }
    /// </example>
    [HttpPost("save")]
    [ProducesResponseType(typeof(SaveResultResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> SaveResult([FromBody] SaveResultRequest request, CancellationToken cancellationToken)
    {
        if (!ModelState.IsValid)
        {
            var errors = ModelState.Values
                .SelectMany(v => v.Errors)
                .Select(e => e.ErrorMessage)
                .ToList();

            return BadRequest(new ErrorResponse(
                Error: "ValidationError",
                Message: string.Join("; ", errors),
                StatusCode: 400
            ));
        }

        _logger.LogInformation(
            "Saving result for player: {PlayerName}, score: {Score}",
            request.PlayerName, request.Score);

        var response = await _leaderboardService.SaveResultAsync(request, cancellationToken);
        return CreatedAtAction(nameof(SaveResult), new { id = response.Id }, response);
    }

    /// <summary>
    /// GET /api/leaderboard
    /// Returns the top 10 game results ordered by score descending.
    /// </summary>
    /// <example>
    /// Response: { "entries": [{ "rank": 1, "playerName": "Jasiu", "score": 10, ... }], "generatedAt": "..." }
    /// </example>
    [HttpGet]
    [ProducesResponseType(typeof(LeaderboardResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetLeaderboard(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Leaderboard requested");
        var response = await _leaderboardService.GetLeaderboardAsync(cancellationToken);
        return Ok(response);
    }
}
