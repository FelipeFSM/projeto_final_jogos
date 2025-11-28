import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_model.dart';
import '../services/placeholder_service.dart';

class BacklogView extends StatefulWidget {
  const BacklogView({super.key});

  @override
  State<BacklogView> createState() => _BacklogViewState();
}

class _BacklogViewState extends State<BacklogView> {
  final PlaceholderService _service = PlaceholderService();
  late Future<List<Game>> _futureJogos;
  String _userKey = 'meus_jogos';

  @override
  void initState() {
    super.initState();
    _futureJogos = _iniciarSessaoECarregar();
  }

  Future<List<Game>> _iniciarSessaoECarregar() async {
    final prefs = await SharedPreferences.getInstance();
    final String? currentUser = prefs.getString('current_user');
    if (currentUser != null && currentUser.isNotEmpty) {
      _userKey = 'backlog_$currentUser';
    } else {
      _userKey = 'meus_jogos';
    }
    final String? jogosString = prefs.getString(_userKey);
    if (jogosString != null) return Game.decode(jogosString);
    return [];
  }

  Future<void> _atualizarListaNoDisco(List<Game> novaLista) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Game.encode(novaLista);
    await prefs.setString(_userKey, encodedData);
    setState(() {
      _futureJogos = _iniciarSessaoECarregar();
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged', false);
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sua lista'),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.exit_to_app), tooltip: 'Sair')],
      ),
      body: FutureBuilder<List<Game>>(
        future: _futureJogos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
          final listaJogos = snapshot.data ?? [];

          if (listaJogos.isEmpty) {
            return const Center(child: Text("Sua lista está vazia.\nAdicione jogos!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: listaJogos.length,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), 
            itemBuilder: (context, index) {
              final game = listaJogos[index];
              
              
              return Card(
                clipBehavior: Clip.antiAlias, 
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell( 
                  onTap: () => Navigator.pushNamed(context, '/detalhes', arguments: game),
                  child: Column(
                    children: [
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Hero(
                            tag: 'game_img_${game.id}',
                            child: Image.network(
                              game.thumbnail.contains('freetogame') ? 'https://corsproxy.io/?${game.thumbnail}' : game.thumbnail,
                              width: 120, 
                              height: 120, 
                              fit: BoxFit.cover,
                              errorBuilder: (_,__,___) => Container(width: 120, height: 120, color: Colors.grey[800], child: const Icon(Icons.videogame_asset, size: 40, color: Colors.white24)),
                            ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game.title, 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    maxLines: 2, 
                                    overflow: TextOverflow.ellipsis
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    game.shortDescription.isNotEmpty ? game.shortDescription : "Sem descrição.",
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                     
                      Divider(height: 1, color: Colors.white.withOpacity(0.05)),

                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            
                            TextButton.icon(
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text("Editar"),
                              style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 174, 53, 255)),
                              onPressed: () async {
                                final result = await Navigator.pushNamed(context, '/form', arguments: game);
                                if (result != null && result is Game) {
                                  listaJogos[index] = result;
                                  _atualizarListaNoDisco(listaJogos);
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            
                            TextButton.icon(
                              icon: const Icon(Icons.delete, size: 18),
                              label: const Text("Remover"),
                              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                              onPressed: () async {
                                await _service.simularDelete(game.id);
                                listaJogos.removeAt(index);
                                _atualizarListaNoDisco(listaJogos);
                                if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jogo removido!")));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: "btn1", backgroundColor: Colors.grey[800],
            child: const Icon(Icons.edit_note, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/form');
              if (result != null && result is Game) {
                final listaAtual = await _iniciarSessaoECarregar();
                listaAtual.add(result);
                _atualizarListaNoDisco(listaAtual);
              }
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "btn2",
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/busca');
              if (result != null && result is Game) {
                final listaAtual = await _iniciarSessaoECarregar();
                listaAtual.add(result);
                _atualizarListaNoDisco(listaAtual);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${result.title} adicionado!")));
              }
            },
          ),
        ],
      ),
    );
  }
}