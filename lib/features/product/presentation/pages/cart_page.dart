import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_cart, size: 100, color: Colors.teal),
          SizedBox(height: 20),
          Text('Cart Page', style: TextStyle(fontSize: 24, color: Colors.teal)),
        ],
      ),
    );
  }
}