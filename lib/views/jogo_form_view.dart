import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/placeholder_service.dart';

class JogoFormView extends StatefulWidget {
  const JogoFormView({super.key});

  @override
  State<JogoFormView> createState() => _JogoFormViewState();
}

class _JogoFormViewState extends State<JogoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();
  final PlaceholderService _service = PlaceholderService();
  
  bool _isEditing = false;
  Game? _gameOriginal;
  
  Future<void>? _salvarFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Game) {
      _isEditing = true;
      _gameOriginal = args;
      _titleController.text = args.title;
      _descController.text = args.shortDescription;
      _urlController.text = args.thumbnail;
    }
  }

  Future<void> _processarSalvar() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enviando para JSONPlaceholder...")));
      
      bool sucessoApi = false;
      if (_isEditing) {
        sucessoApi = await _service.simularUpdate(_gameOriginal!.id, _titleController.text, _descController.text);
      } else {
        sucessoApi = await _service.simularCreate(_titleController.text, _descController.text);
      }

      final novoJogo = Game(
        id: _isEditing ? _gameOriginal!.id : DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        thumbnail: _urlController.text.isEmpty ? 'https://placehold.co/600x400/png' : _urlController.text,
        shortDescription: _descController.text,
      );

      if (mounted && sucessoApi) Navigator.pop(context, novoJogo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar Jogo' : 'Novo Jogo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
              TextFormField(controller: _urlController, decoration: const InputDecoration(labelText: 'URL Imagem')),
              TextFormField(controller: _descController, decoration: const InputDecoration(labelText: 'Descrição'), maxLines: 3),
              const SizedBox(height: 20),
              
              // --- USO DO FUTUREBUILDER NO BOTÃO SALVAR ---
              FutureBuilder<void>(
                future: _salvarFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _salvarFuture = _processarSalvar();
                      });
                    },
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: Text(_isEditing ? 'Atualizar (PUT)' : 'Criar (POST)'),
                  );
                },
              ),
              // --------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}