
import 'package:dartz/dartz.dart';
import 'package:purchaso/core/error/failures.dart';
import 'package:purchaso/features/product/domain/repositories/product_repository.dart';

class ToggleFavouriteUsecase {

  final ProductRepository productRepository;

  ToggleFavouriteUsecase(this.productRepository);

  Future<Either<Failure, void>> call(String userId,int productId,bool isFavorite) async {
    return await productRepository.toggleFavorite(userId, productId, isFavorite);
  }
}
