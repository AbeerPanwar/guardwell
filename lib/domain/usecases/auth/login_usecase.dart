import 'package:fpdart/fpdart.dart';
import 'package:guardwell/core/error/failures.dart';
import 'package:guardwell/domain/entities/user.dart';
import 'package:guardwell/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}