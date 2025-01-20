import 'package:dartz/dartz.dart';
import 'package:purchaso/core/utils/username_utils.dart';
import 'package:purchaso/features/profile/domain/entities/profile.dart';
import 'package:purchaso/features/profile/domain/repositories/profile_repository.dart';

class SaveOrUpdateProfile {
  final ProfileRepository repository;

  SaveOrUpdateProfile(this.repository);

  Future<Either<Exception, void>> call(Profile profile) {
    final updatedProfile = Profile(
      username: generateDefaultUsername(profile.email, profile.username),
      address: profile.address,
      mobileNumber: profile.mobileNumber,
      alternateMobileNumber: profile.alternateMobileNumber?.isNotEmpty == true
          ? profile.alternateMobileNumber
          : null, // Handle optional field
      email: profile.email,
      profileImageUrl: profile.profileImageUrl,
    );

    return repository.saveOrUpdateProfile(updatedProfile);
  }
}
