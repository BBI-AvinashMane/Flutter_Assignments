

import 'package:purchaso/features/product/domain/entities/product.dart';


class ProductModel extends ProductEntity {
  const ProductModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String image,
    required double rating,
  }) : super(
          id: id,
          title: title,
          price: price,
          description: description,
          image: image,
          rating: rating,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      image: json['thumbnail'],
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'rating': rating,
    };
  }
}
