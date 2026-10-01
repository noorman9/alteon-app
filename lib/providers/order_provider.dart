import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder({
    required List<CartItem> items,
    required double total,
  }) {
    final order = Order(
      id: _orders.length + 1,
      items: List.from(items),
      total: total,
      createdAt: DateTime.now(),
    );

    _orders.add(order);

    notifyListeners();
  }
}