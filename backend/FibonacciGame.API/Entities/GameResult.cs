namespace FibonacciGame.API.Entities;

/// <summary>
/// Represents a completed game result persisted in the database.
/// Stores player information, score, and timing data.
/// </summary>
public class GameResult
{
    /// <summary>Primary key - auto-generated GUID</summary>
    public Guid Id { get; set; }

    /// <summary>Player's nickname or name entered before the game</summary>
    public string PlayerName { get; set; } = string.Empty;

    /// <summary>Total score earned during the session (correct answers count)</summary>
    public int Score { get; set; }

    /// <summary>UTC timestamp when the game started</summary>
    public DateTime StartedAt { get; set; }

    /// <summary>UTC timestamp when the game ended (player lost all lives)</summary>
    public DateTime FinishedAt { get; set; }

    /// <summary>How many Fibonacci numbers the player correctly guessed (equals Score for MVP)</summary>
    public int CorrectAnswers { get; set; }

    /// <summary>How far the player progressed in the sequence (index of last correct answer)</summary>
    public int ReachedIndex { get; set; }
}
