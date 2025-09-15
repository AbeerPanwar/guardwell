import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/data/datasources/aut_local_datasource.dart';
import 'package:guardwell/domain/usecases/auth/login_usecase.dart';
import 'package:guardwell/domain/usecases/auth/logout_usecase.dart';
import 'package:guardwell/domain/usecases/auth/register_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthLocalDataSourceImpl _localDataSource;
  String? jwtToken;

  AuthCubit(
    this.loginUseCase,
    this.registerUseCase,
    this.logoutUseCase,
    this._localDataSource,
  ) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final token = await _localDataSource.getToken();
    print('abeer abeer abeer abberr abeer$token');
    if (token != null) {
      // ✅ User is logged in
      emit(AuthAuthenticated(token));
      jwtToken = token;
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await loginUseCase.call(email, password);
      emit(AuthAuthenticated(token));
    } catch (e) {
      emit(AuthError("Login failed: $e"));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      await registerUseCase.call(name, email, password);
      emit(AuthAuthenticated(token));
    } catch (e) {
      emit(AuthError("Register failed: $e"));
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  String get token => jwtToken ?? '';
}
