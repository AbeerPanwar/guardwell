import 'dart:convert';
import 'package:http/http.dart' as http;

class GetDataService {
  final String baseUrl;
  final String token;
  dynamic user = '';

  GetDataService({required this.baseUrl, required this.token});

  Future<Map<String, dynamic>> getUser() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/get-user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      user = jsonDecode(response.body);
      return user; // success
    } else {
      throw Exception("Failed GET ${response.statusCode}: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> getNotification() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/notification'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      final List<Map<String, dynamic>> notification = decoded
          .map((e) => e as Map<String, dynamic>)
          .toList();
      print(notification);
      print('..................................api');
      return notification; // success
    } else {
      throw Exception("Failed GET ${response.statusCode}: ${response.body}");
    }
  }
}
