import 'package:dartz/dartz.dart';
import 'package:purchaso/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:purchaso/features/cart/domain/entities/cart_item.dart';
import 'package:purchaso/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, void>> addItemToCart(String userId, CartEntity cartItem) async {
    try {
      await remoteDataSource.addItemToCart(userId, cartItem);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> removeItemFromCart(String userId, CartEntity cartItem) async {
    try {
      await remoteDataSource.removeItemFromCart(userId, cartItem);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<CartEntity>>> getCartItems(String userId) async {
    try {
      final cartItems = await remoteDataSource.getCartItems(userId);
      return Right(cartItems);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
