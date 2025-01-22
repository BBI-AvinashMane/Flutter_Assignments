part of 'product_bloc.dart';


abstract class ProductEvent  {}

class GetProductEvent extends ProductEvent {}
class GetProductDetailsEvent extends ProductEvent {
  final int productId;

  GetProductDetailsEvent(this.productId);
}