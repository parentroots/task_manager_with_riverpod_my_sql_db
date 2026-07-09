import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskRepository {
  String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return "http://10.0.2.2:8000/api";
    }
    return "http://127.0.0.1:8000/api";
  }

  String _formatDateTime(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    return "$year-$month-$day $hour:$minute:$second";
  }

  Future<List<TaskModel>> fetchTasks(String? token) async {
    final url = Uri.parse("$baseUrl/tasks");
    print("API Request: GET $url");
    print("Authorization Token: $token");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print("API Response status: ${response.statusCode}");
      print("API Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'] as List<dynamic>? ?? [];
        return data.map((json) => TaskModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        print("Fetch tasks failed: ${response.body}");
        String message = "Failed to load tasks";
        try {
          final decoded = jsonDecode(response.body);
          message = decoded['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } on SocketException {
      throw Exception("Cannot connect to server. Please check if your server is running.");
    } catch (e) {
      rethrow;
    }
  }

  Future<TaskModel> fetchSingleTask(String? token, String id) async {
    final url = Uri.parse("$baseUrl/tasks/$id");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return TaskModel.fromJson(decoded['data'] as Map<String, dynamic>);
      } else {
        print("Fetch single task failed: ${response.body}");
        String message = "Failed to load task";
        try {
          final decoded = jsonDecode(response.body);
          message = decoded['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } on SocketException {
      throw Exception("Cannot connect to server. Please check if your server is running.");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTask({
    required String? token,
    required String title,
    required String description,
    required String status,
    required DateTime dueDate,
  }) async {
    final url = Uri.parse("$baseUrl/tasks");

    final body = jsonEncode({
      'title': title,
      'description': description,
      'status': status,
      'due_date': _formatDateTime(dueDate),
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 201 && response.statusCode != 200) {
        print("Create task failed: ${response.body}");
        String message = "Failed to create task";
        try {
          final decoded = jsonDecode(response.body);
          message = decoded['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } on SocketException {
      throw Exception("Cannot connect to server. Please check if your server is running.");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask({
    required String? token,
    required String id,
    required String title,
    required String description,
    required String status,
    required DateTime dueDate,
  }) async {
    final url = Uri.parse("$baseUrl/tasks/$id");

    final body = jsonEncode({
      'title': title,
      'description': description,
      'status': status,
      'due_date': _formatDateTime(dueDate),
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        print("Update task failed: ${response.body}");
        String message = "Failed to update task";
        try {
          final decoded = jsonDecode(response.body);
          message = decoded['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } on SocketException {
      throw Exception("Cannot connect to server. Please check if your server is running.");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String? token, String id) async {
    final url = Uri.parse("$baseUrl/tasks/$id");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        print("Delete task failed: ${response.body}");
        String message = "Failed to delete task";
        try {
          final decoded = jsonDecode(response.body);
          message = decoded['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } on SocketException {
      throw Exception("Cannot connect to server. Please check if your server is running.");
    } catch (e) {
      rethrow;
    }
  }
}
