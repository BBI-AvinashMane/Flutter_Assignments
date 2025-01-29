import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purchaso/features/cart/domain/entities/cart_item.dart';


abstract class CartRemoteDataSource {
  Future<void> addItemToCart(String userId, CartEntity cartItem);
  Future<void> removeItemFromCart(String userId, CartEntity cartItem);
  Future<List<CartEntity>> getCartItems(String userId);
  // Future<void> clearCart(String userId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore _firestore;

  CartRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> addItemToCart(String userId, CartEntity cartItem) async {
    final productId = cartItem.productId.toString();
    final productRef = _firestore.collection('carts').doc(userId).collection('products').doc(productId);
    final productSnapshot = await productRef.get();

    if (productSnapshot.exists) {
      await productRef.update({'quantity': cartItem.quantity});
    } else {
      await productRef.set({
        'productId': cartItem.productId,
        'quantity': cartItem.quantity,
      });
    }
  }

  @override
  Future<void> removeItemFromCart(String userId, CartEntity cartItem) async {
    final productId = cartItem.productId.toString();
    final productRef = _firestore.collection('carts').doc(userId).collection('products').doc(productId);

    final productSnapshot = await productRef.get();

    if (productSnapshot.exists) {
      final currentQuantity = productSnapshot.data()?['quantity'] as int;
      if (currentQuantity > cartItem.quantity) {
        await productRef.update({'quantity': FieldValue.increment(-cartItem.quantity)});
      } else {
        await productRef.delete();
      }
    }
  }

  @override
  Future<List<CartEntity>> getCartItems(String userId) async {
    final productsRef = _firestore.collection('carts').doc(userId).collection('products');
    final productsSnapshot = await productsRef.get();

    if (productsSnapshot.docs.isEmpty) {
      return [];
    }

    return productsSnapshot.docs.map((doc) {
      final data = doc.data();
      return CartEntity(
        productId: data['productId'] as int,
        quantity: data['quantity'] as int,
      );
    }).toList();
  }

//   Future<void> clearCart(String userId) async {
//   try {
//     final cartRef = _firestore.collection('carts').doc(userId);
//     final productsRef = cartRef.collection('products');

//     final batch = _firestore.batch();
//     final cartItems = await productsRef.get();

//     for (var doc in cartItems.docs) {
//       batch.delete(doc.reference);
//     }

//     await batch.commit();
//   } catch (e) {
//     throw Exception('Failed to clear cart: $e');
//   }
// }
}
