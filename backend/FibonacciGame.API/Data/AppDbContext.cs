using FibonacciGame.API.Entities;
using Microsoft.EntityFrameworkCore;

namespace FibonacciGame.API.Data;

/// <summary>
/// Entity Framework Core database context for the Fibonacci Game.
/// Uses SQLite as a simple file-based database for local development.
/// </summary>
public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    /// <summary>Table storing all completed game results</summary>
    public DbSet<GameResult> GameResults { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<GameResult>(entity =>
        {
            entity.HasKey(e => e.Id);

            // Auto-generate GUID on insert
            entity.Property(e => e.Id)
                .HasDefaultValueSql("lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))");

            // Player name: required, max 100 characters
            entity.Property(e => e.PlayerName)
                .IsRequired()
                .HasMaxLength(100);

            // Score cannot be negative
            entity.Property(e => e.Score)
                .HasDefaultValue(0);

            entity.Property(e => e.CorrectAnswers)
                .HasDefaultValue(0);

            entity.Property(e => e.ReachedIndex)
                .HasDefaultValue(0);

            // Index on player name for leaderboard queries
            entity.HasIndex(e => e.PlayerName)
                .HasDatabaseName("IX_GameResults_PlayerName");

            // Index on score for TOP 10 leaderboard ordering
            entity.HasIndex(e => e.Score)
                .HasDatabaseName("IX_GameResults_Score");
        });
    }
}
