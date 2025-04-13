import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';       
import 'register.dart';   
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _hashPasswordController = TextEditingController();
  bool _passwordVisible = false;

  Future<void> loginUser() async {

    @override
    void initState() {
      super.initState();
      _inputController.clear();
      _hashPasswordController.clear();
    }

_inputController.text = _inputController.text.trim();
_hashPasswordController.text = _hashPasswordController.text.trim();

  final input = _inputController.text.trim();
  final password = _hashPasswordController.text.trim();

  if (input.isEmpty || password.isEmpty) {
    _showMessage('Preencha todos os campos');
    return;
  }

  final isEmail = input.contains('@');
  final body = {
    if (isEmail) 'email': input else 'cpf': input.replaceAll(RegExp(r'\D'), ''),
    'hashPassword': password,
  };

  print('Enviando login com corpo: $body');

  try {
    final response = await http.post(
      Uri.parse('https://api.douumhelp.com.br/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('CHAVES NO JSON: ${data.keys}');
      print('BODY JSON: $data');
      final token = data['token'];


      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token); 

        print('Login OK! Redirecionando para Home...');
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showMessage('Token não encontrado na resposta.');
      }
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Erro ao fazer login.';
      _showMessage(error);
    }
  } catch (e) {
    _showMessage('Erro de conexão: $e');
    print('Erro de conexão: $e');
  }
}

    void _showMessage(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Text("Logo não encontrada", style: GoogleFonts.outfit(color: Colors.red));
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Bem-vindo!',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Acesse sua conta para continuar e aproveitar todas as funcionalidades.🛠️',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField('Email', _inputController, Icons.email, false),
                SizedBox(height: 10),
                _buildTextField('Senha', _hashPasswordController, Icons.lock, true),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // ação de esqueci a senha
                    },
                    child: Text(
                      'Esqueceu a sua senha?',
                      style: GoogleFonts.outfit(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFACC15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  ),
                  onPressed: loginUser,
                  child: Text(
                    'Entrar',
                    style: GoogleFonts.outfit(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Não tem conta?',
                  style: GoogleFonts.outfit(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Crie agora!',
                    style: GoogleFonts.outfit(
                      color: Colors.yellow[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_passwordVisible : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Color(0xFFFACC15), width: 2),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
