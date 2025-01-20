import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<SaveProfileEvent>(_onSaveProfileEvent);
    on<FetchProfileEvent>(_onFetchProfileEvent);
  }

  Future<void> _onSaveProfileEvent(
    SaveProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final profile = Profile(
      username: event.username,
      address: event.address,
      mobileNumber: event.mobileNumber,
      alternateMobileNumber: event.alternateMobileNumber,
      email: event.email,
      profileImageUrl: event.profileImageUrl,
    );

    final result = await profileRepository.saveOrUpdateProfile(profile);
    result.fold(
      (exception) => emit(ProfileError(error: exception.toString())),
      (_) => emit(ProfileSaved()),
    );
  }

  Future<void> _onFetchProfileEvent(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await profileRepository.fetchProfile(event.email);
    result.fold(
      (exception) => emit(ProfileError(error: exception.toString())),
      (profile) {
        if (profile != null) {
          emit(ProfileLoaded(profile: profile));
        } else {
          emit(ProfileError(error: 'Profile not found.'));
        }
      },
    );
  }
}
