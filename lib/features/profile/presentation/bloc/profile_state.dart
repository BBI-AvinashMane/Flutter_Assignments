import 'package:purchaso/features/profile/domain/entities/profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded({required this.profile});
}

class ProfileSaved extends ProfileState {}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({required this.error});
}

class ProfileCompletionChecked extends ProfileState {
  final bool isProfileComplete;
  final Profile profile;
  ProfileCompletionChecked({required this.isProfileComplete,required this.profile});
}

class ProfileNotExist extends ProfileState{
  String email;
  ProfileNotExist({required this.email});
}

