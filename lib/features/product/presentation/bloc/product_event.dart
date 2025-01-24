part of 'product_bloc.dart';


abstract class ProductEvent  {}

class GetProductEvent extends ProductEvent {}
class GetProductDetailsEvent extends ProductEvent {
  final int productId;

  GetProductDetailsEvent(this.productId);
}

class ToggleFavoriteEvent extends ProductEvent {
  final int productId;

  ToggleFavoriteEvent(this.productId);
}

class LoadFavoriteProductsIdEvent extends ProductEvent {}

class ClearProductListEvent extends ProductEvent{}