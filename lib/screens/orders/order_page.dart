import 'package:alteon_app/utils/currency_formatter.dart';
import 'package:alteon_app/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';
import 'order_detail_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan')),

      body: _buildBody(orderProvider),
    );
  }

  Widget _buildBody(OrderProvider orderProvider) {
    if (orderProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64),

              const SizedBox(height: 16),

              const Text(
                'Gagal memuat pesanan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(orderProvider.error!, textAlign: TextAlign.center),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: orderProvider.isLoading
                    ? null
                    : () {
                        orderProvider.loadOrders();
                      },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (orderProvider.error != null) {
      return Center(
        child: Text(orderProvider.error!, textAlign: TextAlign.center),
      );
    }

    if (orderProvider.orders.isEmpty) {
      return const Center(
        child: Text('Belum ada pesanan', style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      itemCount: orderProvider.orders.length,
      itemBuilder: (context, index) {
        final order = orderProvider.orders[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OrderDetailPage(order: order);
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesanan #${order.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text('Jumlah barang: ${order.items.length}'),

                  const SizedBox(height: 4),

                  Text('Total: ${formatRupiah(order.total)}'),

                  const SizedBox(height: 4),

                  Text('Status: ${order.status}'),

                  const SizedBox(height: 4),

                  Text('Tanggal: ${formatOrderDate(order.createdAt)}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
