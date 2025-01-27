// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:purchaso/features/cart/presentation/pages/cart_page.dart';
// import 'package:purchaso/features/product/presentation/pages/product_list_page.dart';
// import 'package:purchaso/features/profile/presentation/bloc/profile_bloc.dart';
// import 'package:purchaso/features/profile/presentation/bloc/profile_state.dart';
// import 'package:purchaso/features/profile/presentation/pages/profile_details_page.dart';
// import 'package:purchaso/features/product/presentation/pages/wishlist_page.dart';

// class BottomNavigationPage extends StatefulWidget {
//   final String email;

//   const BottomNavigationPage(this.email, {Key? key}) : super(key: key);

//   @override
//   _BottomNavigationPageState createState() => _BottomNavigationPageState();
// }

// class _BottomNavigationPageState extends State<BottomNavigationPage> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       ProductPage(),
//       WishlistPage(),
//       CartPage(),
//       BlocBuilder<ProfileBloc, ProfileState>(
//         builder: (context, state) {
//           if (state is ProfileCompletionChecked || state is ProfileLoaded) {
//             return ProfileDetailsPage(profile: (state as dynamic).profile);
//           } else if (state is ProfileLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             return const Center(child: Text('Profile not available'));
//           }
//         },
//       ),
//     ];

//     return Scaffold(
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: pages[_selectedIndex],
//       ),
//           extendBody: true, 
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {

//                 final iconSize = constraints.maxWidth * 0.07; // Responsive icon size

//                 return ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color.fromARGB(255, 50, 1, 55), Colors.blueAccent],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                     child: BottomNavigationBar(
//                       backgroundColor: Colors.transparent,
//                       currentIndex: _selectedIndex,
//                       onTap: _onItemTapped,
//                       selectedItemColor: Colors.white,
//                       unselectedItemColor: Colors.grey,
//                       showUnselectedLabels: false,
//                       type: BottomNavigationBarType.fixed,
//                       items: [
//                         BottomNavigationBarItem(
//                           icon: Icon(Icons.home_outlined, size: iconSize),
//                           activeIcon: Icon(Icons.home, size: iconSize),
//                           label: 'Home',
//                         ),
//                         BottomNavigationBarItem(
//                           icon: Icon(Icons.favorite_border, size: iconSize),
//                           activeIcon: Icon(Icons.favorite, size: iconSize),
//                           label: 'Wishlist',
//                         ),
//                         BottomNavigationBarItem(
//                           icon: Icon(Icons.shopping_cart_outlined, size: iconSize),
//                           activeIcon: Icon(Icons.shopping_cart, size: iconSize),
//                           label: 'Cart',
//                         ),
//                         BottomNavigationBarItem(
//                           icon: Icon(Icons.person_outline, size: iconSize),
//                           activeIcon: Icon(Icons.person, size: iconSize),
//                           label: 'Profile',
//                         ),
//                       ],
//                       selectedLabelStyle: TextStyle(
//                         fontSize: constraints.maxWidth * 0.035,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Transparent space below the navigation bar
//           Container(
//             height: 20, // Transparent space height
//             color:  Colors.transparent,          ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/cart/presentation/pages/cart_page.dart';
import 'package:purchaso/features/product/presentation/pages/product_list_page.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_state.dart';
import 'package:purchaso/features/profile/presentation/pages/profile_details_page.dart';
import 'package:purchaso/features/product/presentation/pages/wishlist_page.dart';

class BottomNavigationPage extends StatefulWidget {
  final String email;
  final ValueNotifier<int> selectedIndexNotifier;

  const BottomNavigationPage(this.selectedIndexNotifier,this.email, {Key? key}) : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedIndex= widget.selectedIndexNotifier.value;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
     final List<Widget> pages = [
      ProductPage(),
      WishlistPage(widget.selectedIndexNotifier),
      CartPage(),
      BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileCompletionChecked || state is ProfileLoaded) {
            return ProfileDetailsPage(profile: (state as dynamic).profile);
          } else if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Profile not available'));
          }
        },
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex],
      ),
          extendBody: true, 
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {

                final iconSize = constraints.maxWidth * 0.07; // Responsive icon size

                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(255, 50, 1, 55), Colors.blueAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: BottomNavigationBar(
                      backgroundColor: Colors.transparent,
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.grey,
                      showUnselectedLabels: false,
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined, size: iconSize),
                          activeIcon: Icon(Icons.home, size: iconSize),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.favorite_border, size: iconSize),
                          activeIcon: Icon(Icons.favorite, size: iconSize),
                          label: 'Wishlist',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart_outlined, size: iconSize),
                          activeIcon: Icon(Icons.shopping_cart, size: iconSize),
                          label: 'Cart',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_outline, size: iconSize),
                          activeIcon: Icon(Icons.person, size: iconSize),
                          label: 'Profile',
                        ),
                      ],
                      selectedLabelStyle: TextStyle(
                        fontSize: constraints.maxWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Transparent space below the navigation bar
          Container(
            height: 20, // Transparent space height
            color:  Colors.transparent,          ),
        ],
      ),
    );
  }
}