// Importa componentes visuais do Material Design
import 'package:flutter/material.dart';

// Importa pacote para persistência de dados local
import 'package:shared_preferences/shared_preferences.dart';

// Importa arquivo da tela de cadastro para navegação
import 'package:projeto_final_jogos/views/cadastro_view.dart';

// Importa arquivo da tela principal para navegação pós-login
import 'package:projeto_final_jogos/views/backlog_view.dart';

// Define widget da tela de login como Stateful para gerenciar dados dinâmicos
class LoginView extends StatefulWidget {
  // Inicializa construtor com chave opcional
  const LoginView({super.key});

  // Cria instância do estado associado ao widget
  @override
  State<LoginView> createState() => _LoginViewState();
}

// Classe responsável pela lógica e estado da tela
class _LoginViewState extends State<LoginView> {
  // Instancia controlador para manipulação do texto do usuário
  final TextEditingController _userController = TextEditingController();
  // Instancia controlador para manipulação do texto da senha
  final TextEditingController _passwordController = TextEditingController();

  // Executa limpeza de recursos ao fechar a tela
  @override
  void dispose() {
    // Libera memória alocada para controlador de usuário
    _userController.dispose();
    // Libera memória alocada para controlador de senha
    _passwordController.dispose();
    // Executa método de limpeza da superclasse
    super.dispose();
  }

  // Define função assíncrona para processar tentativa de login
  void _onLoginPressed() async {
    // Captura texto atual do campo de usuário
    String inputUser = _userController.text;
    // Captura texto atual do campo de senha
    String inputPass = _passwordController.text;

    // Aguarda e obtém instância do gerenciador de preferências
    final prefs = await SharedPreferences.getInstance();

    // Recupera string armazenada na chave 'username' ou nulo
    String? savedUser = prefs.getString('username');
    // Recupera string armazenada na chave 'password' ou nulo
    String? savedPass = prefs.getString('password');

    // Verifica inexistência de credenciais salvas
    if (savedUser == null || savedPass == null) {
      // Checa se widget permanece ativo na árvore
      if (mounted) {
        // Exibe notificação visual de erro na base da tela
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum usuário cadastrado. Vá em "Cadastre-se".')),
        );
      }
      // Interrompe execução da função
      return;
    }

    // Compara credenciais inseridas com credenciais armazenadas
    if (inputUser == savedUser && inputPass == savedPass) {
      // Checa se widget permanece ativo na árvore
      if (mounted) {
        // Substitui rota atual pela rota da tela de Backlog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BacklogView()),
        );
      }
    } else {
      // Checa se widget permanece ativo na árvore
      if (mounted) {
        // Exibe notificação visual de erro de credencial
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha incorretos.')),
        );
      }
    }
  }

  // Define função para navegar à tela de cadastro
  void _onRegisterPressed() {
    // Adiciona rota da tela de cadastro à pilha de navegação
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroView()),
    );
  }

  // Constrói interface gráfica do widget
  @override
  Widget build(BuildContext context) {
    // Retorna estrutura base da tela
    return Scaffold(
      // Centraliza conteúdo na tela
      body: Center(
        // Adiciona espaçamento interno uniforme
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Restringe largura máxima do conteúdo para layout web
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            // Organiza filhos em coluna vertical
            child: Column(
              // Centraliza filhos verticalmente
              mainAxisAlignment: MainAxisAlignment.center,
              // Estica filhos horizontalmente
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Lista de widgets filhos
              children: [
                // Exibe título da tela
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                // Adiciona espaçamento vertical fixo
                const SizedBox(height: 40),
                
                // Renderiza campo de entrada de texto para usuário
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuário',
                    border: OutlineInputBorder(),
                  ),
                ),
                // Adiciona espaçamento vertical fixo
                const SizedBox(height: 20),

                // Renderiza campo de entrada de texto para senha
                TextField(
                  controller: _passwordController,
                  // Oculta caracteres digitados
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                // Adiciona espaçamento vertical fixo
                const SizedBox(height: 40),

                // Renderiza botão elevado para ação de login
                ElevatedButton(
                  // Vincula função de login ao evento de clique
                  onPressed: _onLoginPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Entrar'),
                ),
                // Adiciona espaçamento vertical fixo
                const SizedBox(height: 20),

                // Renderiza botão de texto para ação de cadastro
                TextButton(
                  // Vincula função de cadastro ao evento de clique
                  onPressed: _onRegisterPressed,
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}