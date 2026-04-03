namespace FibonacciGame.API.Services;

/// <summary>
/// Concrete implementation of the Fibonacci sequence logic.
/// Uses iterative approach to avoid stack overflow on large indices.
/// Registered as Singleton because it is stateless and computation is cheap.
/// </summary>
public class FibonacciService : IFibonacciService
{
    // Cache computed values to avoid redundant calculation per request
    private readonly Dictionary<int, long> _cache = new()
    {
        { 0, 0L },
        { 1, 1L }
    };

    /// <inheritdoc />
    public long GetFibonacciAt(int index)
    {
        if (index < 0)
            throw new ArgumentOutOfRangeException(nameof(index), "Index must be non-negative.");

        if (_cache.TryGetValue(index, out var cached))
            return cached;

        // Find the highest index already cached to avoid recomputing from scratch
        int startFrom = _cache.Keys.Max() + 1;

        long prev = _cache[startFrom - 2 >= 0 ? startFrom - 2 : 0];
        long curr = _cache[startFrom - 1];

        for (int i = startFrom; i <= index; i++)
        {
            long next = prev + curr;
            _cache[i] = next;
            prev = curr;
            curr = next;
        }

        return _cache[index];
    }

    /// <inheritdoc />
    public List<long> GetSequence(int count)
    {
        if (count <= 0)
            throw new ArgumentOutOfRangeException(nameof(count), "Count must be positive.");

        var result = new List<long>(count);
        for (int i = 0; i < count; i++)
        {
            result.Add(GetFibonacciAt(i));
        }
        return result;
    }

    /// <inheritdoc />
    public bool IsCorrectAnswer(int index, long answer)
    {
        return GetFibonacciAt(index) == answer;
    }
}
