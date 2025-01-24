import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purchaso/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSource({required this.firestore});

  /// Update Profile Image
  Future<void> updateProfileImage(String userId, String imageUrl) async {
    if (userId.isEmpty || imageUrl.isEmpty) {
      throw Exception('User ID and Image URL cannot be empty');
    }

    try {
      await firestore.collection('users').doc(userId).update({'profileImage': imageUrl});
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }


  Future<void> saveOrUpdateProfile(ProfileModel profileModel) async {
  if (profileModel.email.isEmpty) {
    throw Exception('Email is required to save or update profile.');
  }

  // Validate mandatory fields
  if (profileModel.username.isEmpty || profileModel.address.isEmpty) {
    throw Exception('Username and address are required to save or update profile.');
  }

  try {
    await firestore.collection('profiles').doc(profileModel.email).set(
          profileModel.toMap(),
          SetOptions(merge: true), // Merge to avoid overwriting existing fields
        );
  } catch (e) {
    throw Exception('Failed to save or update profile: $e');
  }
}

  /// Fetch Profile Data
  Future<ProfileModel?> fetchProfile(String email) async {
    if (email.isEmpty) {
      throw Exception('Email is required to fetch profile.');
    }

    try {
      final doc = await firestore.collection('profiles').doc(email).get();

      if (doc.exists) {
        return ProfileModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
