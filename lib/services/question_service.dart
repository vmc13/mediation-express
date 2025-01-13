import '../data/questions.dart';
import '../model/question.dart';

class QuestionService {
  static List<Question> getQuestionsForLevel(int level) {
    // Filtra as perguntas pelo nível correspondente
    final List<Map<String, dynamic>> filteredQuestions = questionsJson[0]['questions']
        .where((q) => q['level'] == level.toString())
        .toList();

    // Mapeia as perguntas filtradas para objetos Question
    return filteredQuestions
        .map((q) => Question.fromJson(q))
        .toList();
  }
}
