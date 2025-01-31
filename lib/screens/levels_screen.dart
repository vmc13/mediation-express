import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediation_express/screens/quiz_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/player.dart';
import '../services/database_service.dart';
import '../services/question_service.dart';
import '../widgets/grandient_background.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final DatabaseService dbService = DatabaseService();

  int completedLevels = 0;
  final int requiredCorrectAnswers = 1;
  String playerName = "Jogador";

  @override
  void initState() {
    super.initState();
    _loadCompletedLevels();
    _fetchUserName();
  }

  Future<String> _fetchUserName() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return "Usuário não encontrado";
    }

    Player? player = await dbService.getPlayerById(userId);

    if (player == null) {
      return "Nome não disponível";
    }

    return player.name;
  }

  void _loadCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      completedLevels = prefs.getInt('completedLevels') ?? 0;
      playerName =
          prefs.getString('playerName') ?? "Jogador"; // Pegando nome salvo
    });
  }

  void _onLevelCompleted(int level) async {
    if (level > completedLevels) {
      setState(() {
        completedLevels = level;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('completedLevels', completedLevels);
    }
  }

  Widget _buildLevelButton(String label, int level) {
    final isUnlocked = level <= completedLevels + 1;
    final questions = QuestionService.getQuestionsForLevel(level);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        backgroundColor: isUnlocked ? Colors.deepPurple : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isUnlocked && questions.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                    questions: questions,
                    level: level.toString(),
                    requiredCorrectAnswers: requiredCorrectAnswers,
                    onLevelCompleted: () => _onLevelCompleted(level),
                  ),
                ),
              );
            }
          : null,
      icon: Icon(
        isUnlocked ? Icons.play_arrow : Icons.lock,
        color: Colors.white,
      ),
      label: Text(label,
          style: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          "Níveis",
          style: GoogleFonts.pressStart2p(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: _fetchUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Carregando...',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar nome',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Text(
                    'Bem-vindo, ${snapshot.data}!',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Escolha um nível para jogar',
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: Image.asset("assets/images/me-logo-alt-no-bg.png"),
            ),
            const SizedBox(height: 30),
            _buildLevelButton('Mediação 1', 1),
            const SizedBox(height: 20),
            _buildLevelButton('Mediação 2', 2),
            const SizedBox(height: 20),
            _buildLevelButton('Mediação 3', 3),
            const SizedBox(height: 40),
            const Icon(
              Icons.stars,
              size: 50,
              color: Colors.yellowAccent,
            ),
          ],
        ),
      ),
    );
  }
}
