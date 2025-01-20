import 'package:dartz/dartz.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class SaveOrUpdateProfile {
  final ProfileRepository repository;

  SaveOrUpdateProfile(this.repository);

  Future<Either<Exception, void>> call(Profile profile) {
    return repository.saveOrUpdateProfile(profile);
  }
}
