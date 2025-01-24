
import 'package:dartz/dartz.dart';
import 'package:purchaso/core/error/failures.dart';
import 'package:purchaso/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure,void>> toggleFavorite(String userId,int productId,bool isFavorite);
  Future<Either<Failure,List<int>>> getFavouriteProductsId(String userId);
}