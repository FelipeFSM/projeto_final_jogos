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
    if (jogosString != null) {
      return Game.decode(jogosString);
    }
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
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Backlog'),
        actions: [
          IconButton(
            onPressed: _logout, 
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sair',
          )
        ],
      ),
      body: FutureBuilder<List<Game>>(
        future: _futureJogos,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
          }

          final listaJogos = snapshot.data ?? [];

          if (listaJogos.isEmpty) {
            return const Center(
              child: Text(
                "Sua lista está vazia.\nAdicione jogos!",
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: listaJogos.length,
            itemBuilder: (context, index) {
              final game = listaJogos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    game.thumbnail.contains('freetogame') 
                        ? 'https://corsproxy.io/?${game.thumbnail}'
                        : game.thumbnail,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => const Icon(Icons.videogame_asset),
                  ),
                  title: Text(game.title),
                  subtitle: const Text("Toque para detalhes"),
                  onTap: () {
                    Navigator.pushNamed(context, '/detalhes', arguments: game);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final result = await Navigator.pushNamed(context, '/form', arguments: game);
                          if (result != null && result is Game) {
                            listaJogos[index] = result;
                            _atualizarListaNoDisco(listaJogos);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await _service.simularDelete(game.id);
                          listaJogos.removeAt(index);
                          _atualizarListaNoDisco(listaJogos);
                          
                          if(mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Jogo removido!")),
                            );
                          }
                        },
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
          FloatingActionButton(
            heroTag: "btn1",
            mini: true,
            backgroundColor: Colors.grey,
            child: const Icon(Icons.edit_note),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/form');
              if (result != null && result is Game) {
               
                final listaAtual = await _iniciarSessaoECarregar();
                listaAtual.add(result);
                _atualizarListaNoDisco(listaAtual);
              }
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.search),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/busca');
              if (result != null && result is Game) {
                final listaAtual = await _iniciarSessaoECarregar();
                listaAtual.add(result);
                _atualizarListaNoDisco(listaAtual);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${result.title} adicionado!")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}