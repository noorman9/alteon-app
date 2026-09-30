import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/main_navigation.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}