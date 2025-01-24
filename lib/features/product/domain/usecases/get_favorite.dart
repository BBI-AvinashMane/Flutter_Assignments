
import 'package:dartz/dartz.dart';
import 'package:purchaso/core/error/failures.dart';
import 'package:purchaso/features/product/domain/repositories/product_repository.dart';

class GetFavouriteProductsIdUsecase {
  final ProductRepository productRepository;

  GetFavouriteProductsIdUsecase(this.productRepository);

  Future<Either<Failure, List<int>>> call(String userId) async {
    return await productRepository.getFavouriteProductsId(userId);
  }
}