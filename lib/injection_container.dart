import 'package:guardwell/core/network/network_info.dart';
import 'package:guardwell/data/datasources/aut_local_datasource.dart';
import 'package:guardwell/data/datasources/auth_remote_datasource.dart';
import 'package:guardwell/data/repositories/auth_repository_impl.dart';
import 'package:guardwell/domain/repositories/auth_repository.dart';
import 'package:guardwell/domain/usecases/auth/login_usecase.dart';
import 'package:guardwell/domain/usecases/auth/register_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: getIt.get<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: getIt.get<http.Client>(),
    ),
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
}