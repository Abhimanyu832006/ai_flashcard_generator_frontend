import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      "http://10.0.2.2/ai_flashcard_backend/api/auth";

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", data["data"]["token"]);
      await prefs.setString(
          "user_name", data["data"]["user"]["name"]);
      return true;
    }

    return false;
  }

  static Future<bool> register(
    String name, String email, String password) async {
  final response = await http.post( 
    Uri.parse("$baseUrl/register.php"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    }),
  );

  final data = jsonDecode(response.body);
  return data["status"] == "success";
}


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
