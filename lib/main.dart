import 'package:flutter/material.dart';
import 'package:projeto_final_jogos/views/login_view.dart'; // <-- 1. IMPORTAR A NOVA TELA

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove o banner "debug"
      title: 'Catálogo de Jogos',
      theme: ThemeData(
        brightness: Brightness.dark, // Tema escuro (combina com jogos)
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // 'home' é a primeira tela que o app vai abrir
      home: const LoginView(), // <-- 2. DEFINIR ELA COMO 'HOME'
    );
  }
}