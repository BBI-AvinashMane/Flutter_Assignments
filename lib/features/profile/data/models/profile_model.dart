import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required String username,
    required String address,
    required String mobileNumber,
    String? alternateMobileNumber,
    required String email,
    required String profileImageUrl,
    required bool isProfileComplete,
  }) : super(
          username: username,
          address: address,
          mobileNumber: mobileNumber,
          alternateMobileNumber: alternateMobileNumber,
          email: email,
          profileImageUrl: profileImageUrl,
          isProfileComplete: isProfileComplete,
        );

  /// Convert Model to Map (for saving to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'address': address,
      'mobileNumber': mobileNumber,
     if (alternateMobileNumber != null) 'alternateMobileNumber': alternateMobileNumber,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'isProfileComplete': isProfileComplete,
    };
  }

  /// Create Model from Map (for fetching from Firebase)
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      username: map['username'] as String,
      address: map['address'] as String,
      mobileNumber: map['mobileNumber'] as String,
      alternateMobileNumber: map['alternateMobileNumber'] as String,
      email: map['email'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
      isProfileComplete: map['isProfileComplete'] as bool? ?? false,
    );
  }
}
