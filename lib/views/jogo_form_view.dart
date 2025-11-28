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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _processarSalvar() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enviando para JSONPlaceholder...")));
      
      // Delay artificial para ver o loading no botão
      await Future.delayed(const Duration(milliseconds: 500));
      
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
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Jogo' : 'Novo Jogo'),
      ),
      body: Center( // Centraliza tudo na tela
        child: SingleChildScrollView( // Permite rolar se a tela for pequena verticalmente
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              // Limita a largura para não esticar demais no PC
              constraints: const BoxConstraints(maxWidth: 500), 
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ícone de destaque no topo
                    Icon(
                      _isEditing ? Icons.edit_note_rounded : Icons.add_circle_outline_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isEditing ? 'Editar Detalhes' : 'Adicionar novo jogo',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),

                    // Campos do Formulário
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título do Jogo', 
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                        isDense: true
                      ),
                      validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    TextFormField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL da Imagem', 
                        prefixIcon: Icon(Icons.image_outlined),
                        border: OutlineInputBorder(),
                        isDense: true
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // --- CORREÇÃO DO CAMPO DESCRIÇÃO ---
                    TextFormField(
                      controller: _descController,
                      textAlignVertical: TextAlignVertical.top, // Alinha texto no topo
                      decoration: const InputDecoration(
                        labelText: 'Descrição', 
                        // Removemos o prefixIcon e usamos prefix para alinhar melhor ou mantemos
                        // mas com alignLabelWithHint que ajuda.
                        // O segredo para o ícone não ficar no meio de um campo grande é não usar maxLines fixo muito alto
                        // ou usar minLines e maxLines.
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 40), // Empurra o ícone pra cima (ajuste manual)
                          child: Icon(Icons.description_outlined),
                        ),
                        border: OutlineInputBorder(),
                        isDense: true,
                        alignLabelWithHint: true, // Alinha o label no topo
                      ),
                      maxLines: 3, // Reduzi de 4 para 3 para ficar menos "alto"
                    ),
                    // -----------------------------------
                    
                    const SizedBox(height: 30),

                    // Botão Centralizado e Compacto
                    Center(
                      child: FutureBuilder<void>(
                        future: _salvarFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2));
                          }
                          return ElevatedButton.icon(
                            onPressed: () { setState(() { _salvarFuture = _processarSalvar(); }); },
                            icon: Icon(_isEditing ? Icons.save_as : Icons.save, size: 18),
                            label: Text(
                              _isEditing ? 'Atualizar' : 'Criar',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // O estilo base vem do main.dart, mas aqui garantimos o tamanho
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}