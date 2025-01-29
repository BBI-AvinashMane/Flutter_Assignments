import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:purchaso/features/cart/domain/usecases/get_cart_items.dart';
import 'package:purchaso/features/cart/domain/usecases/add_to_cart.dart';
import 'package:purchaso/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:purchaso/features/product/data/models/product_model.dart';
import 'package:purchaso/features/product/domain/usecases/get_products.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchaso/features/cart/domain/entities/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCart addItemToCart;
  final RemoveFromCart removeItemFromCart;
  final GetCartItems getCartItems;
  final GetProductsUsecase getProductsUsecase;
  // final CartRemoteDataSource remoteDataSource;

  Map<int, ProductModel> _productMap = {};

  List<CartEntity> _cartItems=[];

  CartBloc({
    required this.addItemToCart,
    required this.removeItemFromCart,
    required this.getCartItems,
    required this.getProductsUsecase,
    // required this.remoteDataSource,
  }) : super(CartInitial()) {
    on<GetCartEvent>(_onGetCartItems);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<GetProductEventForCart>(_onGetProducts);
    // on<ClearCartEvent>(_onClearCart);
  }

  // Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   try {
  //     if (_productMap.containsKey(event.productId)) {
  //       // Create or update the cart item
  //       final cartItem = CartEntity(productId: event.productId, quantity: event.quantity);
  //       await addItemToCart.call(userId, cartItem);
  //       add(GetCartEvent()); // Refresh the cart
  //     } else {
  //       emit(CartError('Product not found.'));
  //     }
  //   } catch (e) {
  //     emit(CartError('Failed to add item to cart: $e'));
  //   }
  // }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  try {
    if (_productMap.containsKey(event.productId)) {
      final cartItem = CartEntity(productId: event.productId, quantity: event.quantity);
      await addItemToCart.call(userId, cartItem);
      add(GetCartEvent()); // Refresh the cart
    } else {
      emit(CartError('Product not found.'));
    }
  } catch (e) {
    emit(CartError('Failed to add item to cart: $e'));
  }
}

  // Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
  //   final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   try {
  //     final cartItem = CartEntity(productId: event.productId, quantity: event.quantity);
  //     await removeItemFromCart(userId, cartItem);
  //     add(GetCartEvent()); // Refresh the cart
  //   } catch (e) {
  //     emit(CartError('Failed to remove item from cart: $e'));
  //   }
  // }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  try {
    final cartItem = CartEntity(productId: event.productId, quantity: event.quantity);
    await removeItemFromCart(userId, cartItem);
    add(GetCartEvent()); // Refresh the cart
  } catch (e) {
    emit(CartError('Failed to remove item from cart: $e'));
  }
}

  // Future<void> _onGetCartItems(GetCartEvent event, Emitter<CartState> emit) async {
  //   // emit(CartLoading());
  //   final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   try {
  //     final response = await getCartItems.call(userId);
  //     response.fold(
  //       (failure) => emit(CartError(failure.toString())),
  //       (cartItems) {
  //         final populatedCartItems = cartItems.map((cartItem) {
  //           final product = _productMap[cartItem.productId];
  //           return cartItem.copyWith(product: product);
  //         }).toList();
  //         _cartItems = populatedCartItems;
  //         emit(CartLoaded(populatedCartItems));
  //       },
  //     );
  //   } catch (e) {
  //     emit(CartError('Failed to fetch cart items: $e'));
  //   }
  // }
  Future<void> _onGetCartItems(GetCartEvent event, Emitter<CartState> emit) async {
  emit(CartLoading());

  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  try {
    final response = await getCartItems.call(userId);

    response.fold(
      (failure) => emit(CartError(failure.toString())),
      (cartItems) {
        if (cartItems.isEmpty) {
          emit(CartEmpty()); // New state when cart is empty
        } else {
          final populatedCartItems = cartItems.map((cartItem) {
            final product = _productMap[cartItem.productId];
            return cartItem.copyWith(product: product);
          }).toList();
          _cartItems = populatedCartItems;
          emit(CartLoaded(populatedCartItems));
        }
      },
    );
  } catch (e) {
    emit(CartError('Failed to fetch cart items: $e'));
  }
}


  Future<void> _onGetProducts(GetProductEventForCart event, Emitter<CartState> emit) async {
    final response = await getProductsUsecase.call();
    response.fold(
      (failure) => emit(CartError(failure.message)),
      (products) {
        _productMap = {for (var product in products) product.id: product as ProductModel};
      },
    );
  }

//   Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
//   final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//   try {
//     await remoteDataSource.clearCart(userId); //  Clear cart in Firebase
//     _cartItems = [];
//     emit(CartEmpty()); // Emit CartEmpty state
//   } catch (e) {
//     emit(CartError('Failed to clear cart: $e'));
//   }
// }
}
