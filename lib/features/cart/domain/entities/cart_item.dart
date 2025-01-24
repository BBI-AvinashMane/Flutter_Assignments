import 'package:purchaso/features/product/domain/entities/product.dart';

class CartEntity {
  final int productId;
  final int quantity;
  final ProductEntity? product;

  CartEntity({
    required this.productId,
    required this.quantity,
    this.product,
  });

  CartEntity copyWith({
    int? productId,
    int? quantity,
    ProductEntity? product,
  }) {
    return CartEntity(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}