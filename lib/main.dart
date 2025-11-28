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
      title: 'Game Backlog',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF03DAC6),
          surface: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF2C2C2C),
          elevation: 4,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
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