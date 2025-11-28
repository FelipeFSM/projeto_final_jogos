import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/game_model.dart';

class DetalhesView extends StatelessWidget {
  const DetalhesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Navegação: Recuperação dos dados passados via arguments.
    final Game game = ModalRoute.of(context)!.settings.arguments as Game;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Estrutura e Layout: Layouts responsivos usando Stack, Positioned, Column e Container.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.6,  
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  game.thumbnail.contains('freetogame') 
                      ? 'https://corsproxy.io/?${game.thumbnail}' 
                      : game.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => Container(color: const Color(0xFF121212)),
                ),
                
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),

          
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.12),

                Hero(
                  tag: 'game_img_${game.id}',
                  child: Container(
                    height: 220, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        game.thumbnail.contains('freetogame') 
                            ? 'https://corsproxy.io/?${game.thumbnail}' 
                            : game.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder: (_,__,___) => const Icon(Icons.broken_image, size: 80, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: size.height * 0.5), 
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor, 
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Center(
                        child: Text(
                          game.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 25),

                      
                      Center(
                        child: SizedBox(
                          width: 220, 
                          height: 45,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check_circle_outline, size: 20),
                            label: const Text("Adicionar à Coleção"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0, 
                              shape: const StadiumBorder(), 
                            ),
                            onPressed: () {
                              Navigator.pop(context, game);
                              Navigator.pop(context, game);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 20),

                     
                      const Text(
                        "Sobre este jogo",
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        game.shortDescription,
                        style: const TextStyle(
                          fontSize: 15, 
                          height: 1.6, 
                          color: Colors.white70 
                        ),
                      ),
                      
                     
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}