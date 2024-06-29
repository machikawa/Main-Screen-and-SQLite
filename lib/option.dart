class Option {
  final int optionNumber;
  final String optionText;
  final bool isCorrect;

  Option({
    required this.optionNumber,
    required this.optionText,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap() {
    return {
      'optionNumber': optionNumber,
      'optionText': optionText,
      'isCorrect': isCorrect,
    };
  }

  static Option fromMap(Map<String, dynamic> map) {
    return Option(
      optionNumber: map['optionNumber'],
      optionText: map['optionText'],
      isCorrect: map['isCorrect'],
    );
  }
}
