class QuizChallenge {
  final String challengeId;
  final DateTime timestamp;

  QuizChallenge({required this.challengeId, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'challengeId': challengeId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static QuizChallenge fromMap(Map<String, dynamic> map) {
    return QuizChallenge(
      challengeId: map['challengeId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
