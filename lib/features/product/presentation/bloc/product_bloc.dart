import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/product/domain/entities/product.dart';
import 'package:purchaso/features/product/domain/usecases/get_favorite.dart';
import 'package:purchaso/features/product/domain/usecases/get_products.dart';
import 'package:purchaso/features/product/domain/usecases/toggle_favorite.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  final GetFavouriteProductsIdUsecase getFavouriteProductsIdUsecase;
  final ToggleFavouriteUsecase toggleFavouriteUsecase;

  // Updated to store entities
  List<ProductEntity> _productEntities = [];

  ProductBloc({
    required this.getProductsUsecase,
    required this.getFavouriteProductsIdUsecase,
    required this.toggleFavouriteUsecase,
  }) : super(ProductInitial()) {
    on<GetProductEvent>(_getProductEvent);
    on<GetProductDetailsEvent>(_getProductDetailsEvent);
    on<ToggleFavoriteEvent>(_toggleFavoriteEvent);
    on<LoadFavoriteProductsIdEvent>(_loadFavouriteProductIdEvent);
    on<ClearProductListEvent>(_clearProductList);
    
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
  
Future<void> _loadFavouriteProductIdEvent(
      LoadFavoriteProductsIdEvent event, Emitter<ProductState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final favouriteIdsResponse =
        await getFavouriteProductsIdUsecase.call(userId);

    favouriteIdsResponse.fold((failure) {
      emit(ProductLoaded(_productEntities));
    }, (favoriteIds) {
      for (var product in _productEntities) {
        product.isFavorite = favoriteIds.contains(product.id);
      }

      emit(ProductLoaded(_productEntities));
    });
  }

  Future<void> _toggleFavoriteEvent(
      ToggleFavoriteEvent event, Emitter<ProductState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final product = _productEntities.firstWhere((p) => p.id == event.productId);

    final newIsFavorite = !product.isFavorite;

    final result = await toggleFavouriteUsecase.call(
        userId, event.productId, newIsFavorite);

    result.fold(
      (failure) {
        emit(ProductError(failure.message));
      },
      (_) {
        product.isFavorite = newIsFavorite;
        emit(ProductLoaded(_productEntities));
      },
    );
  }

  Future<void> _clearProductList(
      ClearProductListEvent event, Emitter<ProductState> emit) async {
    _productEntities = [];
    emit(ProductInitial());
  }

  
  // @override
  // void onTransition(Transition<ProductEvent, ProductState> transition) {
  //   super.onTransition(transition);
  //   debugPrint(
  //       'State Transition: ${transition.currentState} -> ${transition.nextState}');
  // }

  
}

