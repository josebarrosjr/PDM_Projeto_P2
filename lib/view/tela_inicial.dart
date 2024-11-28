import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<Map<String, dynamic>> dados = []; // Lista de itens do Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _carregarDados(); // Carregar dados do Firestore
  }

  // Função para carregar dados do Firestore
  Future<void> _carregarDados() async { 
    try {
    // Buscando dados da coleção 'itens_cardapio'
    var querySnapshot = await firestore.collection('itens_cardapio').get();
    setState(() {
      dados = querySnapshot.docs.map((doc) => doc.data()).toList();
    });

    print('Dados carregados: $dados'); // Adicionando log de depuração
  } catch (e) {
    print('Erro ao carregar dados: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'Cardápio',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        backgroundColor: Colors.red.shade400,
        actions: [
          
          IconButton(
            icon: Row(
            mainAxisSize: MainAxisSize.min,
              children: [
              Icon(Icons.list_alt, size: 30, color: Colors.white),  // Ícone de pedidos
              SizedBox(width: 8), // Espaço entre o ícone e o texto
              Text(
                'Pedidos',
                style: TextStyle(
                color: Colors.white,
                fontSize: 16, // Ajuste o tamanho da fonte conforme necessário
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'pedidos'); // Substitua 'pedidos' pela rota da tela de pedidos
          },
          ),

          IconButton(
            icon: Icon(Icons.shopping_cart, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'carrinho');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: dados.isEmpty
            ? Center(child: CircularProgressIndicator()) // Exibe carregando
            : ListView(
                children: [
                  _buildSection('Entradas'),
                  _buildSection('Prato Principal'),
                  _buildSection('Bebidas'),
                  _buildSection('Sobremesa'),
                ],
              ),
      ),
    );
  }

  // Função para construir cada seção do cardápio
  Widget _buildSection(String titulo) {
    // Filtra os itens por categoria
    var itensFiltrados = dados.where((item) {
      return item['categoria'] == titulo;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade400,
            ),
          ),
        ),
        Column(
          children: List.generate(itensFiltrados.length, (index) {
            var item = itensFiltrados[index];
            return Card(
              child: ListTile(
                title: Text(
                  item['nome'],
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text(
                  'R\$ ${item['preco'].toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),

                trailing: Icon(Icons.arrow_right),
                hoverColor: Colors.blue.shade100,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'detalhes',
                    arguments: item,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}
