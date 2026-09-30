import 'package:flutter/material.dart';

import '../screens/home/home_page.dart';
import '../screens/cart/cart_page.dart';
import '../screens/orders/order_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    OrderPage(),
  ];

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _changePage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Barang',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
        ],
      ),
    );
  }
}