import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String name;
  final String email;
  final int score;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;

  Player({
    required this.id,
    required this.name,
    required this.email,
    required this.score,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converte um documento do Firestore para um objeto Player
  factory Player.fromFirestore(String id, Map<String, dynamic> data) {
    return Player(
      id: id,
      name: data['name'] ?? 'Anônimo',
      email: data['email'] ?? '',
      score: data['score'] ?? 0,
      level: data['level'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Converte um objeto Player para um mapa para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'score': score,
      'level': level,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
