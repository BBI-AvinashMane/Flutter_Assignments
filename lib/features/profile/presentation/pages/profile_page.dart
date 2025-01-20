// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:purchaso/core/utils/username_utils.dart';
// import 'package:shimmer/shimmer.dart';
// import '../bloc/profile_bloc.dart';
// import '../bloc/profile_event.dart';
// import '../bloc/profile_state.dart';
// import 'select_profile_image_page.dart'; // Import the new page

// class ProfilePage extends StatefulWidget {
//   final String email; // Email passed from authentication

//   const ProfilePage({required this.email, Key? key}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController alternateMobileController = TextEditingController();

//   String selectedImageUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent(email: widget.email));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.black,
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/home', arguments: widget.email);
//             },
//             child: const Text(
//               "Skip",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: BlocConsumer<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileSaved) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Profile saved successfully.')),
//             );
//              Navigator.pushReplacementNamed(context, '/home', arguments: widget.email);
//           } else if (state is ProfileError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error)),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ProfileLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ProfileLoaded) {
//             final profile = state.profile;
//             usernameController.text = profile.username;
//             addressController.text = profile.address;
//             mobileController.text = profile.mobileNumber;
//             alternateMobileController.text = profile.alternateMobileNumber ?? '';
//             selectedImageUrl = profile.profileImageUrl;
//           }

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   Shimmer.fromColors(
//                     baseColor: Colors.grey[500]!,
//                     highlightColor: Colors.white,
//                     child: const Text(
//                       "Welcome to the Profile Page!",
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SelectProfileImagePage(
//                               onImageSelected: (String imageUrl) {
//                                 setState(() {
//                                   selectedImageUrl = imageUrl;
//                                 });
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundImage: selectedImageUrl.isNotEmpty
//                             ? NetworkImage(selectedImageUrl)
//                             : const AssetImage('assets/images/default_profile_image.png') as ImageProvider,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: usernameController,
//                     decoration: InputDecoration(
//                       labelText: "Username",
//                       prefixIcon: const Icon(Icons.person),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: addressController,
//                     decoration: InputDecoration(
//                       labelText: "Address",
//                       prefixIcon: const Icon(Icons.location_on),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: mobileController,
//                     decoration: InputDecoration(
//                       labelText: "Mobile Number",
//                       prefixIcon: const Icon(Icons.phone),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     keyboardType: TextInputType.phone,
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: alternateMobileController,
//                     decoration: InputDecoration(
//                       labelText: "Alternate Mobile Number",
//                       prefixIcon: const Icon(Icons.phone),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     keyboardType: TextInputType.phone,
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {
//                       final username = generateDefaultUsername(widget.email, usernameController.text.trim());
//                       final address = addressController.text.trim();
//                       final mobile = mobileController.text.trim();
//                       final alternateMobile = alternateMobileController.text.trim();

//                       if (username.isEmpty || address.isEmpty || mobile.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Please fill in all fields.')),
//                         );
//                       } else {
//                         BlocProvider.of<ProfileBloc>(context).add(
//                           SaveProfileEvent(
//                             username: username,
//                             address: address,
//                             mobileNumber: mobile,
//                             alternateMobileNumber: alternateMobile.isNotEmpty ? alternateMobile : '',
//                             email: widget.email,
//                             profileImageUrl: selectedImageUrl,
//                           ),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       minimumSize: const Size.fromHeight(50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       "Save and Continue",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// //=================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/core/utils/username_utils.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'select_profile_image_page.dart';

class ProfilePage extends StatefulWidget {
  final String email;

  const ProfilePage({required this.email, Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController alternateMobileController = TextEditingController();

  String selectedImageUrl = '';
  bool isProfileLoaded = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent(email: widget.email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home', arguments: widget.email);
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully.')),
            );
            Navigator.pushReplacementNamed(context, '/home', arguments: usernameController.text);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded && !isProfileLoaded) {
            final profile = state.profile;
            usernameController.text = profile.username;
            addressController.text = profile.address;
            mobileController.text = profile.mobileNumber;
            alternateMobileController.text = profile.alternateMobileNumber ?? '';
            selectedImageUrl = profile.profileImageUrl;
            isProfileLoaded = true;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[500]!,
                    highlightColor: Colors.white,
                    child: const Text(
                      "Welcome to the Profile Page!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectProfileImagePage(
                              onImageSelected: (String imageUrl) {
                                setState(() {
                                  selectedImageUrl = imageUrl;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: selectedImageUrl.isNotEmpty
                            ? NetworkImage(selectedImageUrl)
                            : const AssetImage('assets/images/default_profile_image.png') as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Address",
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: mobileController,
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: alternateMobileController,
                    decoration: InputDecoration(
                      labelText: "Alternate Mobile Number (Optional)",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      final username = generateDefaultUsername(widget.email, usernameController.text.trim());
                      final address = addressController.text.trim();
                      final mobile = mobileController.text.trim();
                      final alternateMobile = alternateMobileController.text.trim();

                      if (username.isEmpty || address.isEmpty || mobile.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all required fields.')),
                        );
                      } else {
                        BlocProvider.of<ProfileBloc>(context).add(
                          SaveProfileEvent(
                            username: username,
                            address: address,
                            mobileNumber: mobile,
                            alternateMobileNumber: alternateMobile.isNotEmpty ? alternateMobile : '',
                            email: widget.email,
                            profileImageUrl: selectedImageUrl,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save and Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
