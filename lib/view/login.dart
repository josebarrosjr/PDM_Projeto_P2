import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Identificador do formulário
  var formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  var txtMail = TextEditingController();
  var txtSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 60, 50, 60),
          child: Column(
            children: [
              Icon(Icons.food_bank, size: 100),
              Text(
                'Cardápio Online',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 80),
              Row(
                children: [
                  Text('Login', style: TextStyle(fontSize: 25)),
                ],
              ),
              SizedBox(height: 20),

              // CAMPO EMAIL
              TextFormField(
                controller: txtMail,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'e-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu e-mail';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // CAMPO SENHA
              TextFormField(
                controller: txtSenha,
                style: TextStyle(fontSize: 20),
                obscureText: true, // Oculta a senha
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite sua senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // BOTÃO REDEFINIR SENHA
              TextButton(
                onPressed: () {
                  if (txtMail.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Informe o email para redefinir a senha.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    LoginController().esqueceuSenha(context, txtMail.text);
                  }
                },
                child: Text(
                  'Esqueceu a senha?',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
              SizedBox(height: 30),

              // BOTÃO LOGIN
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    LoginController().login(
                      context,
                      txtMail.text.trim(),
                      txtSenha.text.trim(),
                    );
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10),

              // BOTÃO CRIAR CONTA
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'criar_conta');
                },
                child: Text(
                  'Criar uma conta',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
