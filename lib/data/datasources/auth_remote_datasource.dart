import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<String> login({required String email, required String password});
  Future<String> register({required String email, required String password, required String name});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String baseUrl;

  const AuthRemoteDataSourceImpl({
    required this.baseUrl,
  });

  @override
  Future<String> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': 'TOURIST', // Always pass TOURIST role as specified
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["token"];
    } else {
      throw Exception('Login failed');
    }
  }

  @override
  Future<String> register({required String email, required String password, required String name}) async {
    print(email);
    print(password);
    print(name);
    print('...................');
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'role': 'TOURIST', // Always pass TOURIST role as specified
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data["token"];
    } else {
      throw Exception('Registration failed');
    }
  }
}