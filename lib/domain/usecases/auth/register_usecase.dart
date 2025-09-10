import 'package:fpdart/fpdart.dart';
import 'package:guardwell/core/error/failures.dart';
import 'package:guardwell/domain/entities/user.dart';
import 'package:guardwell/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password, String name) async {
    return await repository.register(email, password, name);
  }
}