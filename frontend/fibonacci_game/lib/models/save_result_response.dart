/// Response from the backend after saving a game result.
/// Contains the assigned rank so we can show the player their position.
class SaveResultResponse {
  final String id;
  final String playerName;
  final int score;
  final DateTime finishedAt;
  final int rank;

  const SaveResultResponse({
    required this.id,
    required this.playerName,
    required this.score,
    required this.finishedAt,
    required this.rank,
  });

  factory SaveResultResponse.fromJson(Map<String, dynamic> json) {
    return SaveResultResponse(
      id: json['id'] as String,
      playerName: json['playerName'] as String,
      score: json['score'] as int,
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      rank: json['rank'] as int,
    );
  }
}
