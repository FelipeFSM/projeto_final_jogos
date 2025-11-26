import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  Future<void>? _cadastroFuture;

  Future<void> _processarCadastro() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    String username = _userController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos.')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('As senhas não coincidem.')));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString('users_db');
    Map<String, dynamic> usersMap = {};
    
    if (usersJson != null) {
      usersMap = jsonDecode(usersJson);
    }

    if (usersMap.containsKey(username)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário já existe! Tente outro nome.')));
      return;
    }

    usersMap[username] = password;
    await prefs.setString('users_db', jsonEncode(usersMap));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cadastro realizado com sucesso!')));
      Navigator.pop(context);
    }
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
              children: [
                const Text('Cadastro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                TextField(controller: _userController, decoration: const InputDecoration(labelText: 'Usuário', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                TextField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar Senha', border: OutlineInputBorder())),
                const SizedBox(height: 40),
                
                FutureBuilder<void>(
                  future: _cadastroFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _cadastroFuture = _processarCadastro();
                        });
                      },
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      child: const Text('Cadastrar'),
                    );
                  },
                ),
                // -------------------------------------

                const SizedBox(height: 10),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Voltar para Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}