import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../repositories/cart_repository.dart';
import '../services/auth_storage.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository repository;
  final AuthStorage storage;

  CartProvider({required this.repository, required this.storage});

  final List<CartItem> _items = [];

  bool _isLoading = false;
  String? _error;
  double _total = 0;

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isLoading => _isLoading;

  String? get error => _error;

  double get total => _total;

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  Future<String?> _getToken() async {
    return await storage.getToken();
  }

  Future<void> loadCart() async {
    final token = await _getToken();

    if (token == null) {
      _items.clear();
      _total = 0;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await repository.getCart(token);

      final List<dynamic> data = result['items'] ?? [];

      _items
        ..clear()
        ..addAll(data.map((item) => CartItem.fromJson(item)));

      _total = (result['total'] as num?)?.toDouble() ?? 0;
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addItem(Product product) async {
    final token = await _getToken();

    if (token == null) {
      _error = 'Silakan login terlebih dahulu';
      notifyListeners();
      return false;
    }

    if (product.stock <= 0) {
      _error = 'Stok ${product.name} sedang habis';
      notifyListeners();
      return false;
    }

    final existingItem = _findItem(product);

    if (existingItem != null) {
      if (existingItem.quantity >= product.stock) {
        _error = 'Stok ${product.name} hanya tersedia ${product.stock}';
        notifyListeners();
        return false;
      }
    }

    try {
      await repository.addItem(token, product.id, 1);

      await loadCart();

      return true;
    } catch (e) {
      _handleError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> increaseQuantity(Product product) async {
    final item = _findItem(product);

    if (item == null) {
      return false;
    }

    if (item.quantity >= product.stock) {
      _error = 'Stok ${product.name} hanya tersedia ${product.stock}';
      notifyListeners();
      return false;
    }

    return await updateQuantity(item, item.quantity + 1);
  }

  Future<bool> decreaseQuantity(Product product) async {
    final item = _findItem(product);

    if (item == null) {
      return false;
    }

    if (item.quantity <= 1) {
      return await removeItem(product);
    }

    return await updateQuantity(item, item.quantity - 1);
  }

  Future<bool> updateQuantity(CartItem item, int quantity) async {
    final token = await _getToken();

    if (token == null) return false;

    if (quantity < 1) return false;

    if (isProcessing(item.id)) {
      return false;
    }

    _setProcessing(item.id, true);

    try {
      await repository.updateItem(token, item.id, quantity);

      await loadCart();

      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      _setProcessing(item.id, false);
    }
  }

  Future<bool> removeItem(Product product) async {
    final item = _findItem(product);

    if (item == null) return false;

    final token = await _getToken();

    if (token == null) return false;

    if (isProcessing(item.id)) {
      return false;
    }

    _setProcessing(item.id, true);

    try {
      await repository.deleteItem(token, item.id);

      await loadCart();

      return true;
    } catch (e) {
      _handleError(e);
      return false;
    } finally {
      _setProcessing(item.id, false);
    }
  }

  CartItem? _findItem(Product product) {
    try {
      return _items.firstWhere((item) => item.product.id == product.id);
    } catch (_) {
      return null;
    }
  }

  void clearCart() {
    _items.clear();
    _total = 0;
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

  final Set<int> _processingItems = {};

  bool isProcessing(int itemId) {
    return _processingItems.contains(itemId);
  }

  void _setProcessing(int itemId, bool value) {
    if (value) {
      _processingItems.add(itemId);
    } else {
      _processingItems.remove(itemId);
    }

    notifyListeners();
  }
}
