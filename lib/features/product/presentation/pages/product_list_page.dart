
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:purchaso/features/product/data/models/product_model.dart';
// import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';
// import 'package:shimmer/shimmer.dart';

// class ProductPage extends StatefulWidget {
//   @override
//   State<ProductPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   final List<String> productImages = [
//     'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png',
//     'https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/1.png',
//     'https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/1.png',
//     'https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/1.png',
//     'https://cdn.dummyjson.com/products/images/beauty/Red%20Lipstick/1.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<ProductBloc>(context).add(GetProductEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: RichText(
//           text: const TextSpan(children: [
//             TextSpan(
//               text: "Product ",
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.teal,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             TextSpan(
//               text: "Catlog",
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ]),
//         ),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//           _buildCarouselSlider(),
//           const SizedBox(height: 20),
//           Expanded(
//             child: BlocBuilder<ProductBloc, ProductState>(
//               builder: (context, state) {
//                 print("in product page satet is ${state}");

//                 if (state is ProductLoading) {
//                   return _buildShimmerEffect();
//                 } else if (state is ProductLoaded) {
//                   return _buildProductGrid(state.products);
//                 } else if (state is ProductError) {
//                   return _buildError(state.message);
//                 }
//                 return Container();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCarouselSlider() {
//     return BlocBuilder<ProductBloc, ProductState>(
//       builder: (context, state) {
//         if (state is ProductLoading) {
//           return _buildShimmerCarousel();
//         } else if (state is ProductLoaded) {
//           return CarouselSlider(
//             options: CarouselOptions(
//               height: 220,
//               autoPlay: true,
//               enlargeCenterPage: true,
//               autoPlayInterval: const Duration(seconds: 3),
//               viewportFraction: 0.70,
//               aspectRatio: 20 / 10,
//               autoPlayCurve: Curves.easeInOut,
//             ),
//             items: productImages.map((imageUrl) {
//               return Builder(
//                 builder: (BuildContext context) {
//                   return AnimatedContainer(
//                     duration: const Duration(milliseconds: 500),
//                     curve: Curves.easeInOut,
//                     margin: const EdgeInsets.symmetric(horizontal: 5.0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.0),
//                       image: DecorationImage(
//                         image: NetworkImage(imageUrl),
//                         fit: BoxFit.cover,
//                       ),
//                       // boxShadow: const [
//                       //   BoxShadow(
//                       //     color: Colors.black26,
//                       //     blurRadius: 8,
//                       //     offset: Offset(0, 4),
//                       //   ),
//                       // ],
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           );
//         }
//         return Container();
//       },
//     );
//   }

//   Widget _buildShimmerCarousel() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         height: 220,
//         margin: const EdgeInsets.symmetric(horizontal: 5.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15.0),
//           color: Colors.grey[300],
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: GridView.builder(
//         padding: const EdgeInsets.all(8.0),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12.0,
//           mainAxisSpacing: 12.0,
//           childAspectRatio: 0.75,
//         ),
//         itemCount: 6,
//         itemBuilder: (context, index) {
//           return _buildShimmerCard();
//         },
//       ),
//     );
//   }

//   Widget _buildShimmerCard() {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 8,
//       shadowColor: Colors.tealAccent,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 150,
//                 color: Colors.grey[300],
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 100,
//                   height: 16,
//                   color: Colors.grey[300],
//                 ),
//                 const SizedBox(height: 4),
//                 Container(
//                   width: 60,
//                   height: 16,
//                   color: Colors.grey[300],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildError(String message) {
//     return Center(
//       child: Text(
//         message,
//         style: const TextStyle(color: Colors.red, fontSize: 18),
//       ),
//     );
//   }

//   Widget _buildProductGrid(List<ProductModel> products) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(8.0),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12.0,
//         mainAxisSpacing: 12.0,
//         childAspectRatio: 0.75,
//       ),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         return _buildProductCard(products[index]);
//       },
//     );
//   }

//   Widget _buildProductCard(ProductModel product) {
//     return GestureDetector(
//       onTap: () {},
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         elevation: 8,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(15.0),
//                     topRight: Radius.circular(15.0),
//                   ),
//                   child: Image.network(
//                     product.image,
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: IconButton(
//                       icon:
//                           const Icon(Icons.favorite_border, color: Colors.red),
//                       onPressed: () {},
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '\$${product.price.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   _buildRatingStars(product.rate),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRatingStars(double rating) {
//     int fullStars = rating.floor();
//     double fraction = rating - fullStars;
//     return Row(
//       children: List.generate(5, (index) {
//         if (index < fullStars) {
//           return const Icon(Icons.star,
//               color: Color.fromARGB(255, 255, 230, 0), size: 20);
//         } else if (index == fullStars && fraction > 0) {
//           return const Icon(Icons.star_half,
//               color: Color.fromARGB(255, 255, 230, 0), size: 20);
//         } else {
//           return const Icon(Icons.star_border,
//               color: Color.fromARGB(255, 255, 230, 0), size: 20);
//         }
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:purchaso/features/product/data/models/product_model.dart';
import 'package:purchaso/features/product/domain/entities/product.dart';
import 'package:purchaso/features/product/presentation/bloc/product_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'product_details_page.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(GetProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(children: [
            TextSpan(
              text: "Shop ",
              style: TextStyle(
                fontSize: 24,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: "Products",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildCarouselSlider(),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return _buildShimmerEffect();
                } else if (state is ProductLoaded) {
                  return _buildProductGrid(state.products);
                } else if (state is ProductError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                }
                return const Center(child: Text("No Products Available"));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    final List<String> carouselImages = [
      'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png',
      'https://cdn.dummyjson.com/products/images/beauty/Red%20Nail%20Polish/1.png',
      'https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/1.png',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: carouselImages.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.75,
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

  Widget _buildProductGrid(List<ProductEntity> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ProductBloc>(context)
            .add(GetProductDetailsEvent(product.id));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(productId: product.id,),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Image.network(
                product.image,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
