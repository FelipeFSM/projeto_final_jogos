import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // 1. Controladores para os campos de texto
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Limpa os controladores quando a tela é descartada
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    // Lógica de login (vamos implementar depois)
    String username = _userController.text;
    String password = _passwordController.text;

    print('Tentativa de Login com: $username / $password');
    // TODO: Adicionar lógica de SharedPreferences aqui
  }

  void _onRegisterPressed() {
    // Lógica para navegar para a tela de cadastro
    print('Ir para a tela de Cadastro');
    // TODO: Adicionar navegação aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400), // Limita a largura no Chrome
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // 2. TextField de Usuário
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuário',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. TextField de Senha
                TextField(
                  controller: _passwordController,
                  obscureText: true, // Esconde a senha
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),

                // 4. Botão de Login
                ElevatedButton(
                  onPressed: _onLoginPressed, // Evento
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 20),

                // 5. Botão de Cadastro
                TextButton(
                  onPressed: _onRegisterPressed, // Evento
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