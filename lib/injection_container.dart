import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guardwell/core/network/network_info.dart';
import 'package:guardwell/data/datasources/aut_local_datasource.dart';
import 'package:guardwell/data/datasources/auth_remote_datasource.dart';
import 'package:guardwell/data/repositories/auth_repository_impl.dart';
import 'package:guardwell/domain/repositories/auth_repository.dart';
import 'package:guardwell/domain/usecases/auth/login_usecase.dart';
import 'package:guardwell/domain/usecases/auth/logout_usecase.dart';
import 'package:guardwell/domain/usecases/auth/register_usecase.dart';
import 'package:guardwell/presentation/bloc/Auth/auth_cubit.dart';

class GetIt {
  static final GetIt _instance = GetIt._internal();
  factory GetIt() => _instance;
  GetIt._internal();

  final Map<Type, dynamic> _services = {};

  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type \$T not registered');
    }
    return service as T;
  }

  void registerLazySingleton<T>(T Function() factory) {
    _services[T] = factory();
  }

  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }
}

final getIt = GetIt();

Future<void> init() async {
  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: const FlutterSecureStorage()),
  );

  getIt.registerLazySingleton<AuthLocalDataSourceImpl>(
    () => AuthLocalDataSourceImpl(secureStorage: const FlutterSecureStorage()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(baseUrl: dotenv.env['NODE_JS_BACKEND_URI']!),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt.get<AuthRemoteDataSource>(),
      localDataSource: getIt.get<AuthLocalDataSource>(),
      networkInfo: getIt.get<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => getIt.get<AuthRepository>() as AuthRepositoryImpl,
  );

  // Use cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt.get<AuthRepository>()),
  );
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt.get<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt.get<AuthRepository>()),
  );

  // AuthCubit
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      getIt.get<LoginUseCase>(),
      getIt.get<RegisterUseCase>(),
      getIt.get<LogoutUseCase>(),
      getIt.get<AuthLocalDataSourceImpl>(),
    ),
  );
}
