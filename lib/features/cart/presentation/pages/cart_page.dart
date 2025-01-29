import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:purchaso/features/cart/presentation/bloc/cart_event.dart';
import 'package:purchaso/features/cart/presentation/bloc/cart_state.dart';
import 'package:purchaso/features/cart/presentation/widgets/show_dialog.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    BlocProvider.of<CartBloc>(context).add(GetCartEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 1,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            final cartItems = state.cartItems;
            final shipping = 6.0; // Fixed shipping cost
            final subtotal = cartItems.fold<double>(
              0.0,
              (sum, item) => sum + (item.product?.price ?? 0) * item.quantity,
            );
            final total = subtotal + shipping;

            return Column(
              children: [
                // Address Section
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.home, color: Colors.black),
                  ),
                  title: const Text(
                    "Kyre Jenneth",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    "14400 Las Vegas Corner\nLas Vegas SA 21233",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                        // BottomNavigationPage(this.email);

                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const Divider(),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your promo code",
                      prefixIcon: const Icon(Icons.card_giftcard),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Price Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text("\$${subtotal.toStringAsFixed(2)}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Shipping"),
                          Text("\$${shipping.toStringAsFixed(2)}"),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total amount",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                       BlocProvider.of<CartBloc>(context).add(ClearCartEvent());
                      showPaymentSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item.product?.image ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item.product?.title ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '\$${item.product?.price.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.grey),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  BlocProvider.of<CartBloc>(context).add(
                                      AddToCartEvent(
                                          item.productId, item.quantity - 1));
                                } else {
                                  BlocProvider.of<CartBloc>(context).add(
                                      RemoveFromCartEvent(
                                          item.productId, item.quantity));
                                }
                              },
                            ),
                            Text(
                              item.quantity.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.blue),
                              onPressed: () {
                                BlocProvider.of<CartBloc>(context).add(
                                    AddToCartEvent(
                                        item.productId, item.quantity + 1));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Your cart is empty."));
        },
      ),
    );
  }
}
