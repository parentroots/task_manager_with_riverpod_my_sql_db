import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  // Base URL that works on Android Emulator, iOS Simulator, and Web
  String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return "http://10.0.2.2:8000/api";
    }
    return "http://127.0.0.1:8000/api";
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final body = jsonEncode({
      'email': email.trim(),
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));



      
      if (response.statusCode == 200) {
        print("Sign in success: ${response.body}");
        final decoded = jsonDecode(response.body);
        final token = decoded['token'] ?? decoded['data']?['token'] ?? decoded['access_token'];
        return token as String?;
      } else {
        print("Sign in failed response: ${response.body}");
        String message = "Sign in failed";
        try {
          final decoded = jsonDecode(response.body);
          message = decoded['message'] ?? decoded['error'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } on SocketException {
      throw Exception("Cannot connect to server. Please check if your server is running.");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final body = jsonEncode({
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'password_confirmation': confirmPassword,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Sign up success: ${response.body}");
      } else {
        print("Sign up failed response: ${response.body}");
        String message = "Sign up failed";
        try {
          final decoded = jsonDecode(response.body);
          message = decoded['message'] ?? decoded['error'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } on SocketException {
      throw Exception("Cannot connect to server. Please check if your server is running.");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    // Implement API call to sign out / clear local token if necessary
  }
}

