import 'package:purchaso/features/cart/domain/entities/cart_item.dart';

abstract class CartState {}

/// Initial state
class CartInitial extends CartState {}

/// Loading state
class CartLoading extends CartState {}

/// Cart loaded successfully
class CartLoaded extends CartState {
  final List<CartEntity> cartItems;

  CartLoaded(this.cartItems);
}

/// Cart operation failed
class CartError extends CartState {
  final String message;

  CartError(this.message);
}
class CartEmpty extends CartState{
  
}