import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  final String baseUrl = 'http://10.0.2.2:8000/api/products';

  Future<Product> updateProduct({
    required int id,
    required String name,
    required double price,
    required String description,
    required String image,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': name,
        'price': price,
        'description': description,
        'thumbnail': image,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah produk');
    }

    final data = jsonDecode(response.body);

    return Product(
      id: data['id'],
      name: data['title'],
      price: (data['price'] as num).toDouble(),
      image: data['thumbnail'],
      description: data['description'],
      stock: data['stock'] ?? 0,
    );
  }

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data produk: ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    final List products = data;
    return products.map((item) {
      return Product(
        id: int.parse(item['id'].toString()),
        name: item['name'],
        price: double.parse(item['price'].toString()),
        image: item['image'] ?? '',
        description: item['description'] ?? '',
        stock: int.parse(item['stock'].toString()),
      );
    }).toList();
  }

  Future<Product> createProduct({
    required String name,
    required double price,
    required String description,
    required String image,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': name,
        'price': price,
        'description': description,
        'thumbnail': image,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal membuat produk');
    }

    final data = jsonDecode(response.body);

    return Product(
      id: data['id'],
      name: data['title'],
      price: (data['price'] as num).toDouble(),
      image: data['thumbnail'],
      description: data['description'],
      stock: data['stock'] ?? 0,
    );
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus produk');
    }
  }
}
