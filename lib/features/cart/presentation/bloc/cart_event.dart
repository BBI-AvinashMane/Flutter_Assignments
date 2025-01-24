abstract class CartEvent {}

/// Fetch product details to populate map
class GetProductEventForCart extends CartEvent {}

/// Load cart items for a user
class GetCartEvent extends CartEvent {}

/// Add an item to the cart
class AddToCartEvent extends CartEvent {
  final int productId;
  final int quantity;

  AddToCartEvent(this.productId, this.quantity);
}

/// Remove an item from the cart
class RemoveFromCartEvent extends CartEvent {
  final int productId;
  final int quantity;

  RemoveFromCartEvent(this.productId, this.quantity);
}

