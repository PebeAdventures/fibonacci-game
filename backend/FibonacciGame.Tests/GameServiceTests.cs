using FibonacciGame.API.DTOs;
using FibonacciGame.API.Services;
using FluentAssertions;
using Xunit;

namespace FibonacciGame.Tests;

/// <summary>
/// Unit tests for GameService.
/// Tests game logic: starting games, correct/wrong answers, lives, game over.
/// </summary>
public class GameServiceTests
{
    private readonly GameService _sut;

    public GameServiceTests()
    {
        _sut = new GameService(new FibonacciService());
    }

    // =====================================================================
    // StartGame tests
    // =====================================================================

    [Fact]
    public void StartGame_ValidName_ReturnsInitialState()
    {
        var response = _sut.StartGame("Jasiu");

        response.PlayerName.Should().Be("Jasiu");
        response.InitialSequence.Should().Equal(new List<long> { 0, 1 });
        response.CurrentIndex.Should().Be(2); // Next to guess: F(2) = 1
        response.Lives.Should().Be(3);
        response.Score.Should().Be(0);
    }

    [Fact]
    public void StartGame_TrimsPlayerName()
    {
        var response = _sut.StartGame("  Jasiu  ");
        response.PlayerName.Should().Be("Jasiu");
    }

    // =====================================================================
    // ValidateAnswer - Correct answer tests
    // =====================================================================

    [Fact]
    public void ValidateAnswer_CorrectAnswer_ScoreIncreases()
    {
        var request = new SubmitAnswerRequest(Answer: 1, CurrentIndex: 2); // F(2) = 1
        var response = _sut.ValidateAnswer(request, 0, 3, new List<long> { 0, 1 });

        response.IsCorrect.Should().BeTrue();
        response.Score.Should().Be(1);
        response.Lives.Should().Be(3); // Lives unchanged
        response.GameOver.Should().BeFalse();
    }

    [Fact]
    public void ValidateAnswer_CorrectAnswer_SequenceGrows()
    {
        var request = new SubmitAnswerRequest(Answer: 1, CurrentIndex: 2); // F(2) = 1
        var response = _sut.ValidateAnswer(request, 0, 3, new List<long> { 0, 1 });

        response.CurrentSequence.Should().Equal(new List<long> { 0, 1, 1 });
        response.NextIndex.Should().Be(3);
    }

    [Fact]
    public void ValidateAnswer_CorrectAnswer_AtF5_Returns5()
    {
        var request = new SubmitAnswerRequest(Answer: 5, CurrentIndex: 5); // F(5) = 5
        var response = _sut.ValidateAnswer(request, 3, 3, new List<long> { 0, 1, 1, 2, 3 });

        response.IsCorrect.Should().BeTrue();
        response.CorrectAnswer.Should().Be(5);
    }

    // =====================================================================
    // ValidateAnswer - Wrong answer tests
    // =====================================================================

    [Fact]
    public void ValidateAnswer_WrongAnswer_LivesDecrease()
    {
        var request = new SubmitAnswerRequest(Answer: 99, CurrentIndex: 2); // F(2) = 1, not 99
        var response = _sut.ValidateAnswer(request, 0, 3, new List<long> { 0, 1 });

        response.IsCorrect.Should().BeFalse();
        response.Lives.Should().Be(2);
        response.Score.Should().Be(0); // Score unchanged
    }

    [Fact]
    public void ValidateAnswer_WrongAnswer_SequenceDoesNotGrow()
    {
        var initialSequence = new List<long> { 0, 1 };
        var request = new SubmitAnswerRequest(Answer: 99, CurrentIndex: 2);
        var response = _sut.ValidateAnswer(request, 0, 3, initialSequence);

        // Sequence should not change
        response.CurrentSequence.Should().Equal(initialSequence);
        // Index stays the same (player can retry)
        response.NextIndex.Should().Be(2);
    }

    [Fact]
    public void ValidateAnswer_LastLife_GameOver()
    {
        var request = new SubmitAnswerRequest(Answer: 99, CurrentIndex: 2);
        var response = _sut.ValidateAnswer(request, 5, 1, new List<long> { 0, 1 });

        response.Lives.Should().Be(0);
        response.GameOver.Should().BeTrue();
    }

    [Fact]
    public void ValidateAnswer_WrongAnswer_ReturnsCorrectAnswerInResponse()
    {
        var request = new SubmitAnswerRequest(Answer: 99, CurrentIndex: 5); // F(5) = 5
        var response = _sut.ValidateAnswer(request, 0, 3, new List<long> { 0, 1, 1, 2, 3 });

        response.CorrectAnswer.Should().Be(5);
    }

    // =====================================================================
    // Game flow scenario tests
    // =====================================================================

    [Fact]
    public void FullGameScenario_ThreeWrongAnswers_GameOver()
    {
        var sequence = new List<long> { 0, 1 };
        int score = 0;
        int lives = 3;
        bool gameOver = false;

        // Wrong answer 1
        var r1 = _sut.ValidateAnswer(
            new SubmitAnswerRequest(99, 2), score, lives, sequence);
        lives = r1.Lives;
        gameOver = r1.GameOver;
        r1.Lives.Should().Be(2);
        r1.GameOver.Should().BeFalse();

        // Wrong answer 2
        var r2 = _sut.ValidateAnswer(
            new SubmitAnswerRequest(99, 2), score, lives, sequence);
        lives = r2.Lives;
        r2.Lives.Should().Be(1);
        r2.GameOver.Should().BeFalse();

        // Wrong answer 3 - game over
        var r3 = _sut.ValidateAnswer(
            new SubmitAnswerRequest(99, 2), score, lives, sequence);
        r3.Lives.Should().Be(0);
        r3.GameOver.Should().BeTrue();
    }

    [Fact]
    public void FullGameScenario_FiveCorrectAnswers_ScoreIs5()
    {
        var sequence = new List<long> { 0, 1 };
        int score = 0;
        int index = 2;
        int lives = 3;

        // F(2)=1, F(3)=2, F(4)=3, F(5)=5, F(6)=8
        var correctAnswers = new long[] { 1, 2, 3, 5, 8 };

        foreach (var answer in correctAnswers)
        {
            var r = _sut.ValidateAnswer(
                new SubmitAnswerRequest(answer, index), score, lives, sequence);
            r.IsCorrect.Should().BeTrue($"F({index}) should be {answer}");
            score = r.Score;
            sequence = r.CurrentSequence;
            index = r.NextIndex;
        }

        score.Should().Be(5);
        index.Should().Be(7); // Next expected: F(7) = 13
    }
}
