using System.ComponentModel.DataAnnotations;

namespace FibonacciGame.API.DTOs;

/// <summary>
/// Extended answer request that includes full client-side game state.
/// This allows the backend to remain stateless while validating answers in context.
/// The frontend is the source of truth for the game state in this MVP.
/// </summary>
public record AnswerWithStateRequest(
    [Required]
    long Answer,

    [Required]
    [Range(2, int.MaxValue, ErrorMessage = "CurrentIndex must be >= 2")]
    int CurrentIndex,

    [Required]
    [Range(0, int.MaxValue)]
    int CurrentScore,

    [Required]
    [Range(0, 3)]
    int CurrentLives,

    [Required]
    List<long> CurrentSequence
);
