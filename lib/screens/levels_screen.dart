import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediation_express/screens/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/question_service.dart';
import '../widgets/animatedButton_widget.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  int completedLevels = 0;

  @override
  void initState() {
    super.initState();
    _loadCompletedLevels();
  }

  void _loadCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      completedLevels = prefs.getInt('completedLevels') ?? 0;
    });
  }

  void _onLevelCompleted(int level, String medal) async {
    if (level > completedLevels) {
      setState(() {
        completedLevels = level;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('completedLevels', completedLevels);
      prefs.setString('medal_level_$level', medal);
    }
  }

  Widget _buildLevelButton(String label, int level) {
    final questions = QuestionService.getQuestionsForLevel(level);

    return AnimatedbuttonWidget(
      context: context,
      label: label,
      targetScreen: questions.isNotEmpty
          ? QuizScreen(
              questions: questions,
              level: level.toString(),
              onLevelCompleted: (medal) => _onLevelCompleted(level, medal),
            )
          : const SizedBox.shrink(),
      color: questions.isNotEmpty ? Colors.purpleAccent : Colors.grey,
      icon: questions.isNotEmpty ? Icons.play_arrow : Icons.lock,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Níveis de Mediação",
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLevelButton('Mediação 1', 1),
              const SizedBox(height: 20),
              _buildLevelButton('Mediação 2', 2),
              const SizedBox(height: 20),
              _buildLevelButton('Mediação 3', 3),
            ],
          ),
        ),
      ),
    );
  }
}
