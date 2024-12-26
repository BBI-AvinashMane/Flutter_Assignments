class AuthenticateModel {
  final String userId;

  AuthenticateModel({required this.userId});

  factory AuthenticateModel.fromJson(Map<String, dynamic> json) {
    return AuthenticateModel(userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId};
  }
}
