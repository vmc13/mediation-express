import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/question.dart';

// Tela do Quiz
class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String level;
  final Function(String medal) onLevelCompleted;

  const QuizScreen({
    Key? key,
    required this.questions,
    required this.level,
    required this.onLevelCompleted,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  String feedbackMessage = "";
  List<Color?> buttonColors = [null, null, null];

  @override
  void initState() {
    super.initState();
    if (widget.questions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Nenhuma pergunta disponível para este nível!")),
        );
        Navigator.pop(context);
      });
    }
  }

  void _handleAnswer(int selectedIndex) {
    final question = widget.questions[currentQuestionIndex];

    setState(() {
      if (selectedIndex == question.correctAnswerIndex) {
        buttonColors[selectedIndex] = Colors.green;
        feedbackMessage = 'Parabéns! Você ganhou 1 ponto!';
        score++;
      } else {
        buttonColors[selectedIndex] = Colors.red;
        buttonColors[question.correctAnswerIndex] = Colors.green;
        feedbackMessage = question.explanation;
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (currentQuestionIndex < widget.questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          feedbackMessage = "";
          buttonColors = [null, null, null];
        });
      } else {
        final medal = _getMedal();
        widget.onLevelCompleted(medal);
        Navigator.pop(context);
      }
    });
  }

  String _getMedal() {
    double percentage = (score / widget.questions.length) * 100;
    if (percentage >= 80) {
      return 'ouro';
    } else if (percentage >= 50) {
      return 'prata';
    } else {
      return 'bronze';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(
          child: Text("Nenhuma pergunta disponível para este nível!"),
        ),
      );
    }

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
