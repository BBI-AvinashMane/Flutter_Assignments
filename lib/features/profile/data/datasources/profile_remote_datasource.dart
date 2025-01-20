
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/profile_model.dart';

// class ProfileRemoteDataSource {
//   final FirebaseFirestore firestore;

//   ProfileRemoteDataSource({required this.firestore});

//    Future<void> updateProfileImage(String userId, String imageUrl) async {
//     await firestore.collection('users').doc(userId).update({'profileImage': imageUrl});
//   }

//   /// Save or Update Profile Data
//   Future<void> saveOrUpdateProfile(ProfileModel profileModel) async {
//     await firestore.collection('profiles').doc(profileModel.email).set(
//           profileModel.toMap(),
//           SetOptions(merge: true),
//         );
//   }

//   /// Fetch Profile Data
//   Future<ProfileModel?> fetchProfile(String email) async {
//     final doc = await firestore.collection('profiles').doc(email).get();

//     if (doc.exists) {
//       return ProfileModel.fromMap(doc.data()!);
//     }
//     return null;
//   }
// }


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

  /// Save or Update Profile Data
  Future<void> saveOrUpdateProfile(ProfileModel profileModel) async {
    if (profileModel.email.isEmpty) {
      throw Exception('Email is required to save or update profile.');
    }

    try {
      await firestore.collection('profiles').doc(profileModel.email).set(
            profileModel.toMap(),
            SetOptions(merge: true),
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
