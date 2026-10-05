import 'product.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = Product(
      id: json['product_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      description: '',
      stock: json['stock'] ?? 0,
    );

    return CartItem(
      id: json['id'],
      product: product,
      quantity: json['quantity'],
    );
  }

  double get subtotal {
    return product.price * quantity;
  }
}