import 'package:dartz/dartz.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Exception, void>> updateProfileImage(String userId, String imageUrl);
  Future<Either<Exception, void>> saveOrUpdateProfile(Profile profile);
  Future<Either<Exception, Profile?>> fetchProfile(String email);
}
