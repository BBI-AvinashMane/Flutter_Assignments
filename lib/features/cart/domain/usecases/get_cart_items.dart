import 'package:dartz/dartz.dart';
import 'package:purchaso/features/cart/domain/entities/cart_item.dart';
import 'package:purchaso/features/cart/domain/repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<Either<Exception, List<CartEntity>>> call(String userId) async {
    return await repository.getCartItems(userId);
  }
}
