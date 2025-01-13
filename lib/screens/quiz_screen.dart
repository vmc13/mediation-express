import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/question.dart';

// Tela do Quiz
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
  // ignore: library_private_types_in_public_api
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  String feedbackMessage = "";
  List<Color?> buttonColors = [null, null, null];

  void _handleAnswer(int selectedIndex) {
    final question = widget.questions[currentQuestionIndex];

    setState(() {
      if (selectedIndex == question.correctAnswerIndex) {
        buttonColors[selectedIndex] = Colors.green;
        feedbackMessage = 'Parabéns! Você acertou!';
        correctAnswers++;
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
      Navigator.pop(context);
    } else {
      setState(() {
        feedbackMessage =
            "Você precisa acertar pelo menos ${widget.requiredCorrectAnswers} questões para desbloquear o próximo nível.";
      });
      Future.delayed(const Duration(seconds: 3), () {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz - Nível ${widget.level}',
          style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question.scenario,
                style:
                    GoogleFonts.pressStart2p(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              for (int i = 0; i < question.options.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          buttonColors[i] ?? Colors.deepPurpleAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                        buttonColors[i] == null ? () => _handleAnswer(i) : null,
                    child: Text(
                      question.options[i],
                      style: GoogleFonts.pressStart2p(
                          fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                feedbackMessage,
                style: GoogleFonts.pressStart2p(
                    fontSize: 14, color: Colors.yellow),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
