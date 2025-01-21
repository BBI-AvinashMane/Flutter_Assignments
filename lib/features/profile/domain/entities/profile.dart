class Profile {
  final String username;
  final String address;
  final String mobileNumber;
  String? alternateMobileNumber;
  final String email;
  final String profileImageUrl;
  final bool isProfileComplete;

  Profile({
    required this.username,
    required this.address,
    required this.mobileNumber,
    this.alternateMobileNumber,
    required this.email,
    required this.profileImageUrl,
    required this.isProfileComplete,
  });

  bool get isComplete { return username.isNotEmpty &&
      address.isNotEmpty &&
      mobileNumber.isNotEmpty &&
      email.isNotEmpty &&
      profileImageUrl.isNotEmpty;}
     
}
