import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

class NovaSenha extends StatefulWidget {
  const NovaSenha({super.key});

  @override
  State<NovaSenha> createState() => _NovaSenhaState();
}

class _NovaSenhaState extends State<NovaSenha> {
  // Controlador do campo de texto
  var txtMail = TextEditingController();

  // Identificador do formulário
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recuperar Senha',
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
              SizedBox(height: 100),

              // Campo de email
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
              SizedBox(height: 150),

              // Botão Confirmar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    LoginController().esqueceuSenha(context, txtMail.text.trim());
                  }
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 20),
                ),
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
                child: Text(
                  'Voltar',
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
