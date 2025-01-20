import 'package:dartz/dartz.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class FetchProfile {
  final ProfileRepository repository;

  FetchProfile(this.repository);

  Future<Either<Exception, Profile?>> call(String email) {
    return repository.fetchProfile(email);
  }
}
