import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:purchaso/features/product/domain/entities/product.dart';
import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'product_details_page.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    BlocProvider.of<ProductBloc>(context).add(GetProductEvent());
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose ScrollController to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Purchaso',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement Search Functionality
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Carousel as a SliverAppBar
          _buildCarouselSection(),

          // Divider Section
          SliverToBoxAdapter(
            child: _buildDividerSection(),
          ),

          // Product List Section
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return SliverToBoxAdapter(
                  child: _buildShimmerEffect(),
                );
              } else if (state is ProductLoaded) {
                return _buildProductGridSliver(state.products);
              } else if (state is ProductError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "No Products Available",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Carousel Section as SliverAppBar
  Widget _buildCarouselSection() {
    final List<String> carouselImages = [
      "https://cdn.dummyjson.com/products/images/groceries/Honey%20Jar/1.png",
      "https://cdn.dummyjson.com/products/images/furniture/Annibale%20Colombo%20Bed/1.png",
      "https://cdn.dummyjson.com/products/images/furniture/Wooden%20Bathroom%20Sink%20With%20Mirror/2.png",
    ];

    return SliverAppBar(
      expandedHeight: 320,
      pinned: false,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 13, 6, 113),
                Color.fromARGB(255, 40, 27, 226),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(500),
              bottomRight: Radius.circular(500),
            ),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 300,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.7,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: carouselImages.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Divider Section Method
  Widget _buildDividerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey.shade400,
              thickness: 1.5,
              endIndent: 8.0,
            ),
          ),
          Text(
            "Explore Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey.shade400,
              thickness: 1.5,
              indent: 8.0,
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer Effect for Loading
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.8,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
          );
        },
      ),
    );
  }

  // Function to dynamically generate stars based on the rating
  List<Widget> _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    }
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }
    return stars;
  }

  // Product Grid as SliverGrid
  Widget _buildProductGridSliver(List<ProductEntity> products) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.6,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildProductCard(products[index]);
        },
        childCount: products.length,
      ),
    );
  }

  // Product Card
  Widget _buildProductCard(ProductEntity product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Hero(
                      tag: 'product-${product.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1, // Maintains a square aspect ratio
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image,
                                    size: 50, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Product Information
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Title
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              ..._buildStarRating(
                                  product.rating), // Dynamically build stars
                              const SizedBox(
                                  width:
                                      6), // Spacing between stars and rating text
                              Text(
                                "(${product.rating.toStringAsFixed(1)})",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // Toggle favorite state
                      BlocProvider.of<ProductBloc>(context).add(
                        ToggleFavoriteEvent(product.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
