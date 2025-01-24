import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchaso/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:purchaso/features/authentication/presentation/bloc/auth_event.dart';
import 'package:purchaso/features/profile/domain/entities/profile.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:purchaso/features/profile/presentation/bloc/profile_event.dart';
import 'package:purchaso/features/profile/presentation/pages/profile_page.dart';

class ProfileDetailsPage extends StatefulWidget {
  final Profile profile;

  const ProfileDetailsPage({required this.profile, Key? key}) : super(key: key);

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              _confirmLogout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: widget.profile.profileImageUrl.isNotEmpty
                    ? NetworkImage(widget.profile.profileImageUrl)
                    : const AssetImage(
                            'assets/images/default_profile_image.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Username', widget.profile.username),
            _buildDetailRow('Email', widget.profile.email),
            _buildDetailRow('Address', widget.profile.address),
            _buildDetailRow('Mobile', widget.profile.mobileNumber),
            _buildDetailRow(
              'Alternate Mobile',
              widget.profile.alternateMobileNumber?.isNotEmpty == true
                  ? widget.profile.alternateMobileNumber!
                  : 'Not Provided',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      email: widget.profile.email,
                      showSkipButton: false, // Disable Skip button in Edit Mode
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 12, 59, 140),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Edit Profile',style:TextStyle(color:Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                BlocProvider.of<ProfileBloc>(context).add(ResetProfileEvent());
                Navigator.pushNamed(context,"/");
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
