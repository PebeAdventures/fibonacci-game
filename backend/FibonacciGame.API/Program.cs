using FibonacciGame.API.Data;
using FibonacciGame.API.Middleware;
using FibonacciGame.API.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// =====================================================================
// SERVICE REGISTRATION (Dependency Injection)
// =====================================================================

// Add controllers with JSON camelCase formatting
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;
        options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
    });

// Swagger / OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
    {
        Title = "Fibonacci Game API",
        Version = "v1",
        Description = "REST API for the Fibonacci Sequence Guessing Game"
    });
});

// Entity Framework Core with SQLite
// Database file: fibonacci_game.db in the project root
builder.Services.AddDbContext<AppDbContext>(options =>
{
    var dbPath = Path.Combine(AppContext.BaseDirectory, "fibonacci_game.db");
    options.UseSqlite($"Data Source={dbPath}");
    options.EnableSensitiveDataLogging(builder.Environment.IsDevelopment());
});

// Application services - registered as Scoped (per HTTP request)
builder.Services.AddSingleton<IFibonacciService, FibonacciService>(); // Stateless math - Singleton is correct
builder.Services.AddScoped<IGameService, GameService>();               // Per-request, uses FibonacciService
builder.Services.AddScoped<ILeaderboardService, LeaderboardService>(); // Per-request, uses DbContext

// CORS - Allow Flutter Web frontend running on localhost:5555
// In development, allow all localhost ports for convenience
builder.Services.AddCors(options =>
{
    options.AddPolicy("FlutterWebPolicy", policy =>
    {
        policy
            .WithOrigins(
                "http://localhost:5555",
                "http://localhost:5556",
                "http://127.0.0.1:5555",
                "http://127.0.0.1:5556"
            )
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials();
    });

    // More permissive policy for development only
    options.AddPolicy("DevelopmentPolicy", policy =>
    {
        policy
            .SetIsOriginAllowed(origin =>
            {
                var uri = new Uri(origin);
                return uri.Host == "localhost" || uri.Host == "127.0.0.1";
            })
            .AllowAnyMethod()
            .AllowAnyHeader()
            .AllowCredentials();
    });
});

// Logging
builder.Logging.ClearProviders();
builder.Logging.AddConsole();

var app = builder.Build();

// =====================================================================
// MIDDLEWARE PIPELINE
// =====================================================================

// Global exception handling - must be first in pipeline
app.UseMiddleware<GlobalExceptionMiddleware>();

// Development-specific middleware
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Fibonacci Game API v1");
        c.RoutePrefix = "swagger";
    });
}

// CORS - must be before controllers
// Using DevelopmentPolicy for easy local dev; switch to FlutterWebPolicy for stricter control
app.UseCors("DevelopmentPolicy");

app.UseRouting();
app.UseAuthorization();
app.MapControllers();

// =====================================================================
// DATABASE INITIALIZATION
// =====================================================================
// Auto-apply migrations on startup to simplify local development
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();

    try
    {
        db.Database.Migrate();
        logger.LogInformation("Database migrations applied successfully. DB path: {Path}",
            Path.Combine(AppContext.BaseDirectory, "fibonacci_game.db"));
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Failed to apply database migrations.");
        throw;
    }
}

app.Logger.LogInformation("Fibonacci Game API started. Swagger at: http://localhost:5000/swagger");
app.Run();
