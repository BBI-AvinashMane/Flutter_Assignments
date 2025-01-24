import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/cart/presentation/pages/cart_page.dart';
import 'package:purchaso/features/product/presentation/pages/product_list_page.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_event.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_state.dart';
import 'package:purchaso/features/profile/presentation/pages/profile_details_page.dart';
import 'package:purchaso/features/profile/presentation/pages/profile_page.dart';
import 'package:purchaso/features/product/presentation/pages/wishlist_page.dart';

class BottomNavigationPage extends StatefulWidget {
  final String email;

  const BottomNavigationPage(this.email, {Key? key}) : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      ProductPage(),
      WishlistPage(),
      CartPage(),
     BlocBuilder<ProfileBloc, ProfileState>(
    builder: (context, state) {
      print("bottom nav");
      print(state);
      if (state is ProfileCompletionChecked ) {
        print("profile should be shown1");
        return ProfileDetailsPage(profile: state.profile);
      }
      else if(state is ProfileLoaded) 
      {
        return ProfileDetailsPage(profile: state.profile);
      }
      else if (state is ProfileLoading) {
        print("profile should be shown2");
        return const Center(child: CircularProgressIndicator());
      } else {
        print("elselaoding....");
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
      extendBody: true, // Extends body behind the navigation bar
      bottomNavigationBar: Column(
       mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 7, 1, 55), Colors.blueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: SizedBox(
                height:95,
                
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent, // Set transparent to avoid white
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 28),
                    activeIcon: Icon(Icons.home, size: 28),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border, size: 28),
                    activeIcon: Icon(Icons.favorite, size: 28),
                    label: 'Wishlist',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_outlined, size: 28),
                    activeIcon: Icon(Icons.shopping_cart, size: 28),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline, size: 28),
                    activeIcon: Icon(Icons.person, size: 28),
                    label: 'Profile',
                  ),
                ],
                selectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                ),
              ),
              ),
            ),
          ),
          // Transparent space below navigation bar
          Container(
            height: 40.0,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
