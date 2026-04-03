using System.Net;
using System.Text.Json;
using FibonacciGame.API.DTOs;

namespace FibonacciGame.API.Middleware;

/// <summary>
/// Global exception handling middleware.
/// Catches any unhandled exception and returns a consistent JSON error response.
/// This prevents stack traces from leaking to the client.
/// </summary>
public class GlobalExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionMiddleware> _logger;

    public GlobalExceptionMiddleware(RequestDelegate next, ILogger<GlobalExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (ArgumentOutOfRangeException ex)
        {
            _logger.LogWarning(ex, "Argument out of range: {Message}", ex.Message);
            await WriteErrorResponse(context, HttpStatusCode.BadRequest, "InvalidArgument", ex.Message);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception occurred");
            await WriteErrorResponse(
                context,
                HttpStatusCode.InternalServerError,
                "InternalServerError",
                "An unexpected error occurred. Please try again.");
        }
    }

    private static async Task WriteErrorResponse(
        HttpContext context,
        HttpStatusCode statusCode,
        string error,
        string message)
    {
        context.Response.StatusCode = (int)statusCode;
        context.Response.ContentType = "application/json";

        var errorResponse = new ErrorResponse(
            Error: error,
            Message: message,
            StatusCode: (int)statusCode
        );

        var json = JsonSerializer.Serialize(errorResponse, new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        });

        await context.Response.WriteAsync(json);
    }
}
