import 'package:dartz/dartz.dart';
import 'package:purchaso/features/cart/domain/entities/cart_item.dart';
import 'package:purchaso/features/cart/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<Either<Exception, void>> call(String userId, CartEntity cartItem) async {
    return await repository.addItemToCart(userId, cartItem);
  }
}
