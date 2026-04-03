/// Represents a single entry in the leaderboard (top 10 results).
/// Maps directly to the LeaderboardEntry DTO from the backend.
class LeaderboardEntry {
  final int rank;
  final String playerName;
  final int score;
  final int reachedIndex;
  final DateTime finishedAt;
  final int durationSeconds;

  const LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.score,
    required this.reachedIndex,
    required this.finishedAt,
    required this.durationSeconds,
  });

  /// Parses a JSON map from the backend API response
  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      playerName: json['playerName'] as String,
      score: json['score'] as int,
      reachedIndex: json['reachedIndex'] as int,
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
    );
  }

  /// Returns formatted duration string, e.g. "1m 23s"
  String get formattedDuration {
    if (durationSeconds < 60) return '${durationSeconds}s';
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}
