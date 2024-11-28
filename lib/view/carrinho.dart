import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p1_projeto/view/model/cart.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final items = Cart.items;
    final total = Cart.getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho de Compras'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Lógica do carrinho aqui
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('R\$ ${item.preco.toStringAsFixed(2)}'),
                          Row(
                            children: [
                              Text('Quantidade:'),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  // REDUZIR ITEM
                                  setState(() {
                                    if (item.quantidade > 1) {
                                      item.quantidade--;
                                    }
                                  });
                                },
                              ),
                              Text('${item.quantidade}'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  // AUMENTAR ITEM
                                  setState(() {
                                    item.quantidade++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // REMOVER ITEM
                          setState(() {
                            Cart.removeItem(item);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // VALOR DO CARRINHO
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // BOTÃO FINALIZAR COMPRA
            ElevatedButton(
              onPressed: () {
                _finalizarCompra(items); // Finalizar pedido no Firestore
              },
              child: Text('Finalizar Compra', style: TextStyle(fontSize: 20, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 50),
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para finalizar o pedido e registrar no Firestore
  Future<void> _finalizarCompra(List<CartItem> items) async {
    try {
      // Coleta o UID do cliente (substitua com lógica de autenticação)
      //String uid = 'ID_DO_CLIENTE'; // Substitua com a forma de obter o UID do cliente
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'UID_DO_CLIENTE';


      // Cria o pedido no Firestore
      var pedidoRef = await _firestore.collection('pedidos').add({
        'uid': uid,
        'status': 'preparando',
        'data_hora': DateTime.now().toString(),
      });

      // Adiciona os itens no pedido
      for (var item in items) {
        await pedidoRef.collection('itens').add({
          'item_id': item.id,
          'preco': item.preco,
          'quantidade': item.quantidade,
        });
      }

      // Limpa o carrinho após finalizar a compra
      Cart.clearCart();

      // Exibe a confirmação de pedido
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pedido feito com sucesso!',
            style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ));

      // Redireciona para a tela inicial após finalizar o pedido
      Navigator.pushNamed(context, 'tela_inicial');
    } catch (e) {
      print('Erro ao finalizar pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao finalizar o pedido, tente novamente.',
            style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

}
