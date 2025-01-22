
import 'package:dartz/dartz.dart';
import 'package:purchaso/core/error/failures.dart';
import 'package:purchaso/features/product/domain/entities/product.dart';
import 'package:purchaso/features/product/domain/repositories/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository productRepository;

  GetProductsUsecase(this.productRepository);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await productRepository.getProducts();
  }
}