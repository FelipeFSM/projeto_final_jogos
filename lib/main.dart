// Importa biblioteca principal do Flutter
import 'package:flutter/material.dart';

// Importa pacote para gerenciamento de preferências
import 'package:shared_preferences/shared_preferences.dart';

// Importa telas do aplicativo
import 'package:projeto_final_jogos/views/login_view.dart';
import 'package:projeto_final_jogos/views/backlog_view.dart';

// Define função principal assíncrona
Future<void> main() async {
  // Garante inicialização do binding do Flutter antes de operações assíncronas
  WidgetsFlutterBinding.ensureInitialized();

  // Obtém instância singleton do SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Verifica existência da chave 'username' para determinar estado de login
  bool isLogged = prefs.getString('username') != null;

  // Inicializa aplicação injetando estado de login inicial
  runApp(MyApp(startLogged: isLogged));
}

// Widget raiz da aplicação
class MyApp extends StatelessWidget {
  // Propriedade imutável para armazenar estado inicial de login
  final bool startLogged;

  // Construtor que requer o parâmetro startLogged
  const MyApp({super.key, required this.startLogged});

  // Constrói a árvore de widgets da aplicação
  @override
  Widget build(BuildContext context) {
    // Configura aplicação Material Design
    return MaterialApp(
      // Oculta banner de debug
      debugShowCheckedModeBanner: false,
      // Define título da aplicação
      title: 'Catálogo de Jogos',
      // Configura tema global da aplicação
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // Define tela inicial baseado no estado de login persistido
      // Se logado, renderiza BacklogView, caso contrário, LoginView
      home: startLogged ? const BacklogView() : const LoginView(),
    );
  }
}