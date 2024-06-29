import 'dart:convert';
import 'option.dart';

class Quiz {
  final String id;
  final String category;
  final String question;
  final List<Option> options;

  Quiz({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'options': jsonEncode(options.map((e) => e.toMap()).toList()),
    };
  }

  static Quiz fromMap(Map<String, dynamic> map) {
    var options = (jsonDecode(map['options']) as List)
        .map((e) => Option.fromMap(e))
        .toList();
    return Quiz(
      id: map['id'],
      category: map['category'],
      question: map['question'],
      options: options,
    );
  }
}
