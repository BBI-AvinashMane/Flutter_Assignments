import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.favorite, size: 100, color: Colors.teal),
          SizedBox(height: 20),
          Text('Favourite Page', style: TextStyle(fontSize: 24, color: Colors.teal)),
        ],
      ),
    );
  }
}