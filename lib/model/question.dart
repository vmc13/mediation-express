class Question {
  final String scenario;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.scenario,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}
