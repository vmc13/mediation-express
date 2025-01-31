import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/player.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Salva ou atualiza um jogador no Firestore
  Future<void> savePlayer(Player player) async {
    await _db
        .collection('users')
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
  Future<void> incrementPlayerScore(String playerId) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(playerId);

    await docRef.update({
      'score': FieldValue.increment(1), // Incrementa +1 ao score atual
      'updatedAt': FieldValue.serverTimestamp(),
    }).catchError((error) {
      debugPrint('Erro ao atualizar score: $error');
    });
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

  Future<void> updatePlayerLevel(String playerId, int newLevel) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(playerId);

    await docRef.update({
      'level': newLevel, // Atualiza o nível do usuário
      'updatedAt': FieldValue.serverTimestamp(),
    }).catchError((error) {
      debugPrint('Erro ao atualizar nível: $error');
    });
  }

  Future<int> getPlayerLevel(String userId) async {
    try {
      final docRef = _db.collection('users').doc(userId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return (docSnapshot.data()!['level'] ?? 1) as int;
      }
    } catch (e) {
      print("Erro ao buscar nível do jogador: $e");
    }
    return 1; // Retorna 1 caso o usuário não tenha nível salvo
  }
}
