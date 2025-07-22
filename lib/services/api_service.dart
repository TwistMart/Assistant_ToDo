import 'dart:convert';
import 'package:assistant_app/constants/api_constants.dart';
import 'package:assistant_app/models/task_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = ApiConstants.baseUrl;

  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/tasks'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          List<dynamic> taskJson = responseData['data'];
          return taskJson.map((json) => Task.fromJson(json)).toList();
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load tasks');
        }
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow; // Re-throw to be caught by the controller
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 201) { // 201 Created
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return Task.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to create task');
        }
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 200) { // 200 OK
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return Task.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to update task');
        }
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/tasks/$taskId'));

      if (response.statusCode == 200) { // 200 OK
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] != 'success') {
          throw Exception(responseData['message'] ?? 'Failed to delete task');
        }
      } else {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}