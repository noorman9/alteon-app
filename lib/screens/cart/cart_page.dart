import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../widgets/cart_item_card.dart';
import '../../providers/order_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),

      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return CartItemCard(
                        item: item,

                        onIncrease: () {
                          cart.increaseQuantity(item.product);
                        },

                        onDecrease: () {
                          cart.decreaseQuantity(item.product);
                        },

                        onDelete: () {
                          cart.removeItem(item.product);
                        },
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        'Rp ${cart.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<OrderProvider>().addOrder(
                        items: cart.items,
                        total: cart.total,
                      );

                      context.read<CartProvider>().clearCart();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checkout berhasil')),
                      );
                    },
                    child: Text('Checkout'),
                  ),
                ),
              ],
            ),
    );
  }
}
