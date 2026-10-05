import 'package:alteon_app/utils/currency_formatter.dart';
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
    final order = context.watch<OrderProvider>();

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
                        isProcessing: cart.isProcessing(item.id),

                        onIncrease: () async {
                          final success = await cart.increaseQuantity(
                            item.product,
                          );

                          if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  cart.error ?? 'Tidak bisa menambah quantity',
                                ),
                              ),
                            );
                          }
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
                        'Rp ${formatRupiah(cart.total)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: order.isLoading
                          ? null
                          : () async {
                              final success = await context
                                  .read<OrderProvider>()
                                  .createOrder();

                              if (!context.mounted) return;

                              if (success) {
                                await context.read<CartProvider>().loadCart();
                                await context
                                    .read<OrderProvider>()
                                    .loadOrders();

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Checkout berhasil'),
                                  ),
                                );
                              } else {
                                final error = context
                                    .read<OrderProvider>()
                                    .error;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error ?? 'Checkout gagal'),
                                  ),
                                );
                              }
                            },
                      child: order.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Checkout'),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
