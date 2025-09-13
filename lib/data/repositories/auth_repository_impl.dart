
import 'package:guardwell/core/error/failures.dart';
import 'package:guardwell/core/network/network_info.dart';
import 'package:guardwell/data/datasources/aut_local_datasource.dart';
import 'package:guardwell/data/datasources/auth_remote_datasource.dart';
import 'package:guardwell/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<void> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await remoteDataSource.login(email, password);
        await localDataSource.saveToken(token);
      } catch (e) {
        throw ServerFailure(e.toString());
      }
    } else {
      throw const NetworkFailure('No internet connection');
    }
  }

  @override
  Future<void> register(String email, String password, String name) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await remoteDataSource.register(email, password, name);
        await localDataSource.saveToken(token);
      } catch (e) {
        throw ServerFailure(e.toString());
      }
    } else {
      throw const NetworkFailure('No internet connection');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearToken();
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.hasToken();
  }
}