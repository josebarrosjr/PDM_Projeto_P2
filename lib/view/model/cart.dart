class Cart {
  static final List<CartItem> _items = [];

  // Método para adicionar itens ao carrinho

  static void addItem(CartItem item) {
    _items.add(item);
  }

  // Método para remover itens do carrinho
  static void removeItem(CartItem item) {
    _items.remove(item);
  }

  // Método para limpar o carrinho
  static void clearCart() {
    _items.clear();
  }

  // Retorna os itens no carrinho
  static List<CartItem> get items => _items;

  // Calcula o preço total dos itens no carrinho
  static double getTotalPrice() {
    return _items.fold(0.0, (total, current) => total + (current.preco * current.quantidade));
  }
}

class CartItem {
  final String id;       
  final String nome;
  final double preco;
  int quantidade;

  CartItem({
    required this.id,       
    required this.nome,
    required this.preco,
    this.quantidade = 1,  // Inicializa a quantidade com 1 por padrão
  })
  
  {
  if (id.isEmpty || nome.isEmpty || preco <= 0) {
    throw ArgumentError('Campos inválidos ao criar um CartItem');
    }
  }
}