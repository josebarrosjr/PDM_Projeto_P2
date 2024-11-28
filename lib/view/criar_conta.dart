import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class criarConta extends StatefulWidget {
  const criarConta({super.key});

  @override
  State<criarConta> createState() => _criarContaState();
}

class _criarContaState extends State<criarConta> {
  var txtNome = TextEditingController();
  var txtMail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtConfirmaSenha = TextEditingController();
  var formKey = GlobalKey<FormState>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar conta',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.red.shade400,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 60, 50, 60),
          child: Column(
            children: [
              // Campo Nome
              _buildTextField('Nome', txtNome, 'Digite seu nome'),

              SizedBox(height: 20),

              // Campo E-mail
              _buildTextField('e-mail', txtMail, 'Digite seu e-mail'),

              SizedBox(height: 20),

              // Campo Senha
              _buildTextField('Senha', txtSenha, 'Digite sua senha',
                  obscureText: true),

              SizedBox(height: 20),

              // Campo Confirmar Senha
              _buildTextField('Confirme sua senha', txtConfirmaSenha,
                  'Digite novamente a senha',
                  obscureText: true),

              SizedBox(height: 40),

              // Botão Cadastrar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await _criarConta(context);
                  }
                },
                child: Text('Cadastrar', style: TextStyle(fontSize: 20)),
              ),

              SizedBox(height: 10),

              // Botão Voltar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                child: Text('Voltar', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para criar conta
  Future<void> _criarConta(BuildContext context) async {
    try {
      // Criar usuário no Firebase Authentication
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: txtMail.text,
        password: txtSenha.text,
      );

      // Armazenar informações adicionais no Firestore
      await db.collection('usuarios').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'nome': txtNome.text,
        'email': txtMail.text,
      });

      // Exibir mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Usuário cadastrado com sucesso!'),
        backgroundColor: Colors.green,
      ));

      // Navegar para outra tela
      Navigator.pushNamed(context, 'tela_inicial');
    } catch (e) {
      // Exibir mensagens de erro personalizadas
      String errorMessage = _getErrorMessage(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Método para personalizar mensagens de erro
  String _getErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'O email já foi cadastrado.';
        case 'invalid-email':
          return 'O formato do email é inválido.';
        case 'weak-password':
          return 'A senha deve ter no mínimo 6 caracteres.';
        default:
          return 'Erro: ${e.message}';
      }
    }
    return 'Erro desconhecido. Tente novamente.';
  }

  // Widget para criar campos de texto reutilizáveis
  Widget _buildTextField(String label, TextEditingController controller,
      String hintText,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            labelText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha este campo';
            }
            if (label == 'Confirme sua senha' &&
                value != txtSenha.text) {
              return 'As senhas não coincidem';
            }
            return null;
          },
        ),
      ],
    );
  }
}
