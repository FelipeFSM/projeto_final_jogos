import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    if (usersJson != null) usersMap = jsonDecode(usersJson);

    if (usersMap.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nenhum usuário cadastrado. Vá em "Cadastre-se".')));
      }
      return;
    }

    if (usersMap.containsKey(inputUser) && usersMap[inputUser] == inputPass) {
      // Persistência Local: Uso do shared_preferences para salvar dados simples (login status e usuário atual).
      await prefs.setBool('is_logged', true);
      await prefs.setString('current_user', inputUser);
      if (mounted) Navigator.pushReplacementNamed(context, '/backlog');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário ou senha incorretos.')));
      }
      throw Exception('Login falhou'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF121212),
              const Color(0xFF1E1E1E),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Icon(
                    Icons.gamepad, 
                    size: 80, 
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
                const SizedBox(height: 20),
                
                const Text(
                  'Bem-vindo de volta!',
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                
                const SizedBox(height: 30),

                
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  color: const Color(0xFF252525), 
                  child: Container(
                    width: 380, 
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, 
                      children: [
                        
                        // Eventos e Formulários: Formulário com TextFields e Controllers.
                        TextField(
                          controller: _userController,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: 'Usuário',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.black12,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.black12,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                        
                        const SizedBox(height: 30),

                        
                        Center(
                          child: FutureBuilder<void>(
                            future: _loginFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  width: 24, height: 24, 
                                  child: CircularProgressIndicator(strokeWidth: 2)
                                );
                              }
                              
                              
                              return SizedBox(
                                width: 200, 
                                height: 45, 
                                child: ElevatedButton(
                                  onPressed: () { 
                                    setState(() { _loginFuture = _processarLogin(); }); 
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    shape: const StadiumBorder(), 
                                    padding: EdgeInsets.zero, 
                                  ),
                                  child: const Text(
                                    'ENTRAR', 
                                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/cadastro'),
                  child: RichText(
                    text: TextSpan(
                      text: 'Não tem uma conta? ',
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Cadastre-se',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}