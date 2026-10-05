import 'dart:convert';

import 'package:http/http.dart' as http;

class CartService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> getCart(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Gagal mengambil cart: ${response.body}');
  }

  Future<Map<String, dynamic>> addItem(
    String token,
    int productId,
    int quantity,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/items'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    throw Exception('Gagal menambahkan ke cart: ${response.body}');
  }

  Future<Map<String, dynamic>> updateItem(
    String token,
    int itemId,
    int quantity,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/cart/items/$itemId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Gagal mengubah quantity: ${response.body}');
  }

  Future<void> deleteItem(
    String token,
    int itemId,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/items/$itemId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus item: ${response.body}');
    }
  }
}