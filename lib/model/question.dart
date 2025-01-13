class Question {
  final String level;
  final String scenario;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.level,
    required this.scenario,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      level: json['level'] as String,
      scenario: json['scenario'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }
}
