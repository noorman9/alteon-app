import '../services/order_service.dart';

class OrderRepository {
  final OrderService service;

  OrderRepository({
    required this.service,
  });

  Future<Map<String, dynamic>> createOrder(String token) {
    return service.createOrder(token);
  }

  Future<List<dynamic>> getOrders(String token) {
    return service.getOrders(token);
  }

  Future<Map<String, dynamic>> getOrder(
    String token,
    int orderId,
  ) {
    return service.getOrder(token, orderId);
  }
}