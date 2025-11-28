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
    
    if (usersJson != null) usersMap = jsonDecode(usersJson);

    if (usersMap.containsKey(username)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário já existe!')));
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
                  tag: 'app_logo_cad',
                  child: Icon(
                    Icons.person_add_alt_1_rounded, 
                    size: 70, 
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
                const SizedBox(height: 15),
                
                const Text(
                  'Criar Nova Conta',
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

                        const SizedBox(height: 20),

                       
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            labelText: 'Confirmar Senha',
                            prefixIcon: const Icon(Icons.lock_reset),  
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.black12,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                        
                        const SizedBox(height: 30),

                        Center(
                          child: FutureBuilder<void>(
                            future: _cadastroFuture,
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
                                    setState(() { _cadastroFuture = _processarCadastro(); }); 
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    shape: const StadiumBorder(),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    'CADASTRAR', 
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

                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Voltar para Login'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey, 
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