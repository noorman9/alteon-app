import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
      ),
      body: const Center(
        child: Text(
          'Halaman Pesanan',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}