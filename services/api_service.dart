import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.126.209:8080'; // 백엔드 IP:포트

  // 예시: GET 요청
  Future<Map<String, dynamic>> fetchDashboard() async {
    final response = await http.get(Uri.parse('$baseUrl/api/dashboard'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load dashboard (${response.statusCode})');
    }
  }

  // 예시: POST 요청
  Future<void> postWaterIntake(int amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/water-intake'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': amount}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to post water intake (${response.statusCode})');
    }
  }
}
