import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/player.dart';
import '../services/database_service.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: players.isEmpty
          ? Center(
              child: currentUser == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nenhum jogador no ranking!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Seu Score: ${currentUser!.score}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
            )
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(players[index].name),
                  subtitle: Text('Score: ${players[index].score}'),
                  leading: Text('#${index + 1}'),
                );
              },
            ),
    );
  }
}
