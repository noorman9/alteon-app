import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';

// import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider({required this.repository});

  Future<void> createProduct({
    required String name,
    required double price,
    required String description,
    required String image,
  }) async {
    try {
      final product = await repository.createProduct(
        name: name,
        price: price,
        description: description,
        image: image,
      );

      _products.add(product);

      notifyListeners();
    } catch (e) {
      _handleError(e);

      notifyListeners();
    }
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required double price,
    required String description,
    required String image,
  }) async {
    try {
      final updatedProduct = await repository.updateProduct(
        id: id,
        name: name,
        price: price,
        description: description,
        image: image,
      );

      final index = _products.indexWhere((product) => product.id == id);

      if (index != -1) {
        _products[index] = updatedProduct;
      }

      notifyListeners();
    } catch (e) {
      _handleError(e);

      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);

      _products.removeWhere((product) => product.id == id);

      notifyListeners();
    } catch (e) {
      _handleError(e);

      notifyListeners();
    }
  }

  List<Product> _products = [];

  bool _isLoading = false;

  String? _error;

  List<Product> get products => List.unmodifiable(_products);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _products = await repository.getProducts();
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
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
