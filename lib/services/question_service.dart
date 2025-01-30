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


// class QuestionService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   // Salva uma nova questão no Firestore
//   Future<void> saveQuestion(Question question) async {
//     await _db.collection('questions').add({
//       'level': question.level,
//       'scenario': question.scenario,
//       'options': question.options,
//       'correctAnswerIndex': question.correctAnswerIndex,
//       'explanation': question.explanation,
//     });
//   }

//   // Obtém as questões por nível
//   Future<List<Question>> getQuestionsByLevel(String level) async {
//     QuerySnapshot query = await _db.collection('questions').where('level', isEqualTo: level).get();
//     return query.docs.map((doc) => Question.fromJson(doc.data() as Map<String, dynamic>)).toList();
//   }
// }