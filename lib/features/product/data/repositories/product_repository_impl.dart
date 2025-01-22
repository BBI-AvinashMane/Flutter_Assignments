
import 'package:dartz/dartz.dart';
import 'package:purchaso/core/error/failures.dart';
import 'package:purchaso/features/product/data/datasources/product_remote_datasource';
import 'package:purchaso/features/product/domain/entities/product.dart';
import 'package:purchaso/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);


  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await remoteDataSource.fetchProductsFromApi();
      return Right(products);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}