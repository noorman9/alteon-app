import 'package:flutter/material.dart';

import '../../widgets/product_card.dart';
import 'product_detail_page.dart';

import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../auth/login_page.dart';
import '../../providers/auth_provider.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              if (auth.isLoggedIn) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'profile') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    }

                    if (value == 'logout') {
                      auth.logout();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem(value: 'logout', child: Text('Logout')),
                  ],
                  child: const Icon(Icons.account_circle),
                );
              }

              return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 64),

                    const SizedBox(height: 16),

                    const Text(
                      'Gagal memuat barang',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(productProvider.error!, textAlign: TextAlign.center),

                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: productProvider.isLoading
                          ? null
                          : () {
                              productProvider.fetchProducts();
                            },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];

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
