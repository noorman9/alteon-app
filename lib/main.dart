import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/main_navigation.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'repositories/product_repository.dart';
import 'services/product_service.dart';

import 'services/auth_service.dart';
import 'repositories/auth_repository.dart';
import 'providers/auth_provider.dart';
import 'services/auth_storage.dart';

import 'services/cart_service.dart';
import 'repositories/cart_repository.dart';


import 'repositories/order_repository.dart';
import 'services/order_service.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: AuthRepository(service: AuthService()),
            storage: AuthStorage(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            repository: ProductRepository(service: ProductService()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(
            repository: CartRepository(service: CartService()),
            storage: AuthStorage(),
          ),
        ),
        ChangeNotifierProvider(
  create: (_) => OrderProvider(
    repository: OrderRepository(
      service: OrderService(),
    ),
    storage: AuthStorage(),
  ),
),
      ],
      child: const AlteonApp(),
    ),
  );
}

class AlteonApp extends StatelessWidget {
  const AlteonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alteon APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  bool _cartLoaded = false;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AuthProvider>().checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.isCheckingAuth) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if(auth.isLoggedIn && !_cartLoaded){
          _cartLoaded = true;

          Future.microtask((){
            context.read<CartProvider>().loadCart();
          });
        }
        
        if(!auth.isLoggedIn){
          _cartLoaded = false;
        }

        return const MainNavigation();
      },
    );
  }
}
