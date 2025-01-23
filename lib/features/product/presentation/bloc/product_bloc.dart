import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/product/data/models/product_model.dart';
import 'package:purchaso/features/product/domain/entities/product.dart';
import 'package:purchaso/features/product/domain/usecases/get_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;

  // Updated to store entities
  List<ProductEntity> _productEntities = [];

  ProductBloc({
    required this.getProductsUsecase,
  }) : super(ProductInitial()) {
    on<GetProductEvent>(_getProductEvent);
    on<GetProductDetailsEvent>(_getProductDetailsEvent);
  }

  Future<void> _getProductEvent(
    GetProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    if (_productEntities.isNotEmpty) {
      emit(ProductLoaded(_productEntities));
      return;
    }

    final response = await getProductsUsecase.call();

    response.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        _productEntities = products;
        emit(ProductLoaded(products));
      },
    );
  }

  void _getProductDetailsEvent(
    GetProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) {
    try {
      final product =
          _productEntities.firstWhere((p) => p.id == event.productId);
      emit(ProductLoaded([product]));
    } catch (e) {
      emit(ProductError('Product not found'));
    }
  }

  ProductEntity? getProductById(int productId) {
    try {
      return _productEntities.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null; // Return null if the product is not found
    }
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    debugPrint(
        'State Transition: ${transition.currentState} -> ${transition.nextState}');
  }
}

