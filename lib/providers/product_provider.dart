import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider({
    required this.repository,
  });

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
      _error = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}