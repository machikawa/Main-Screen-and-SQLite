import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'quiz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initializeDatabase();
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isAnswered = false;
  bool _isCorrect = false;
  int _selectedOption = -1;
  int _currentQuestionIndex = 0;
  final double _correctRate = 75.0;
  List<Quiz> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final quizMaps = await DBHelper.getQuizzes();
    setState(() {
      _quizzes = quizMaps.map((quizMap) => Quiz.fromMap(quizMap)).toList();
    });
  }

  void _answerQuestion(bool isCorrect, int optionNumber) {
    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
      _selectedOption = optionNumber;
    });
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _isCorrect = false;
      _selectedOption = -1;
      if (_currentQuestionIndex < _quizzes.length - 1) {
        _currentQuestionIndex++;
      } else {
        _currentQuestionIndex = 0; // これで最後の質問の後に最初の質問に戻る
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      _isAnswered = false;
      _isCorrect = false;
      _selectedOption = -1;
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
    });
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('解答を終了しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextQuestion();
              },
              child: Text('はい'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('クイズプレイ'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 現在の問題数と正解率
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '問題 ${_currentQuestionIndex + 1} / ${_quizzes.length}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '正解率: $_correctRate%',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // クイズ質問文
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _quizzes.isNotEmpty
                      ? _quizzes[_currentQuestionIndex].question
                      : '読み込み中...',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              // クイズ選択肢
              if (_quizzes.isNotEmpty)
                Column(
                  children:
                      _quizzes[_currentQuestionIndex].options.map((option) {
                    return _buildOptionButton(option.optionText,
                        option.isCorrect, option.optionNumber);
                  }).toList(),
                ),
              SizedBox(height: 20),
              // フィードバックエリアと解説
              if (_isAnswered)
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCorrect ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _isCorrect ? '正解です！' : '不正解です。',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'これは解説文です。ダミーテキストとして表示しています。',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              // 前へボタン、次へボタン
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _currentQuestionIndex == 0 ? null : _previousQuestion,
                      child: Text('前へ'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentQuestionIndex == _quizzes.length - 1
                          ? _showEndDialog
                          : _nextQuestion,
                      child: Text(_currentQuestionIndex == _quizzes.length - 1
                          ? '終わる'
                          : '次へ'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, bool isCorrect, int optionNumber) {
    Color borderColor = Colors.grey;
    if (_isAnswered) {
      if (_selectedOption == optionNumber) {
        borderColor = isCorrect ? Colors.green : Colors.blue;
      } else if (isCorrect) {
        borderColor = Colors.green;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed:
            _isAnswered ? null : () => _answerQuestion(isCorrect, optionNumber),
        child: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
