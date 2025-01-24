
import 'package:dartz/dartz.dart';
import 'package:purchaso/core/error/failures.dart';
import 'package:purchaso/features/product/data/datasources/product_remote_datasource';
import 'package:purchaso/features/product/domain/entities/product.dart';
import 'package:purchaso/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);


  List<ProductEntity>? _cachedProducted=[];


  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {

      if(_cachedProducted!.isNotEmpty){
        return Right(_cachedProducted!);
      }
      final products = await remoteDataSource.fetchProductsFromApi();
      _cachedProducted=products;
      return Right(products);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  
 @override
  Future<Either<Failure, List<int>>> getFavouriteProductsId(String userId) async {
    try {
      final productIds = await remoteDataSource.getFavouriteProductsId(userId);
      return Right(productIds);
    } catch (e) {
      return Left(Failure('Failed to fetch favorite products'));
    }
  }
  
  @override
  Future<Either<Failure, void>> toggleFavorite(String userId, int productId, bool isFavorite) async {
      try {
      await remoteDataSource.toggleFavorite(userId, productId, isFavorite);
      return const Right(null);
    } catch (e) {
      return Left(Failure('Failed to toggle favorite'));
    }
  }

}