import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/cart/domain/usecases/get_cart_items.dart';
import 'package:purchaso/features/cart/domain/usecases/add_to_cart.dart';
import 'package:purchaso/features/cart/domain/usecases/remove_from_cart.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItemsUsecase;
  final AddToCart addToCartUsecase;
  final RemoveFromCart removeFromCartUsecase;

  CartBloc({
    required this.getCartItemsUsecase,
    required this.addToCartUsecase,
    required this.removeFromCartUsecase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddItemToCartEvent>(_onAddItemToCart);
    on<RemoveItemFromCartEvent>(_onRemoveItemFromCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final result = await getCartItemsUsecase(event.userId);
    result.fold(
      (error) => emit(CartError(error.toString())),
      (cartItems) => emit(CartLoaded(cartItems)),
    );
  }

  Future<void> _onAddItemToCart(AddItemToCartEvent event, Emitter<CartState> emit) async {
    await addToCartUsecase(event.userId, event.cartItem);
    add(LoadCartEvent(event.userId));
  }

  Future<void> _onRemoveItemFromCart(RemoveItemFromCartEvent event, Emitter<CartState> emit) async {
    await removeFromCartUsecase(event.userId, event.cartItem);
    add(LoadCartEvent(event.userId));
  }
}
