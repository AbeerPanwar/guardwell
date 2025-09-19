import 'dart:convert';
import 'package:guardwell/data/models/tourist_model.dart';
import 'package:guardwell/domain/entities/tourist.dart';
import 'package:http/http.dart' as http;

abstract class TouristRemoteDataSource {
  Future<void> createTourist(Tourist tourist);
}

class TouristRemoteDataSourceImpl implements TouristRemoteDataSource {
  final String baseUrl;
  final String token;

  TouristRemoteDataSourceImpl({required this.baseUrl, required this.token});

  @override
  Future<void> createTourist(Tourist tourist) async {
    final model = TouristModel(
      fullName: tourist.fullName,
      dob: tourist.dob,
      itinerary: tourist.itinerary,
      passport: tourist.passport,
      aadhaar: tourist.aadhaar,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/api/tourist/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 201) {
      print(response.body);
    } else {
      throw Exception('Failed to create tourist: ${response.body}');
    }
  }
}
