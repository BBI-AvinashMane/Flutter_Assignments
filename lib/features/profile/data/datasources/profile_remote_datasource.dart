
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSource({required this.firestore});

  /// Save or Update Profile Data
  Future<void> saveOrUpdateProfile(ProfileModel profileModel) async {
    await firestore.collection('profiles').doc(profileModel.email).set(
          profileModel.toMap(),
          SetOptions(merge: true),
        );
  }

  /// Fetch Profile Data
  Future<ProfileModel?> fetchProfile(String email) async {
    final doc = await firestore.collection('profiles').doc(email).get();

    if (doc.exists) {
      return ProfileModel.fromMap(doc.data()!);
    }
    return null;
  }
}


