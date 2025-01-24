class ProductEntity {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final double rating;
  bool isFavorite;

   ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.rating,
     this.isFavorite = false,
  });
}
