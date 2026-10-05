import 'dart:convert';

import 'package:http/http.dart' as http;

class OrderService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> createOrder(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    }

    throw Exception(data['message'] ?? 'Gagal membuat order');
  }

  Future<List<dynamic>> getOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['orders'] ?? [];
    }

    throw Exception('Gagal mengambil orders: ${response.body}');
  }

  Future<Map<String, dynamic>> getOrder(String token, int orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$orderId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['order'];
    }

    throw Exception('Gagal mengambil detail order: ${response.body}');
  }
}
