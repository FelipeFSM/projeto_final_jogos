import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_model.dart';

class BuscaView extends StatefulWidget {
  const BuscaView({super.key});

  @override
  State<BuscaView> createState() => _BuscaViewState();
}

class _BuscaViewState extends State<BuscaView> {
  Future<List<Game>>? _futureJogos;
  final TextEditingController _searchController = TextEditingController();
  List<Game> _allGames = [];
  List<Game> _displayedGames = [];
  int _currentPage = 0;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _futureJogos = _fetchGames();
    _carregarUltimaBusca();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarUltimaBusca() async {
    final prefs = await SharedPreferences.getInstance();
    final String? lastSearch = prefs.getString('last_search');
    if (lastSearch != null && lastSearch.isNotEmpty) {
      setState(() { _searchController.text = lastSearch; });
    }
  }

  Future<void> _salvarBusca(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_search', value);
  }

  Future<List<Game>> _fetchGames() async {

    // Conectividade (API): Consumo de API RESTful externa (FreeToGame) usando pacote http (async/await).
    final response = await http.get(Uri.parse('https://corsproxy.io/?https://www.freetogame.com/api/games'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final games = data.map((json) => Game.fromJson(json)).toList();
      _allGames = games;
      if (_searchController.text.isNotEmpty) _runFilter(_searchController.text);
      else _updateDisplayedGames();
      return games;
    } else {
      throw Exception('Falha ao carregar jogos: ${response.statusCode}');
    }
  }

  void _updateDisplayedGames() {
    if (_allGames.isEmpty) return;
    final int startIndex = _currentPage * _pageSize;
    final int endIndex = (startIndex + _pageSize < _allGames.length) ? startIndex + _pageSize : _allGames.length;
    _displayedGames = _allGames.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    if ((_currentPage + 1) * _pageSize < _allGames.length) {
      setState(() { _currentPage++; _updateDisplayedGames(); });
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() { _currentPage--; _updateDisplayedGames(); });
    }
  }

  void _runFilter(String keyword) {
    _salvarBusca(keyword);
    if (keyword.isEmpty) {
      _updateDisplayedGames();
      setState(() {});
    } else {
      setState(() {
        _displayedGames = _allGames.where((game) => game.title.toLowerCase().contains(keyword.toLowerCase())).take(20).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Procure seu jogo")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(labelText: 'Pesquisar...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            // Conectividade (API): Uso do FutureBuilder para exibir dados da API (gerenciando loading, error e data).
            child: FutureBuilder<List<Game>>(
              future: _futureJogos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 10),
                        Text('Erro: ${snapshot.error}', textAlign: TextAlign.center),
                        ElevatedButton(onPressed: () { setState(() { _futureJogos = _fetchGames(); }); }, child: const Text("Tentar Novamente"))
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _displayedGames.length,
                    itemBuilder: (context, index) {
                      final game = _displayedGames[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Hero(
                              tag: 'game_img_${game.id}',
                              child: Image.network(
                                'https://corsproxy.io/?${game.thumbnail}',
                                width: 80, height: 60, fit: BoxFit.cover,
                                errorBuilder: (_,__,___) => const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          title: Text(game.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Padding(padding: EdgeInsets.only(top: 5), child: Text("Toque para ver detalhes", style: TextStyle(fontSize: 12))),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          onTap: () => Navigator.pushNamed(context, '/detalhes', arguments: game),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text("Nenhum dado encontrado."));
              },
            ),
          ),
          if (_allGames.isNotEmpty && _searchController.text.isEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: _currentPage > 0 ? _prevPage : null, child: const Text("Anterior")),
                  Text("Página ${_currentPage + 1}"),
                  ElevatedButton(onPressed: ((_currentPage + 1) * _pageSize < _allGames.length) ? _nextPage : null, child: const Text("Próxima")),
                ],
              ),
            ),
        ],
      ),
    );
  }
}