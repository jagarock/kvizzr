import 'package:flutter/material.dart';
import 'question.dart';

class SummaryScreen extends StatelessWidget {
  final List<Question> questions;
  final int score;

  const SummaryScreen({super.key, required this.questions, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KvizzR Resultat'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your score is $score'),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'Question ${index + 1}: ${questions[index].question}'),
                    subtitle: Text('Answer: ${questions[index].answer}'),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retake Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
