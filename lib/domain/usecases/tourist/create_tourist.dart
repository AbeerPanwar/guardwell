import 'package:guardwell/domain/entities/tourist.dart';
import 'package:guardwell/domain/repositories/tourist_repository.dart';

class CreateTourist {
  final TouristRepository repository;

  CreateTourist(this.repository);

  Future<void> call(Tourist tourist) async {
    return await repository.createTourist(tourist);
  }
}
