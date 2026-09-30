import 'package:flutter/material.dart';

import '../models/product.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Image.network(
          product.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(product.name),
        subtitle: Text(
          'Rp ${product.price.toStringAsFixed(0)}',
        ),
      ),
    );
  }
}