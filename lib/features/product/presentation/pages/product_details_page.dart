import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/product/data/models/product_model.dart';
import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';

// class ProductDetailsPage extends StatelessWidget {
//   final int productId;
//   const ProductDetailsPage({required this.productId, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product Details"),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Hero(
//               tag: product.id,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12.0),
//                 child: Image.network(
//                   product.image,
//                   height: 300,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               product.title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "\$${product.price.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.teal,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               product.description,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//             ),
//             const Spacer(),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Add to cart functionality
//               },
//               icon: const Icon(Icons.shopping_cart),
//               label: const Text("Add to Cart"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ProductDetailsPage extends StatelessWidget {
  final int productId;

  const ProductDetailsPage({required this.productId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = BlocProvider.of<ProductBloc>(context).getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(child: Text('Product not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price}',
              style: const TextStyle(fontSize: 20, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

