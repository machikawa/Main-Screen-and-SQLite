class QuizHistory {
  final int id;
  final String challengeId;
  final String quizId;
  final int selectionNum;
  final int correctAnsNum;

  QuizHistory(
      {required this.id,
      required this.challengeId,
      required this.quizId,
      required this.selectionNum,
      required this.correctAnsNum});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'challengeId': challengeId,
      'quizId': quizId,
      'selectionNum': selectionNum,
      'correctAnsNum': correctAnsNum,
    };
  }

  static QuizHistory fromMap(Map<String, dynamic> map) {
    return QuizHistory(
      id: map['id'],
      challengeId: map['challengeId'],
      quizId: map['quizId'],
      selectionNum: map['selectionNum'],
      correctAnsNum: map['correctAnsNum'],
    );
  }
}
