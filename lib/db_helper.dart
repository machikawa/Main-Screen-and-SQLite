import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'quiz.dart';
import 'option.dart';

class DBHelper {
  static Database? _database;

  static Future<void> initializeDatabase() async {
    if (_database != null) return;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'quiz.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE quiz(id TEXT PRIMARY KEY, category TEXT, question TEXT, options TEXT)",
        );
        db.execute(
          "CREATE TABLE quiz_challenge(challengeId TEXT PRIMARY KEY, timestamp TEXT)",
        );
        db.execute(
          "CREATE TABLE quiz_history(id INTEGER PRIMARY KEY AUTOINCREMENT, challengeId TEXT, quizId TEXT, selectionNum INTEGER, correctAnsNum INTEGER)",
        );
        db.execute(
          "CREATE TABLE favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, quizId TEXT, addedDate TEXT, FOREIGN KEY(quizId) REFERENCES quiz(id))",
        );
      },
      version: 1,
    );

    // サンプルデータの挿入
    await _insertSampleData();
  }

  static Future<void> _insertSampleData() async {
    final sampleQuizzes = [
      Quiz(
        id: '1',
        category: 'AI',
        question: 'これはAIに関する質問です。',
        options: [
          Option(optionNumber: 1, optionText: 'AI選択肢1', isCorrect: false),
          Option(optionNumber: 2, optionText: 'AI選択肢2', isCorrect: true),
          Option(optionNumber: 3, optionText: 'AI選択肢3', isCorrect: false),
          Option(optionNumber: 4, optionText: 'AI選択肢4', isCorrect: false),
        ],
      ),
      Quiz(
        id: '2',
        category: 'MLうんこ',
        question: 'これはうんこ機械学習に関する質問です。',
        options: [
          Option(optionNumber: 1, optionText: 'ML選択肢1', isCorrect: true),
          Option(optionNumber: 2, optionText: 'ML選択肢2', isCorrect: false),
          Option(optionNumber: 3, optionText: 'ML選択肢3', isCorrect: false),
          Option(optionNumber: 4, optionText: 'ML選択肢4', isCorrect: false),
        ],
      ),
      Quiz(
        id: '3',
        category: 'Data Science',
        question: 'これはデータサイエンスに関する質問です。',
        options: [
          Option(optionNumber: 1, optionText: 'DS選択肢1', isCorrect: false),
          Option(optionNumber: 2, optionText: 'DS選択肢2', isCorrect: false),
          Option(optionNumber: 3, optionText: 'DS選択肢3', isCorrect: true),
          Option(optionNumber: 4, optionText: 'DS選択肢4', isCorrect: false),
        ],
      ),
    ];

    for (var quiz in sampleQuizzes) {
      final existingQuiz = await _database!.query(
        'quiz',
        where: 'id = ?',
        whereArgs: [quiz.id],
      );

      if (existingQuiz.isEmpty) {
        await _database!.insert(
          'quiz',
          quiz.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getQuizzes() async {
    return await _database!.query('quiz');
  }
}
