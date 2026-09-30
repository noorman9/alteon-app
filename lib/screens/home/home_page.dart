import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Product> products = const [
    Product(
      id: 1,
      name: 'Laptop',
      price: 8000000,
      image: 'https://picsum.photos/id/1/500/500',
      description: 'Laptop untuk kebutuhan kerja dan belajar.',
    ),
    Product(
      id: 2,
      name: 'Mouse',
      price: 300000,
      image: 'https://picsum.photos/id/2/500/500',
      description: 'Mouse wireless untuk kebutuhan sehari-hari.',
    ),
    Product(
      id: 3,
      name: 'Keyboard',
      price: 700000,
      image: 'https://picsum.photos/id/3/500/500',
      description: 'Keyboard mechanical dengan desain compact.',
    ),
    Product(
      id: 4,
      name: 'Monitor',
      price: 2500000,
      image: 'https://picsum.photos/id/4/500/500',
      description: 'Monitor untuk gaming dan produktivitas.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProductDetailPage(product: product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
