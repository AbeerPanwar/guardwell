import 'dart:convert';
import 'package:http/http.dart' as http;

class GetDataService {
  final String baseUrl;
  final String token;
  dynamic user = '';

  GetDataService({required this.baseUrl, required this.token});

  Future<Map<String, dynamic>> getUser() async {
    print('main ........................');
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/get-user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      user = jsonDecode(response.body);
      print(user);
      return user; // success
    } else {
      print("Failed GET ${response.statusCode}: ${response.body}");
      throw Exception("Failed GET ${response.statusCode}: ${response.body}");
    }
  }
}
