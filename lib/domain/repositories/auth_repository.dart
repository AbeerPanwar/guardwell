import 'package:fpdart/fpdart.dart';
import 'package:guardwell/core/error/failures.dart';
import 'package:guardwell/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String name);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<bool> isLoggedIn();
}