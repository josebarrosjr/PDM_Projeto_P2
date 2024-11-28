import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PedidosTela extends StatelessWidget {
  const PedidosTela({super.key});

  // Função para alterar o status do pedido
  Future<void> _confirmarPedido(DocumentReference pedidoRef) async {
    try {
      // Atualiza o status do pedido para 'finalizado'
      await pedidoRef.update({'status': 'finalizado'});
      // Exibe uma mensagem de sucesso
      print('Pedido finalizado com sucesso!');
    } catch (e) {
      print('Erro ao finalizar o pedido: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
        backgroundColor: Colors.red.shade400,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Nenhum pedido encontrado."));
          }

          var pedidos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              var pedido = pedidos[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${pedido['status']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Data: ${pedido['data_hora']}',
                    style: TextStyle(fontSize: 16),
                  ),
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
                            title: Text(
                              item['item_id'],
                              style: TextStyle(fontSize: 16),
                            ),
                            subtitle: Text(
                                'Preço: R\$ ${item['preco']} - Quantidade: ${item['quantidade']}'),
                          );
                        },
                      );
                    },
                  ),
                  Divider(),

                  // Verifica se o status é 'preparando'
                  if (pedido['status'] == 'preparando')
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 50),
                          backgroundColor: Colors.red, // Cor vermelha
                        ),
                        onPressed: () {
                          // Chama a função para atualizar o status para 'finalizado'
                          _confirmarPedido(pedido.reference);
                          // Exibe uma mensagem de sucesso
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Pedido finalizado!'),
                            backgroundColor: Colors.green,
                          ));
                        },
                        child: Text(
                          'Confirmar Pedido',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
