class Lista{

  final String nome;
  final String descricao;
  final double preco;
  final String foto;

  Lista(
    this.nome,
    this.descricao,
    this.preco,
    this.foto,
    );

  static List<Lista> gerarDados() {
    List<Lista> lista = [];
    
    lista.add(Lista('Salada Caesar', 'Croutons crocantes, alface, frango desfiado e molho cremoso.', 15.90 , 'assets/images/salada_caesar.jpg'));
    lista.add(Lista('Gratinado de filé', 'Tiras de filé trufado com cogumelos', 26.50 , 'assets/images/gratinado_file.jpg'));
    lista.add(Lista('Salada Tropical', 'Mix de folhas com peito de peru, tomate, maçã e queijo brie.', 15.90 , 'assets/images/salada_tropical.jpg'));
    lista.add(Lista('Fettuccine', 'Escolha seu molho: \nTomate fresco com manjericão \nParmesão, limão e parma crocante \nQuatro queijos \nMix de cogumelos', 40.00 ,'assets/images/fettuccine.jpg'));
    lista.add(Lista('Risoto', 'Sabores: \nAlho poró e tiras de salmão \nGorgonzola e tiras de filé \nCogumelos \nCamarão e limão siciliano', 55.00 ,'assets/images/risoto.jpg'));
    lista.add(Lista('Polpetone', 'Acompanha arroz branco e fritas.', 35.00 ,'assets/images/polpetone.jpg'));
    lista.add(Lista('Lasanha de filé', 'Lasanha com tiras de filé e gorgonzola.', 48.00 ,'assets/images/lasanha_file.jpg'));
    lista.add(Lista('Carré assado', 'Carré com risoto de limão e hortelã', 53.00 ,'assets/images/carre_assado.jpg'));
    lista.add(Lista('Suco natural', 'Sabores: \nLaranja \nLimão \nAbacaxi \nMorango', 15.00 ,'assets/images/suco_natural.jpg'));
    lista.add(Lista('Refrigerante', 'Sabores: \nRefrigerante de Cola \nGuaraná \nTonica', 18.90 ,'assets/images/refrigerante.jpg'));
    lista.add(Lista('Água', 'Água mineral com ou sem gás.', 9.50 ,'assets/images/agua.jpg'));
    lista.add(Lista('Torta Holandesa', 'Creme de baunilha coberto com ganache de chocolate e biscoito.', 27.00 ,'assets/images/torta_holandesa.jpg'));
    lista.add(Lista('Sorvete', 'Sabores: \nMorango \nChocolate \nBaunilha', 19.90 ,'assets/images/sorvete.jpg'));
    
    return lista;
  }
}