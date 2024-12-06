import 'package:dartz/dartz.dart';
import 'package:to_do_using_bloc/core/error/failures.dart';
// import 'package:either_dart/either.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
