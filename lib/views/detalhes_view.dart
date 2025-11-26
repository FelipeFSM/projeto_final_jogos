import 'package:flutter/material.dart';
import '../models/game_model.dart';

class DetalhesView extends StatelessWidget {
  const DetalhesView({super.key});

  @override
  Widget build(BuildContext context) {
    final Game game = ModalRoute.of(context)!.settings.arguments as Game;

    return Scaffold(
      appBar: AppBar(title: Text(game.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                game.thumbnail.contains('freetogame')
                    ? 'https://corsproxy.io/?${game.thumbnail}'
                    : game.thumbnail,
                errorBuilder: (_,__,___) => const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Descrição:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text(game.shortDescription),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("SALVAR NO BACKLOG"),
                onPressed: () {
                  Navigator.pop(context, game);
                  Navigator.pop(context, game);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}