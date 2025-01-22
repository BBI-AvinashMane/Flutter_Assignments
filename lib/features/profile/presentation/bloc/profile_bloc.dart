import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<SaveProfileEvent>(_onSaveProfileEvent);
    on<FetchProfileEvent>(_onFetchProfileEvent);
    on<ResetProfileEvent>(_onResetProfileEvent);
    on<CheckProfileCompletionEvent>(_onCheckProfileCompletionEvent);
  }

  Future<void> _onSaveProfileEvent(
    SaveProfileEvent event, Emitter<ProfileState> emit) async {
  emit(ProfileLoading());

  final profile = Profile(
    username: event.username,
    address: event.address,
    mobileNumber: event.mobileNumber,
    alternateMobileNumber: event.alternateMobileNumber,
    email: event.email,
    profileImageUrl: event.profileImageUrl,
    isProfileComplete: true,
  );

  final result = await profileRepository.saveOrUpdateProfile(profile);
  result.fold(
    (exception) => emit(ProfileError(error: exception.toString())),
    (_) {
      emit(ProfileSaved());
      add(CheckProfileCompletionEvent(email: event.email));
    },
  );
}

  Future<void> _onFetchProfileEvent(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // emit(ProfileLoading());
    final result = await profileRepository.fetchProfile(event.email);
    result.fold(
      (exception) {
        emit(ProfileError(error: exception.toString()));
      },
      (profile) {
        if (profile != null) {
          emit(ProfileLoaded(profile: profile));
        }
      },
    );
  }

  Future<void> _onResetProfileEvent(
    ResetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileInitial()); 
  }

  @override
  void onTransition(Transition<ProfileEvent, ProfileState> transition) {
    super.onTransition(transition);
    debugPrint(
        'State Transition: ${transition.currentState} -> ${transition.nextState}');
  }

  Future<void> _onCheckProfileCompletionEvent(
    CheckProfileCompletionEvent event,
    Emitter<ProfileState> emit,
  ) async {
    
    final result = await profileRepository.fetchProfile(event.email);

    result.fold(
      (error) => emit(ProfileError(error: error.toString())),
      (profile) {
        if (profile != null && profile.isProfileComplete) {
          emit(ProfileCompletionChecked(isProfileComplete: true));
        } else {
          emit(ProfileCompletionChecked(isProfileComplete: false));
        }
      },
    );
  }
}
