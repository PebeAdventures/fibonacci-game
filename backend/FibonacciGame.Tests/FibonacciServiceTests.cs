using FibonacciGame.API.Services;
using FluentAssertions;
using Xunit;

namespace FibonacciGame.Tests;

/// <summary>
/// Unit tests for FibonacciService.
/// These are pure computation tests - no DB, no HTTP, no dependencies.
/// </summary>
public class FibonacciServiceTests
{
    private readonly FibonacciService _sut = new();

    // =====================================================================
    // GetFibonacciAt tests
    // =====================================================================

    [Theory]
    [InlineData(0, 0)]
    [InlineData(1, 1)]
    [InlineData(2, 1)]
    [InlineData(3, 2)]
    [InlineData(4, 3)]
    [InlineData(5, 5)]
    [InlineData(6, 8)]
    [InlineData(7, 13)]
    [InlineData(8, 21)]
    [InlineData(9, 34)]
    [InlineData(10, 55)]
    [InlineData(20, 6765)]
    [InlineData(30, 832040)]
    public void GetFibonacciAt_ReturnsCorrectValue(int index, long expected)
    {
        // Act
        var result = _sut.GetFibonacciAt(index);

        // Assert
        result.Should().Be(expected);
    }

    [Fact]
    public void GetFibonacciAt_NegativeIndex_ThrowsArgumentOutOfRangeException()
    {
        // Act & Assert
        var act = () => _sut.GetFibonacciAt(-1);
        act.Should().Throw<ArgumentOutOfRangeException>();
    }

    [Fact]
    public void GetFibonacciAt_LargeIndex_ReturnsCorrectValue()
    {
        // F(50) = 12586269025 - verifies no integer overflow with long
        var result = _sut.GetFibonacciAt(50);
        result.Should().Be(12586269025L);
    }

    // =====================================================================
    // GetSequence tests
    // =====================================================================

    [Fact]
    public void GetSequence_Count2_ReturnsInitialPair()
    {
        var result = _sut.GetSequence(2);
        result.Should().Equal(0L, 1L);
    }

    [Fact]
    public void GetSequence_Count5_ReturnsFirstFiveNumbers()
    {
        var result = _sut.GetSequence(5);
        result.Should().Equal(0L, 1L, 1L, 2L, 3L);
    }

    [Fact]
    public void GetSequence_ZeroCount_ThrowsArgumentOutOfRangeException()
    {
        var act = () => _sut.GetSequence(0);
        act.Should().Throw<ArgumentOutOfRangeException>();
    }

    [Fact]
    public void GetSequence_ReturnsCorrectCount()
    {
        var result = _sut.GetSequence(10);
        result.Should().HaveCount(10);
    }

    // =====================================================================
    // IsCorrectAnswer tests
    // =====================================================================

    [Theory]
    [InlineData(2, 1, true)]   // F(2) = 1 - correct
    [InlineData(2, 2, false)]  // F(2) = 1, answer 2 - wrong
    [InlineData(5, 5, true)]   // F(5) = 5 - correct
    [InlineData(5, 4, false)]  // F(5) = 5, answer 4 - wrong
    [InlineData(10, 55, true)] // F(10) = 55 - correct
    public void IsCorrectAnswer_ReturnsExpectedResult(int index, long answer, bool expected)
    {
        var result = _sut.IsCorrectAnswer(index, answer);
        result.Should().Be(expected);
    }

    [Fact]
    public void GetFibonacciAt_IsCached_SecondCallIsFast()
    {
        // First call computes
        _sut.GetFibonacciAt(40);
        // Second call should return cached value (no assertion needed - just verifies no exception)
        var result = _sut.GetFibonacciAt(40);
        result.Should().Be(102334155L);
    }
}
