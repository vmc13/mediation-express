import '../data/questions.dart';
import '../model/question.dart';
//CORRIGIR SERVIÇO - NAO ESTA RETORNANDO OS DADOS CORRETAMENTE DO JSON
class QuestionService {
  static List<Question> getQuestionsForLevel(int level) {
    final levelData = questionsJson.firstWhere(
      (q) => q['level'] == level.toString(), // Comparando com a string do nível
      orElse: () => {'questions': []},
    );

    return (levelData['questions'] as List)
        .map((q) => Question.fromJson(q as Map<String, Object>))
        .toList();
  }
}
