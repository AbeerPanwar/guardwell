import 'package:guardwell/data/datasources/tourist_remote_datasource.dart';
import 'package:guardwell/domain/entities/tourist.dart';
import 'package:guardwell/domain/repositories/tourist_repository.dart';

class TouristRepositoryImpl implements TouristRepository {
  final TouristRemoteDataSource remoteDataSource;

  TouristRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createTourist(Tourist tourist) {
    return remoteDataSource.createTourist(tourist);
  }
}
