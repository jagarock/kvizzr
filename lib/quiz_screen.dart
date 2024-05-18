import 'package:flutter/material.dart';
import 'dart:async';
import 'summary_screen.dart';
import 'question.dart';
import 'questions.dart'; // Import the questions

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({super.key, required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 10; // 10 seconds for each question
  Timer? _timer;
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _questions = getQuestionsByCategory(widget.category);
    _questions.shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _nextQuestion(null); // Move to the next question if time is up
        }
      });
    });
  }

  void _nextQuestion(String? selectedOption) {
    if (_timer != null) {
      _timer!.cancel();
    }

    if (selectedOption == _questions[_currentQuestionIndex].answer) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeLeft = 10; // Reset timer for next question
        _startTimer();
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SummaryScreen(questions: _questions, score: _score)),
      );
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KvizzR'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Question ${_currentQuestionIndex + 1} / ${_questions.length}'),
            const SizedBox(height: 10.0),
            Text('Score: $_score'),
            const SizedBox(height: 10.0),
            Text('Time left: $_timeLeft seconds'),
            const SizedBox(height: 20.0),
            Text(_questions[_currentQuestionIndex].question),
            const SizedBox(height: 20.0),
            if (_questions[_currentQuestionIndex].type ==
                QuestionType.multipleChoice)
              ..._questions[_currentQuestionIndex].options.map((option) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    onPressed: () => _nextQuestion(option),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                    ),
                    child: Text(option),
                  ),
                );
              })
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    _questions[_currentQuestionIndex].options.map((option) {
                  return ElevatedButton(
                    onPressed: () => _nextQuestion(option),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                    ),
                    child: Text(option),
                  );
                }).toList(),
              )
          ],
        ),
      ),
    );
  }
}
