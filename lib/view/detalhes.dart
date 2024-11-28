import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p1_projeto/view/model/cart.dart';  // Importando para acessar o UID do usuário autenticado

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  final TextEditingController quantidadeController = TextEditingController(text: '1'); // Controlador para a quantidade

  @override
  Widget build(BuildContext context) {
    // Recebendo os dados do item via argumento
    var dados = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Verificação dos dados recebidos
    print(dados);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Item'),

        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, 'carrinho');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],

      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                dados['imagem'] != null
                    ? ClipRRect(
                      child: Image.asset(
                        'assets/images/${dados['imagem']}',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      )
                      )
                    : Icon(Icons.fastfood, size: 200),
                ListTile(
                  subtitle: Text(
                    dados['nome'],
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                ListTile(
                  title: Text('Descrição', style: TextStyle(fontSize: 22)),
                  subtitle: Text(
                    dados['descricao'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  title: Text('Preço', style: TextStyle(fontSize: 18)),
                  subtitle: Text(
                    'R\$ ${dados['preco'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),

                // CAMPO QUANTIDADE
                ListTile(
                  title: Text('Quantidade', style: TextStyle(fontSize: 18)),
                  subtitle: TextField(
                    controller: quantidadeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // BOTÃO ADICIONAR AO CARRINHO
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 50),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    int quantidade = int.tryParse(quantidadeController.text) ?? 1;
                    //String input = quantidadeController.text.trim();
                    //int quantidade = int.tryParse(input) ?? 1;
                    if (quantidade < 1) quantidade = 1;

                    // Cria o CartItem com o ID e outros dados
                    if (dados['id'] == null || dados['nome'] == null || dados['preco'] == null) {
                      print('Erro: Dados incompletos do item');
                        return; // Interrompe o processo se houver campos nulos
                    }


                    try {
                    var cartItem = CartItem(
                      id: dados['id']!,
                      nome: dados['nome']!,
                      preco: (dados['preco']! as num).toDouble(), // Garante que seja double
                       quantidade: quantidade,
                    );
                    //};

                    // Adiciona o item ao carrinho
                    Cart.addItem(cartItem);

                    // Exibe a SnackBar após a construção do frame
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$quantidade x ${dados['nome']} adicionado!',
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: Colors.blue,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  } catch (e) {
      print('Erro ao adicionar item ao carrinho: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar o item.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
                  child: Text(
                    'Adicionar ao Carrinho',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),

                SizedBox(height: 20),

                // Exibe os itens do pedido
                /* StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pedidos')
                      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid) // Filtra pelos pedidos do usuário
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("Nenhum pedido encontrado."));
                    }

                    // Recupera os itens dos pedidos
                    var pedidos = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: pedidos.length,
                      itemBuilder: (context, index) {
                        var pedido = pedidos[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${pedido['status']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Data: ${pedido['data_hora']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot>(
                              stream: pedido.reference.collection('itens').snapshots(),
                              builder: (context, itemSnapshot) {
                                if (itemSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                if (!itemSnapshot.hasData || itemSnapshot.data!.docs.isEmpty) {
                                  return Center(child: Text("Nenhum item encontrado."));
                                }

                                var itens = itemSnapshot.data!.docs;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: itens.length,
                                  itemBuilder: (context, itemIndex) {
                                    var item = itens[itemIndex];
                                    return ListTile(
                                      title: Text(item['item_id'], style: TextStyle(fontSize: 16)),
                                      subtitle: Text('Preço: R\$ ${item['preco']} - Quantidade: ${item['quantidade']}'),
                                    );
                                  },
                                );
                              },
                            ),
                            Divider(),
                          ],
                        );
                      },
                    );
                  },
                ),                  */
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Função para adicionar o item ao Firestore
  Future<void> _adicionarAoPedido(Map<String, dynamic> dados, int quantidade) async {
    try {
      //UID do cliente atual
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'UID_DO_CLIENTE';  //UID do cliente autenticado

      // Cria o pedido no Firestore
      var pedidoRef = await FirebaseFirestore.instance.collection('pedidos').add({
        'uid': uid,
        'status': 'preparando',
        'data_hora': DateTime.now().toString(),
      });

      // Adiciona o item na subcoleção de itens do pedido
      await pedidoRef.collection('itens').add({
        'item_id': dados['id'],
        'preco': dados['preco'],
        'quantidade': quantidade,
      });
    } catch (e) {
      print('Erro ao adicionar item ao pedido: $e');
    }
    print('Item Adicionado ao Carrinho: ${dados['nome']} x $quantidade');
  }
}
