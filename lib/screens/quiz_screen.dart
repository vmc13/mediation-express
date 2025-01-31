import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediation_express/screens/ranking_screen.dart';

import '../model/question.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/grandient_background.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String level;
  final int requiredCorrectAnswers;
  final VoidCallback onLevelCompleted;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.level,
    required this.requiredCorrectAnswers,
    required this.onLevelCompleted,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  String feedbackMessage = "";
  List<Color?> buttonColors = [null, null, null];
  AuthService authService = AuthService();
  String? currentUserId;
  int unlockedLevel = 1;
  DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final String? id = authService.getCurrentUserId();
    if (id != null) {
      setState(() {
        currentUserId = id;
      });
      debugPrint('ID do usuário atual: $currentUserId');

      // Buscar o nível do jogador ao fazer login
      int userLevel = await dbService.getPlayerLevel(currentUserId!);
      setState(() {
        unlockedLevel = userLevel; // Atualiza a UI
      });
    } else {
      debugPrint('Erro: Nenhum usuário autenticado.');
    }
  }

  Future<void> _updateScore() async {
    if (currentUserId != null) {
      await dbService.incrementPlayerScore(currentUserId!);
    }
  }

  void _handleAnswer(int selectedIndex) {
    final question = widget.questions[currentQuestionIndex];

    setState(() {
      if (selectedIndex == question.correctAnswerIndex) {
        buttonColors[selectedIndex] = Colors.green;
        feedbackMessage = 'Parabéns! Você acertou!';
        correctAnswers++;
        // Atualiza o score no Firestore
        if (currentUserId != null) {
          _updateScore();
        }
      } else {
        buttonColors[selectedIndex] = Colors.red;
        buttonColors[question.correctAnswerIndex] = Colors.green;
        feedbackMessage = question.explanation;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (currentQuestionIndex < widget.questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          feedbackMessage = "";
          buttonColors = [null, null, null];
        });
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    if (correctAnswers >= widget.requiredCorrectAnswers) {
      widget.onLevelCompleted();

      // Se o usuário passar de nível, salva no Firestore
      int nextLevel = int.parse(widget.level) + 1;
      if (currentUserId != null) {
        dbService.updatePlayerLevel(currentUserId!, nextLevel);
      }

      if (widget.level == '3') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RankingScreen()),
        );
      } else {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        feedbackMessage =
            "Você precisa acertar pelo menos ${widget.requiredCorrectAnswers} questões para desbloquear o próximo nível.";
      });
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];

    return GradientScaffold(
        appBar: AppBar(
          title: Text(
            'Quiz - Nível ${widget.level}',
            style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  question.scenario,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 20),
                for (int i = 0; i < question.options.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColors[i] ?? Colors.deepOrange,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: buttonColors[i] == null
                            ? () => _handleAnswer(i)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            question.options[i],
                            style: GoogleFonts.pressStart2p(
                                fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                        )),
                  ),
                const SizedBox(height: 20),
                Text(
                  feedbackMessage,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 12, color: Colors.yellow),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ));
  }
}
