import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/flashcard_model.dart';
import 'auth_service.dart';

class ApiService {
  // Configurable base URL - Update this to your intended backend
  // Examples:
  // - Local PHP: "http://localhost/ai_flashcard_backend/api" (for web/iOS) or "http://10.0.2.2/ai_flashcard_backend/api" (Android emulator)
  // - Cloud API: "https://your-api-endpoint.com/api"
  // - OpenAI: "https://api.openai.com/v1" (adjust requests accordingly)
  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        return "http://10.0.2.2/ai_flashcard_backend/api";  // Android emulator
      } else if (Platform.isIOS) {
        return "http://localhost/ai_flashcard_backend/api";  // iOS simulator
      }
    } catch (e) {
      // Platform not available (e.g., on web), fallback to localhost
    }
    return "http://localhost/ai_flashcard_backend/api";  // Web or fallback
  }

  static Future<List<Flashcard>> generateFlashcards(PlatformFile file) async {
    // 1. Check Authentication
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("Not authenticated. Please login.");
    }

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/flashcards/generate.php"),
    );

    // 2. Set Headers
    request.headers["Authorization"] = token;

    // 3. Validate File Data
    if (file.path == null && file.bytes == null) {
      throw Exception("Invalid file: no path or bytes available");
    }

    // Handle file upload for different platforms
    if (file.path != null) {
      request.files.add(await http.MultipartFile.fromPath("file", file.path!));
    } else if (file.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes("file", file.bytes!, filename: file.name));
    }

    // 4. Send & Parse
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception("Server Error: ${response.statusCode} - $responseBody");
    }

    final decoded = jsonDecode(responseBody);

    if (decoded["status"] != "success") {
      throw Exception(decoded["message"] ?? "Unknown API Error");
    }

    final List list = decoded["data"]["flashcards"];

    return list.map((e) => Flashcard.fromJson(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getSets() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/flashcards/sets.php"),
      headers: {"Authorization": token ?? ""},
    );

    if (response.statusCode != 200) throw Exception("Failed to load sets");
    
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['data']['sets']);
  }

  // Fetch specific cards for a set
  static Future<List<Flashcard>> getFlashcards(int setId) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/flashcards/get.php?set_id=$setId"),
      headers: {"Authorization": token ?? ""},
    );

    if (response.statusCode != 200) throw Exception("Failed to load cards");

    final data = jsonDecode(response.body);
    final List list = data['data']['flashcards'];
    return list.map((e) => Flashcard.fromJson(e)).toList();
  }

}