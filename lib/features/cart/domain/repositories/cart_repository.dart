import 'package:dartz/dartz.dart';
import 'package:purchaso/features/cart/domain/entities/cart_item.dart';


abstract class CartRepository {
  Future<Either<Exception, void>> addItemToCart(String userId, CartEntity cartItem);
  Future<Either<Exception, void>> removeItemFromCart(String userId, CartEntity cartItem);
  Future<Either<Exception, List<CartEntity>>> getCartItems(String userId);
}
