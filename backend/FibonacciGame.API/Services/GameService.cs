using FibonacciGame.API.DTOs;

namespace FibonacciGame.API.Services;

/// <summary>
/// Implements the core game logic.
/// The backend is stateless - state flows from frontend to backend on each request.
/// This is the correct design for a simple, locally-run MVP with no authentication.
/// </summary>
public class GameService : IGameService
{
    private readonly IFibonacciService _fibonacciService;

    // Game constants
    private const int InitialLives = 3;
    private const int InitialSequenceLength = 2; // Show F(0)=0 and F(1)=1 at start

    public GameService(IFibonacciService fibonacciService)
    {
        _fibonacciService = fibonacciService;
    }

    /// <inheritdoc />
    public StartGameResponse StartGame(string playerName)
    {
        // Return initial sequence: [0, 1]
        var initialSequence = _fibonacciService.GetSequence(InitialSequenceLength);

        return new StartGameResponse(
            PlayerName: playerName.Trim(),
            InitialSequence: initialSequence,
            CurrentIndex: InitialSequenceLength, // Next expected index is 2 (F(2) = 1)
            Lives: InitialLives,
            Score: 0
        );
    }

    /// <inheritdoc />
    public SubmitAnswerResponse ValidateAnswer(
        SubmitAnswerRequest request,
        int currentScore,
        int currentLives,
        List<long> currentSequence)
    {
        bool isCorrect = _fibonacciService.IsCorrectAnswer(request.CurrentIndex, request.Answer);
        long correctAnswer = _fibonacciService.GetFibonacciAt(request.CurrentIndex);

        if (isCorrect)
        {
            // Add the correct number to the sequence
            var updatedSequence = new List<long>(currentSequence) { correctAnswer };
            int newScore = currentScore + 1;
            int nextIndex = request.CurrentIndex + 1;

            return new SubmitAnswerResponse(
                IsCorrect: true,
                Message: "Correct! Well done!",
                CorrectAnswer: correctAnswer,
                Score: newScore,
                Lives: currentLives,
                GameOver: false,
                CurrentSequence: updatedSequence,
                NextIndex: nextIndex
            );
        }
        else
        {
            // Wrong answer - lose a life
            int newLives = currentLives - 1;
            bool gameOver = newLives <= 0;

            string message = gameOver
                ? $"Game over! The correct answer was {correctAnswer}. You scored {currentScore} points!"
                : $"Wrong answer! The correct number was {correctAnswer}. You have {newLives} life/lives remaining.";

            return new SubmitAnswerResponse(
                IsCorrect: false,
                Message: message,
                CorrectAnswer: correctAnswer,
                Score: currentScore,
                Lives: newLives,
                GameOver: gameOver,
                CurrentSequence: currentSequence, // Sequence does not grow on wrong answer
                NextIndex: request.CurrentIndex   // Stay on same index - player can retry
            );
        }
    }
}
