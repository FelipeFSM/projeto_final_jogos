import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/backlog_view.dart';
import 'views/busca_view.dart';
import 'views/detalhes_view.dart';
import 'views/jogo_form_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto Jogos',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // Se já verificou:
          if (snapshot.hasData && snapshot.data == true) {
            return const BacklogView(); 
          } else {
            return const LoginView(); 
          }
        },
      ),

      routes: {
        '/login': (context) => const LoginView(),
        '/cadastro': (context) => const CadastroView(),
        '/backlog': (context) => const BacklogView(),
        '/busca': (context) => const BuscaView(),
        '/detalhes': (context) => const DetalhesView(),
        '/form': (context) => const JogoFormView(),
      },
    );
  }
}