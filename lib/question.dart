class Question {
  final String question;
  final List<String> options;
  final String answer;
  final QuestionType type;
  final String category;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.type,
    required this.category,
  });
}

enum QuestionType {
  multipleChoice,
  trueFalse,
}
