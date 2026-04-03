namespace FibonacciGame.API.Services;

/// <summary>
/// Interface for Fibonacci sequence calculations.
/// Separated into its own interface to allow unit testing and future swapping of implementations.
/// </summary>
public interface IFibonacciService
{
    /// <summary>
    /// Returns the Fibonacci number at the given index (0-based).
    /// F(0) = 0, F(1) = 1, F(2) = 1, F(3) = 2, ...
    /// </summary>
    /// <param name="index">Zero-based index in the Fibonacci sequence</param>
    /// <returns>The Fibonacci number at that position</returns>
    long GetFibonacciAt(int index);

    /// <summary>
    /// Returns the first 'count' numbers of the Fibonacci sequence starting from index 0.
    /// </summary>
    /// <param name="count">How many numbers to return</param>
    /// <returns>List of Fibonacci numbers starting from F(0)</returns>
    List<long> GetSequence(int count);

    /// <summary>
    /// Checks if the provided answer matches the Fibonacci number at the given index.
    /// </summary>
    /// <param name="index">The index in the sequence being guessed</param>
    /// <param name="answer">The player's answer</param>
    /// <returns>True if correct, false otherwise</returns>
    bool IsCorrectAnswer(int index, long answer);
}
