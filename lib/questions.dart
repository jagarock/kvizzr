import 'question.dart';

List<Question> allQuestions = [
  // Musikk
  Question(
    question: 'Who is known as the King of Pop?',
    options: ['Elvis Presley', 'Michael Jackson', 'Prince', 'Madonna'],
    answer: 'Michael Jackson',
    type: QuestionType.multipleChoice,
    category: 'Musikk',
  ),
  Question(
    question: 'What is the highest vocal range for female singers?',
    options: ['Alto', 'Soprano', 'Mezzo-soprano', 'Contralto'],
    answer: 'Soprano',
    type: QuestionType.multipleChoice,
    category: 'Musikk',
  ),
  // Teknologi
  Question(
    question: 'Who is known as the father of computers?',
    options: ['Charles Babbage', 'Alan Turing', 'Bill Gates', 'Steve Jobs'],
    answer: 'Charles Babbage',
    type: QuestionType.multipleChoice,
    category: 'Teknologi',
  ),
  Question(
    question: 'What does HTTP stand for?',
    options: ['HyperText Transfer Protocol', 'HyperText Transmission Protocol', 'HighText Transfer Protocol', 'HighText Transmission Protocol'],
    answer: 'HyperText Transfer Protocol',
    type: QuestionType.multipleChoice,
    category: 'Teknologi',
  ),
  // Verdensrommet
  Question(
    question: 'What is the largest planet in our solar system?',
    options: ['Earth', 'Jupiter', 'Saturn', 'Neptune'],
    answer: 'Jupiter',
    type: QuestionType.multipleChoice,
    category: 'Verdensrommet',
  ),
  Question(
    question: 'Who was the first person to walk on the moon?',
    options: ['Buzz Aldrin', 'Yuri Gagarin', 'Neil Armstrong', 'Michael Collins'],
    answer: 'Neil Armstrong',
    type: QuestionType.multipleChoice,
    category: 'Verdensrommet',
  ),
  // Mennesket
  Question(
    question: 'What is the largest organ in the human body?',
    options: ['Heart', 'Liver', 'Skin', 'Lungs'],
    answer: 'Skin',
    type: QuestionType.multipleChoice,
    category: 'Mennesket',
  ),
  Question(
    question: 'How many bones are in the human body?',
    options: ['206', '205', '207', '208'],
    answer: '206',
    type: QuestionType.multipleChoice,
    category: 'Mennesket',
  ),
  // Historie
  Question(
    question: 'Who was the first President of the United States?',
    options: ['Thomas Jefferson', 'John Adams', 'George Washington', 'Abraham Lincoln'],
    answer: 'George Washington',
    type: QuestionType.multipleChoice,
    category: 'Historie',
  ),
  Question(
    question: 'In which year did World War II end?',
    options: ['1943', '1944', '1945', '1946'],
    answer: '1945',
    type: QuestionType.multipleChoice,
    category: 'Historie',
  ),
  // Geografi
  Question(
    question: 'What is the longest river in the world?',
    options: ['Amazon River', 'Nile River', 'Yangtze River', 'Mississippi River'],
    answer: 'Nile River',
    type: QuestionType.multipleChoice,
    category: 'Geografi',
  ),
  Question(
    question: 'What is the largest desert in the world?',
    options: ['Sahara Desert', 'Gobi Desert', 'Arabian Desert', 'Antarctic Desert'],
    answer: 'Antarctic Desert',
    type: QuestionType.multipleChoice,
    category: 'Geografi',
  ),
];

List<Question> getQuestionsByCategory(String category) {
  if (category == 'Allmenkunnskap') {
    return allQuestions;
  } else {
    return allQuestions.where((question) => question.category == category).toList();
  }
}
