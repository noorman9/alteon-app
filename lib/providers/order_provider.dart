import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../repositories/order_repository.dart';
import '../services/auth_storage.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository repository;
  final AuthStorage storage;

  OrderProvider({required this.repository, required this.storage});

  final List<Order> _orders = [];

  bool _isLoading = false;
  String? _error;

  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<String?> _getToken() async {
    return await storage.getToken();
  }

  Future<void> loadOrders() async {
    final token = await _getToken();

    if (token == null) {
      _orders.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await repository.getOrders(token);

      _orders
        ..clear()
        ..addAll(data.map((json) => Order.fromJson(json)));
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Order?> getOrder(int orderId) async {
    final token = await _getToken();

    if (token == null) {
      _error = 'Silakan login terlebih dahulu';
      notifyListeners();
      return null;
    }

    try {
      final data = await repository.getOrder(token, orderId);

      return Order.fromJson(data);
    } catch (e) {
      _handleError(e);
      notifyListeners();
      return null;
    }
  }

  Future<bool> createOrder() async {
    final token = await _getToken();

    if (token == null) {
      _error = 'Silakan login terlebih dahulu';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await repository.createOrder(token);

      await loadOrders();

      return true;
    } catch (e) {
      _handleError(e);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _orders.clear();
    _error = null;
    notifyListeners();
  }

  void _handleError(Object e) {
    final message = e.toString();

    if (message.contains('SocketException') ||
        message.contains('Connection refused')) {
      _error = 'Tidak dapat terhubung ke server';
      return;
    }

    _error = message.replaceFirst('Exception: ', '');
  }
}
