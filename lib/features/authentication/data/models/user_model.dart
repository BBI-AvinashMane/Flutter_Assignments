class UserModel {
  final String email;
  final String username;

  UserModel({required this.email, required this.username});

  factory UserModel.fromFirebase(String email) {
    return UserModel(
      email: email,
      username: email.split('@')[0],
    );
  }
}
