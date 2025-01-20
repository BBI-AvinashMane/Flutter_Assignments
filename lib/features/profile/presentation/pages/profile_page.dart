// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class ProfilePage extends StatelessWidget {
//   final String username; // Pass the username from AuthBloc

//   const ProfilePage({required this.username, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final fullNameController = TextEditingController();
//     final addressController = TextEditingController();
//     final mobileController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.black,
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/home', arguments: username);
//             },
//             child: const Text(
//               "Skip",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Shimmer.fromColors(
//                 baseColor: Colors.grey[500]!,
//                 highlightColor: Colors.white,
//                 child: const Text(
//                   "Welcome to the Profile Page!",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "Hello, $username!",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: fullNameController,
//                 decoration: InputDecoration(
//                   labelText: "Full Name",
//                   prefixIcon: const Icon(Icons.person),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: addressController,
//                 decoration: InputDecoration(
//                   labelText: "Address",
//                   prefixIcon: const Icon(Icons.location_on),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: mobileController,
//                 decoration: InputDecoration(
//                   labelText: "Mobile Number",
//                   prefixIcon: const Icon(Icons.phone),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   final fullName = fullNameController.text.trim();
//                   final address = addressController.text.trim();
//                   final mobile = mobileController.text.trim();

//                   if (fullName.isEmpty || address.isEmpty || mobile.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please fill in all fields before proceeding.'),
//                       ),
//                     );
//                   } else {
//                     // Logic to save profile info (e.g., save to database or state)
//                     Navigator.pushReplacementNamed(context, '/home', arguments: username);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   minimumSize: const Size.fromHeight(50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   "Save and Continue",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: Shimmer.fromColors(
//                   baseColor: Colors.grey[500]!,
//                   highlightColor: Colors.white,
//                   child: const Text(
//                     "You can skip this step and update your profile later!",
//                     style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/home', arguments: username);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[800],
//                     minimumSize: const Size.fromHeight(50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   icon: const Icon(Icons.skip_next, color: Colors.white),
//                   label: const Text(
//                     "Skip",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  final String email; // Email passed from authentication

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
            Navigator.pushReplacementNamed(context, '/home', arguments: widget.email);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            usernameController.text = profile.username;
            addressController.text = profile.address;
            mobileController.text = profile.mobileNumber;
            alternateMobileController.text = profile.alternateMobileNumber;
            selectedImageUrl = profile.profileImageUrl;
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
                        Navigator.pushNamed(
                          context,
                          '/select-profile-image',
                          arguments: (String selectedUrl) {
                            setState(() {
                              selectedImageUrl = selectedUrl;
                            });
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: selectedImageUrl.isNotEmpty
                            ? NetworkImage(selectedImageUrl)
                            : const AssetImage('assets/images/placeholder.png') as ImageProvider,
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
                      labelText: "Alternate Mobile Number",
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
                      final username = usernameController.text.trim();
                      final address = addressController.text.trim();
                      final mobile = mobileController.text.trim();
                      final alternateMobile = alternateMobileController.text.trim();

                      if (username.isEmpty || address.isEmpty || mobile.isEmpty || alternateMobile.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all fields.')),
                        );
                      } else {
                        BlocProvider.of<ProfileBloc>(context).add(
                          SaveProfileEvent(
                            username: username,
                            address: address,
                            mobileNumber: mobile,
                            alternateMobileNumber: alternateMobile,
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
