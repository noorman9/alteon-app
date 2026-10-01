import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  final String baseUrl = 'https://dummyjson.com/products';

  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data produk');
    }

    final data = jsonDecode(response.body);

    final List products = data['products'];

    return products.map((item) {
      return Product(
        id: item['id'],
        name: item['title'],
        price: (item['price'] as num).toDouble(),
        image: item['thumbnail'],
        description: item['description'],
      );
    }).toList();
  }
}