import '../services/cart_service.dart';

class CartRepository {
  final CartService service;

  CartRepository({
    required this.service,
  });

  Future<Map<String, dynamic>> getCart(String token) {
    return service.getCart(token);
  }

  Future<Map<String, dynamic>> addItem(
    String token,
    int productId,
    int quantity,
  ) {
    return service.addItem(
      token,
      productId,
      quantity,
    );
  }

  Future<Map<String, dynamic>> updateItem(
    String token,
    int itemId,
    int quantity,
  ) {
    return service.updateItem(
      token,
      itemId,
      quantity,
    );
  }

  Future<void> deleteItem(
    String token,
    int itemId,
  ) {
    return service.deleteItem(
      token,
      itemId,
    );
  }
}