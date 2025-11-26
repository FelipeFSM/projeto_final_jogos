import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cadastro_view.dart';
import 'backlog_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  Future<void>? _loginFuture;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _processarLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    String inputUser = _userController.text.trim();
    String inputPass = _passwordController.text;

    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users_db');
    Map<String, dynamic> usersMap = {};

    if (usersJson != null) {
      usersMap = jsonDecode(usersJson);
    }

    if (usersMap.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum usuário cadastrado. Vá em "Cadastre-se".')),
        );
      }
      return; 
    }

    if (usersMap.containsKey(inputUser) && usersMap[inputUser] == inputPass) {
      await prefs.setBool('is_logged', true);
      await prefs.setString('current_user', inputUser);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/backlog');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha incorretos.')),
        );
      }
      throw Exception('Falha no login'); 
    }
  }

  void _onRegisterPressed() {
    Navigator.pushNamed(context, '/cadastro');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login', 
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _userController, 
                  decoration: const InputDecoration(labelText: 'Usuário', border: OutlineInputBorder())
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController, 
                  obscureText: true, 
                  decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder())
                ),
                const SizedBox(height: 40),
                
                FutureBuilder<void>(
                  future: _loginFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loginFuture = _processarLogin();
                        });
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Entrar'),
                    );
                  },
                ),
                // ---------------------------------------------------

                const SizedBox(height: 20),
                TextButton(
                  onPressed: _onRegisterPressed, 
                  child: const Text('Não tem uma conta? Cadastre-se')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}