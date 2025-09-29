import 'package:guardwell/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call({required String email, required String password, required String name}) async {
    print(name);
    print(password);
    print(email);
    print('..............usecase');
    return await repository.register(email: email,password:  password,name:  name);
  }
}