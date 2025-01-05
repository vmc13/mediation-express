import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Pacote para animações

class ResultScreen extends StatelessWidget {
  final int score;

  const ResultScreen({required this.score, Key? key}) : super(key: key);

  String getFeedbackText() {
    if (score <= 5) return 'Ops! Você pode melhorar!';
    if (score <= 7) return 'Bom trabalho!';
    return 'Excelente! Você é incrível!';
  }

  String getFeedbackAnimation() {
    if (score <= 5) return 'assets/animations/bad-score-animation.json';
    if (score <= 7) return 'assets/animations/medium-score-animation.json';
    return 'assets/animations/high-score-animation.json';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado', style: TextStyle(fontSize: 24.0)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.purple.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              getFeedbackAnimation(),
              height: 200,
              repeat: false,
            ),
            const SizedBox(height: 24.0),
            Text(
              getFeedbackText(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Sua pontuação: $score',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.deepPurpleAccent,
              ),
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text(
                'Jogar Novamente',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
