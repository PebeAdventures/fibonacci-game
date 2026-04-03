using FibonacciGame.API.DTOs;
using FibonacciGame.API.Services;
using Microsoft.AspNetCore.Mvc;

namespace FibonacciGame.API.Controllers;

/// <summary>
/// Handles game session operations: starting a game and validating answers.
/// Controllers are thin - no business logic here, only HTTP plumbing.
/// </summary>
[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public class GameController : ControllerBase
{
    private readonly IGameService _gameService;
    private readonly ILogger<GameController> _logger;

    public GameController(IGameService gameService, ILogger<GameController> logger)
    {
        _gameService = gameService;
        _logger = logger;
    }

    /// <summary>
    /// POST /api/game/start
    /// Starts a new game session for the given player.
    /// Returns the initial sequence [0, 1] and starting state.
    /// </summary>
    /// <example>
    /// Request:  { "playerName": "Jasiu" }
    /// Response: { "playerName": "Jasiu", "initialSequence": [0, 1], "currentIndex": 2, "lives": 3, "score": 0 }
    /// </example>
    [HttpPost("start")]
    [ProducesResponseType(typeof(StartGameResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status400BadRequest)]
    public IActionResult StartGame([FromBody] StartGameRequest request)
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

        _logger.LogInformation("Starting new game for player: {PlayerName}", request.PlayerName);
        var response = _gameService.StartGame(request.PlayerName);
        return Ok(response);
    }

    /// <summary>
    /// POST /api/game/answer
    /// Validates the player's answer for the current Fibonacci sequence position.
    /// The frontend sends its current game state along with the answer.
    /// 
    /// State management: Frontend owns the state (lives, score, sequence).
    /// Backend validates the answer and returns updated state.
    /// </summary>
    /// <example>
    /// Request:  { "answer": 1, "currentIndex": 2, "currentScore": 0, "currentLives": 3, "currentSequence": [0, 1] }
    /// Response: { "isCorrect": true, "message": "Correct!", "correctAnswer": 1, "score": 1, "lives": 3, "gameOver": false, "currentSequence": [0, 1, 1], "nextIndex": 3 }
    /// </example>
    [HttpPost("answer")]
    [ProducesResponseType(typeof(SubmitAnswerResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ErrorResponse), StatusCodes.Status400BadRequest)]
    public IActionResult SubmitAnswer([FromBody] AnswerWithStateRequest request)
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
            "Answer submitted: index={Index}, answer={Answer}, player lives={Lives}",
            request.CurrentIndex, request.Answer, request.CurrentLives);

        var answerRequest = new SubmitAnswerRequest(request.Answer, request.CurrentIndex);
        var response = _gameService.ValidateAnswer(
            answerRequest,
            request.CurrentScore,
            request.CurrentLives,
            request.CurrentSequence);

        return Ok(response);
    }
}
