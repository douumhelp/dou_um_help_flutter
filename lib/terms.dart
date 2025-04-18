import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'home.dart';

class Terms extends StatefulWidget {
  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  bool aceitoTermos = false;
  final TextEditingController _cpfController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void _submitForm() {
    if (_cpfController.text.isEmpty || _cpfController.text.length < 14) {
      _showMessage('Por favor, preencha um CPF válido');
      return;
    }

    if (!aceitoTermos) {
      _showMessage('Você precisa aceitar os Termos e Condições');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
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
      backgroundColor: Colors.white, // fundo branco
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.arrow_circle_right, color: Color(0xFFFACC15), size: 32),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Apenas mais um\npasso para terminar\nsua conta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'CPF (Campo obrigatório)',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFFd1d5db)),
                ),
                child: TextField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [cpfMaskFormatter],
                  decoration: const InputDecoration(
                    hintText: 'Digite seu CPF',
                    hintStyle: TextStyle(color: Color(0xFF6B7280)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFd1d5db)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Termos e Condições',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. '
                      'Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. '
                      'Cras elementum ultrices diam...',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: aceitoTermos,
                    onChanged: (value) {
                      setState(() {
                        aceitoTermos = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Estou Ciente e Aceito os Termos e Condições da Empresa',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFACC15),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
