import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/player.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  // Após login, salva o jogador no Firestore
  Future<void> handleLogin() async {
    final user = _auth.currentUser;

    if (user != null) {
      final newPlayer = Player(
        id: user.uid,
        name: user.displayName ?? 'Jogador',
        email: user.email ?? '',
        score: 0,
        level: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _dbService.savePlayer(newPlayer);
    } else {
      debugPrint('Erro: Nenhum usuário autenticado.');
    }
  }

  // Método para obter o ID do usuário atual
  String? getCurrentUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      debugPrint('Nenhum usuário autenticado.');
      return null; // Retorna nulo se não houver usuário autenticado
    }
  }
}
