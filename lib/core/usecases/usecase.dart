import 'package:clean_to_do_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
// import 'package:either_dart/either.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
