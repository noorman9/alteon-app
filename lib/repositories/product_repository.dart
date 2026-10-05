import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService service;

  ProductRepository({required this.service});

  Future<List<Product>> getProducts() {
    return service.getProducts();
  }

  Future<Product> updateProduct({
    required int id,
    required String name,
    required double price,
    required String description,
    required String image,
  }) {
    return service.updateProduct(
      id: id,
      name: name,
      price: price,
      description: description,
      image: image,
    );
  }

  Future<void> deleteProduct(int id) {
    return service.deleteProduct(id);
  }

  Future<Product> createProduct({
    required String name,
    required double price,
    required String description,
    required String image,
  }) {
    return service.createProduct(
      name: name,
      price: price,
      description: description,
      image: image,
    );
  }
}
