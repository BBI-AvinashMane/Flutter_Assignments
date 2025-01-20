// import 'package:dartz/dartz.dart';
// import '../../domain/entities/profile.dart';
// import '../../domain/repositories/profile_repository.dart';
// import '../datasources/profile_remote_datasource.dart';
// import '../models/profile_model.dart';

// class ProfileRepositoryImpl implements ProfileRepository {
//   final ProfileRemoteDataSource remoteDataSource;

//   ProfileRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Either<Exception, void>> updateProfileImage(
//       String userId, String imageUrl) async {
//     try {
//       await remoteDataSource.updateProfileImage(userId, imageUrl);
//       return const Right(null);
//     } catch (e) {
//       return Left(Exception('Failed to update profile image: $e'));
//     }
//   }

//   @override
//   Future<Either<Exception, void>> saveOrUpdateProfile(Profile profile) async {
//     try {
//       if (profile.email.isEmpty || profile.username.isEmpty) {
//         return Left(Exception('Email and Username are required.'));
//       }
//       final profileModel = ProfileModel(
//         username: profile.username,
//         address: profile.address,
//         mobileNumber: profile.mobileNumber,
//         alternateMobileNumber: profile.alternateMobileNumber,
//         email: profile.email,
//         profileImageUrl: profile.profileImageUrl,
//       );
//       await remoteDataSource.saveOrUpdateProfile(profileModel);
//       return const Right(null);
//     } catch (e) {
//       return Left(
//           Exception('Failed to save or update profile: ${e.toString()}'));
//     }
//   }

//   @override
//  Future<Either<Exception, Profile?>> fetchProfile(String email) async {
//   try {
//     final profileModel = await remoteDataSource.fetchProfile(email);
//     if (profileModel == null) {
//       return Left(Exception('Profile not found for email: $email'));
//     }
//     return Right(profileModel);
//   } catch (e) {
//     return Left(Exception('Failed to fetch profile: ${e.toString()}'));
//   }
// }
// }
import 'package:dartz/dartz.dart';
import 'package:purchaso/core/utils/username_utils.dart';
import 'package:purchaso/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:purchaso/features/profile/data/models/profile_model.dart';
import 'package:purchaso/features/profile/domain/entities/profile.dart';
import 'package:purchaso/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, void>> updateProfileImage(String userId, String imageUrl) async {
    if (userId.isEmpty || imageUrl.isEmpty) {
      return Left(Exception('User ID and Image URL are required.'));
    }

    try {
      await remoteDataSource.updateProfileImage(userId, imageUrl);
      return const Right(null);
    } catch (e) {
      return Left(Exception('Failed to update profile image: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> saveOrUpdateProfile(Profile profile) async {
    if (profile.email.isEmpty || profile.username.isEmpty) {
      return Left(Exception('Email and Username are required.'));
    }

    try {
      final profileModel = ProfileModel(
        username: generateDefaultUsername(profile.email, profile.username),
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
    if (email.isEmpty) {
      return Left(Exception('Email is required to fetch profile.'));
    }

    try {
      final profileModel = await remoteDataSource.fetchProfile(email);
      return Right(profileModel);
    } catch (e) {
      return Left(Exception('Failed to fetch profile: $e'));
    }
  }
}
