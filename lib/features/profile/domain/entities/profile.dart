class Profile {
  final String username;
  final String address;
  final String mobileNumber;
  String? alternateMobileNumber;
  final String email;
  final String profileImageUrl;

  Profile({
    required this.username,
    required this.address,
    required this.mobileNumber,
    this.alternateMobileNumber,
    required this.email,
    required this.profileImageUrl,
  });
}
