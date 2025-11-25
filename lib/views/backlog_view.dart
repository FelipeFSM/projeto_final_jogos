import 'package:flutter/material.dart';
import 'package:projeto_final_jogos/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BacklogView extends StatefulWidget {
  const BacklogView({super.key});

  @override
  State<BacklogView> createState() => _BacklogViewState();
}

class _BacklogViewState extends State<BacklogView> {
  
  // Função para deslogar
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Opcional: Se quiser limpar o login automático, pode remover as chaves
    // await prefs.remove('username');
    // await prefs.remove('password');
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
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
          ),
        ],
      ),
      body: const Center(
        child: Text('Aqui aparecerá a lista de jogos salvos!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Futuro: Navegar para a tela de Busca
          print("Ir para busca");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}