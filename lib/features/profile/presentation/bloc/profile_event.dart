abstract class ProfileEvent {}

class SaveProfileEvent extends ProfileEvent {
  final String username;
  final String address;
  final String mobileNumber;
  final String alternateMobileNumber;
  final String email;
  final String profileImageUrl;

  SaveProfileEvent({
    required this.username,
    required this.address,
    required this.mobileNumber,
    required this.alternateMobileNumber,
    required this.email,
    required this.profileImageUrl,
  });
}

class FetchProfileEvent extends ProfileEvent {
  final String email;

  FetchProfileEvent({required this.email});
}
