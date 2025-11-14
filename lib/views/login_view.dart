// Importa a biblioteca 'material.dart' para acesso aos widgets.
import 'package:flutter/material.dart';

// Define a classe do widget 'LoginView' como 'StatefulWidget'.
// Isso indica que o widget terá um objeto 'State' associado.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  // Este método obrigatório cria o objeto 'State' mutável para este widget.
  @override
  State<LoginView> createState() => _LoginViewState();
}

// A classe '_LoginViewState' armazena o estado mutável para o 'LoginView'.
// Toda a lógica e variáveis de estado ficam aqui.
class _LoginViewState extends State<LoginView> {
  // 1. Controladores de Texto (Requisito de Formulário)
  // 'TextEditingController' gerencia o texto editável de um 'TextField'.
  // 'final' indica que a referência ao controlador não mudará.
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // O método 'dispose' é chamado quando o objeto 'State' é removido
  // permanentemente da árvore de widgets.
  @override
  void dispose() {
    // É crucial chamar 'dispose' nos controladores para liberar
    // os recursos de memória que eles estão usando.
    _userController.dispose();
    _passwordController.dispose();
    super.dispose(); // Chama o método 'dispose' da superclasse.
  }

  // Função de callback para o evento 'onPressed' do botão de login.
  void _onLoginPressed() {
    // A propriedade '.text' do controlador retorna o texto atual.
    String username = _userController.text;
    String password = _passwordController.text;

    // 'print' exibe a string no console de depuração.
    print('Tentativa de Login com: $username / $password');
    // TODO: Lógica de autenticação com SharedPreferences.
  }

  // Função de callback para o evento 'onPressed' do botão de registro.
  void _onRegisterPressed() {
    print('Ir para a tela de Cadastro');
    // TODO: Lógica de navegação para a tela de cadastro.
  }

  // O método 'build' reconstrói a interface sempre que o estado muda.
  @override
  Widget build(BuildContext context) {
    // 'Scaffold' implementa a estrutura básica de layout visual
    // do Material Design (permite AppBar, Body, etc.).
    return Scaffold(
      // 'body' define o widget principal a ser exibido no 'Scaffold'.
      // 'Center' alinha seu filho ao centro da área disponível.
      body: Center(
        // 'Padding' aplica um espaçamento interno em seu filho.
        child: Padding(
          padding: const EdgeInsets.all(24.0), // 24 pixels em todos os lados.
          
          // 'ConstrainedBox' impõe restrições de tamanho adicionais
          // ao seu filho. Útil para limitar a largura em layouts web.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400), // Largura máxima de 400px.
            
            // 'Column' organiza uma lista de widgets filhos no eixo vertical.
            child: Column(
              // 'mainAxisAlignment' alinha os filhos verticalmente.
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza na coluna.
              
              // 'crossAxisAlignment' alinha os filhos horizontalmente.
              crossAxisAlignment: CrossAxisAlignment.stretch, // Estica para preencher a largura.
              
              // 'children' é a lista de widgets a serem exibidos na coluna.
              children: [
                // 'Text' exibe uma string de texto com um estilo.
                const Text(
                  'Login',
                  // 'TextStyle' define a aparência do texto.
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Alinhamento do texto.
                ),
                
                // 'SizedBox' cria uma caixa com um tamanho específico,
                // usada aqui como um espaçador vertical.
                const SizedBox(height: 40),

                // 'TextField' é um campo de entrada de texto.
                TextField(
                  // 'controller' associa o campo ao seu controlador.
                  controller: _userController,
                  // 'decoration' define o design visual do campo.
                  decoration: const InputDecoration(
                    labelText: 'Usuário',
                    border: OutlineInputBorder(), // Estilo de borda.
                  ),
                ),
                const SizedBox(height: 20),

                // 'TextField' para a senha.
                TextField(
                  controller: _passwordController,
                  obscureText: true, // Oculta o texto digitado.
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),

                // 'ElevatedButton' é um botão com preenchimento (elevado).
                ElevatedButton(
                  // 'onPressed' é o callback disparado quando o botão é pressionado.
                  onPressed: _onLoginPressed,
                  style: ElevatedButton.styleFrom(
                    // Define o padding interno do botão.
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 20),

                // 'TextButton' é um botão sem elevação, apenas texto.
                TextButton(
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