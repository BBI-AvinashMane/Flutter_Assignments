

import 'package:purchaso/features/cart/domain/entities/cart_item.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {
  final String userId;

  LoadCartEvent(this.userId);
}

class AddItemToCartEvent extends CartEvent {
  final String userId;
  final CartEntity cartItem;

  AddItemToCartEvent(this.userId, this.cartItem);
}

class RemoveItemFromCartEvent extends CartEvent {
  final String userId;
  final CartEntity cartItem;

  RemoveItemFromCartEvent(this.userId, this.cartItem);
}
