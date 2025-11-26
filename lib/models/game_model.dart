import 'dart:convert';

class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String shortDescription;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    this.shortDescription = '',
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sem Título',
      thumbnail: json['thumbnail'] ?? 'https://placehold.co/600x400/png',
      shortDescription: json['short_description'] ?? 'Sem descrição.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'short_description': shortDescription,
    };
  }

  static String encode(List<Game> games) => json.encode(
        games.map<Map<String, dynamic>>((game) => game.toJson()).toList(),
      );

  static List<Game> decode(String gamesEncoded) =>
      (json.decode(gamesEncoded) as List<dynamic>)
          .map<Game>((item) => Game.fromJson(item))
          .toList();
}