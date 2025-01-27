// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';

// class WishlistPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Wishlist',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       body: _buildWishlist(context),
//     );
//   }

//   Widget _buildWishlist(BuildContext context) {
//     return BlocBuilder<ProductBloc, ProductState>(
//       builder: (context, state) {
//         if (state is ProductLoaded) {
//           final favoriteProducts = state.products
//               .where((product) => product.isFavorite)
//               .toList();

//           if (favoriteProducts.isEmpty) {
//             return const Center(
//               child: Text(
//                 "Your Wishlist is empty!",
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: favoriteProducts.length,
//             itemBuilder: (context, index) {
//               final product = favoriteProducts[index];
//               return ListTile(
//                 leading: Image.network(
//                   product.image,
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                 ),
//                 title: Text(
//                   product.title,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.favorite, color: Colors.red),
//                   onPressed: () {
//                     BlocProvider.of<ProductBloc>(context).add(
//                       ToggleFavoriteEvent(product.id),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         } else if (state is ProductLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           return const Center(child: Text("Failed to load Wishlist."));
//         }
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart'; // Add this for animations (e.g., empty state)
import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';
import 'package:purchaso/features/product/presentation/pages/bottom_nav.dart';

class WishlistPage extends StatefulWidget {
  final ValueNotifier<int> selectedIndexNotifier;

  const WishlistPage(this.selectedIndexNotifier, {Key? key}) : super(key: key);
  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body:  
      Container(
        decoration: const BoxDecoration(
         
        ),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoaded) {
              final favoriteProducts = state.products
                  .where((product) => product.isFavorite)
                  .toList();
              products = favoriteProducts;

              if (favoriteProducts.isEmpty) {
                return _buildEmptyWishlist();
              }

              return AnimatedList(
                key: _listKey,
                initialItemCount: favoriteProducts.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemBuilder: (context, index, animation) {
                  final product = favoriteProducts[index];
                  return _buildWishlistCard(context, product, index, animation);
                },
              );
            } else if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                child: Text(
                  "Failed to load Wishlist.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Build Wishlist Card
  Widget _buildWishlistCard(BuildContext context, dynamic product, int index,
      Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            product.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              _removeFromWishlist(context, product, index);
            },
          ),
        ),
      ),
    );
  }

  // Remove Product with Animation
  void _removeFromWishlist(BuildContext context, dynamic product, int index) {
    final removedProduct = products[index];

    // Remove the product from the UI list
    setState(() {
      products.removeAt(index);
    });

    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildWishlistCard(context, removedProduct, index, animation),
      duration: const Duration(milliseconds: 500),
    );

    // Trigger Bloc event to update product state
    BlocProvider.of<ProductBloc>(context).add(ToggleFavoriteEvent(product.id));

    // Show SnackBar with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product.title} removed from wishlist',
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.yellow,
          onPressed: () {
            setState(() {
              products.insert(index, removedProduct);
            });
            _listKey.currentState?.insertItem(index);
            BlocProvider.of<ProductBloc>(context)
                .add(ToggleFavoriteEvent(product.id));
          },
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  // Empty Wishlist UI
  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty_box.json', // Add your Lottie animation file
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Wishlist is empty!",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigate to product list page
             widget.selectedIndexNotifier.value = 0;
              // Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 12, 59, 140),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Add Products",
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
