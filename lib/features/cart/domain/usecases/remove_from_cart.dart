import 'package:dartz/dartz.dart';
import 'package:purchaso/features/cart/domain/entities/cart_item.dart';
import 'package:purchaso/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<Either<Exception, void>> call(String userId, CartEntity cartItem) async {
    return await repository.removeItemFromCart(userId, cartItem);
  }
}
