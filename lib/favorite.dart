class Favorite {
  final int id;
  final String quizId;
  final String addedDate;

  Favorite({required this.id, required this.quizId, required this.addedDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quizId': quizId,
      'addedDate': addedDate,
    };
  }

  static Favorite fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      quizId: map['quizId'],
      addedDate: map['addedDate'],
    );
  }
}
