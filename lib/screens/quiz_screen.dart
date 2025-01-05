// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/questions.dart';
import 'result_screen.dart'; // Importe o arquivo de perguntas

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  String feedbackMessage = "";
  List<Color?> buttonColors = [null, null, null];

  void handleAnswer(int selectedIndex) {
    final correctAnswerIndex =
        questions[currentQuestionIndex]['correctAnswerIndex'] as int;

    setState(() {
      if (selectedIndex == correctAnswerIndex) {
        buttonColors[selectedIndex] = Colors.green;
        feedbackMessage = 'Parabéns! Você ganhou 1 ponto.';
        score++;
      } else {
        buttonColors[selectedIndex] = Colors.red;
        buttonColors[correctAnswerIndex] = Colors.green;
        feedbackMessage =
            questions[currentQuestionIndex]['explanation'] as String;
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          feedbackMessage = "";
          buttonColors = [null, null, null];
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex]['question'] as String;
    final options = questions[currentQuestionIndex]['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz de Mediação',
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.purpleAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  question,
                  style: GoogleFonts.roboto(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              ...List.generate(options.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColors[index] ?? Colors.white,
                      foregroundColor: buttonColors[index] == null
                          ? Colors.black87
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      textStyle: GoogleFonts.roboto(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: buttonColors.contains(Colors.green) ||
                            buttonColors.contains(Colors.red)
                        ? null
                        : () => handleAnswer(index),
                    child: Text(options[index]),
                  ),
                );
              }),
              const SizedBox(height: 16.0),
              Text(
                feedbackMessage,
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: feedbackMessage.startsWith('Parabéns')
                      ? Colors.green
                      : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
