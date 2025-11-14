// Importa a biblioteca 'material.dart', essencial do Flutter, que
// define a classe 'MaterialApp' e os widgets de design 'Material'.
import 'package:flutter/material.dart';

// Importa o arquivo da tela de login, permitindo que a classe
// 'LoginView' seja referenciada neste arquivo.
import 'package:projeto_final_jogos/views/login_view.dart';

// A função 'main()' é o ponto de entrada padrão para a execução de código Dart.
void main() {
  // 'runApp' é a função do Flutter que anexa o widget raiz (MyApp)
  // à tela e inicializa o binding do framework.
  runApp(const MyApp());
}

// 'MyApp' é o widget raiz da aplicação.
// É um 'StatelessWidget', pois seu estado não mudará após ser criado.
class MyApp extends StatelessWidget {
  // Um construtor 'const' para este widget, permitindo otimizações de performance.
  const MyApp({super.key});

  // O método 'build' descreve a parte da interface do usuário
  // representada por este widget.
  @override
  Widget build(BuildContext context) {
    // 'MaterialApp' é o widget que encapsula a aplicação 'Material Design'.
    // Ele fornece configuração para temas, rotas e navegação.
    return MaterialApp(
      // Desativa a faixa de "DEBUG" no canto superior direito.
      debugShowCheckedModeBanner: false,
      
      // Um título descritivo da aplicação para o sistema operacional.
      title: 'Catálogo de Jogos',
      
      // 'theme' define os dados de configuração visual da aplicação.
      theme: ThemeData(
        // 'brightness' define o brilho geral do tema (claro ou escuro).
        brightness: Brightness.dark,
        
        // 'primarySwatch' define uma coleção de cores (MaterialColor)
        // que o framework usará para componentes de interface.
        primarySwatch: Colors.blue,
        
        // Adapta a densidade visual da interface para a plataforma de destino.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // 'home' define o widget (rota) padrão que será exibido
      // quando a aplicação for iniciada.
      home: const LoginView(), // A 'LoginView' é definida como a tela inicial.
    );
  }
}