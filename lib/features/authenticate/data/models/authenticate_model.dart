import 'package:task_manager_firebase/core/utils/constants.dart';

class AuthenticateModel {
  final String userId;

  AuthenticateModel({required this.userId});

  factory AuthenticateModel.fromJson(Map<String, dynamic> json) {
    return AuthenticateModel(userId: json[Constants.userId]);
  }

  Map<String, dynamic> toJson() {
    return {Constants.userId: userId};
  }
}
