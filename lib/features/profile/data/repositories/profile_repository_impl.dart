import 'package:dartz/dartz.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, void>> saveOrUpdateProfile(Profile profile) async {
    try {
      final profileModel = ProfileModel(
        username: profile.username,
        address: profile.address,
        mobileNumber: profile.mobileNumber,
        alternateMobileNumber: profile.alternateMobileNumber,
        email: profile.email,
        profileImageUrl: profile.profileImageUrl,
      );
      await remoteDataSource.saveOrUpdateProfile(profileModel);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to save or update profile: $e'));
    }
  }

  @override
  Future<Either<Exception, Profile?>> fetchProfile(String email) async {
    try {
      final profileModel = await remoteDataSource.fetchProfile(email);
      return Right(profileModel);
    } catch (e) {
      return Left(Exception('Failed to fetch profile: $e'));
    }
  }
}
