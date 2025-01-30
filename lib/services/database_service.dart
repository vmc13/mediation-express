import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/player.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Salva ou atualiza um jogador no Firestore
  Future<void> savePlayer(Player player) async {
    await _db
        .collection('players')
        .doc(player.id)
        .set(player.toFirestore(), SetOptions(merge: true));
  }

  // Obtém um jogador pelo ID
  Future<Player?> getPlayerById(String playerId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(playerId).get();
    if (doc.exists) {
      return Player.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Atualiza o score do jogador
  Future<void> updatePlayerScore(String playerId, int newScore) async {
    final docRef =
        FirebaseFirestore.instance.collection('players').doc(playerId);

    await docRef.set({'score': newScore}, SetOptions(merge: true));
  }

  // Obtém todos os jogadores ordenados pelo score
  Future<List<Player>> getAllPlayers() async {
    QuerySnapshot query = await _db
        .collection('users') // Ajustado para o nome correto da coleção
        .orderBy('score', descending: true)
        .get();

    return query.docs
        .map((doc) =>
            Player.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
