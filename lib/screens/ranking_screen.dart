import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/player.dart';
import '../services/database_service.dart';
import '../widgets/grandient_background.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final DatabaseService dbService = DatabaseService();
  List<Player> players = [];
  Player? currentUser;

  @override
  void initState() {
    super.initState();
    _fetchRanking();
  }

  Future<void> _fetchRanking() async {
    List<Player> fetchedPlayers = await dbService.getAllPlayers();
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      currentUser = await dbService.getPlayerById(userId);
    }

    setState(() {
      players = fetchedPlayers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Ranking',
          style: GoogleFonts.pressStart2p(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: players.isEmpty
            ? Center(
                child: currentUser == null
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nenhum jogador no ranking!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.pressStart2p(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Seu Score: ${currentUser!.score}',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Text(
                        '#${index + 1}',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 14,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      title: Text(
                        players[index].name,
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Score: ${players[index].score}',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
