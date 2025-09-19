import 'package:guardwell/domain/entities/tourist.dart';

abstract class TouristRepository {
  Future<void> createTourist(Tourist tourist);
}
