import 'dart:convert';
import 'package:assistant_app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../routes/app_routes.dart';

class ApiService extends GetxService {
  final String _baseUrl = ApiConstants.baseUrl;
  String? _authToken; // Store the authentication token here

  @override
  void onInit() {
    super.onInit();
    _loadAuthToken(); // Load token when ApiService is initialized
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    print('Loaded token: $_authToken'); // For debugging
  }

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Persist token
    print('Token set: $_authToken'); // For debugging
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Clear token
    print('Token cleared'); // For debugging
  }

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  // --- User Authentication API Calls ---
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: getHeaders(), // No token needed for login itself
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      if (token != null) {
        await setAuthToken(token); // Store and persist the token
        return token;
      } else {
        throw Exception('Login successful but no token received.');
      }
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // --- Task API Calls (Require Token) ---
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$_baseUrl/tasks'), headers: getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else if (response.statusCode == 401) {
      Get.offAllNamed(AppRoutes.login); // Redirect to login if unauthorized
      throw Exception('Unauthorized: Please log in again.');
    } else {
      throw Exception('Failed to load tasks: ${response.body}');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: getHeaders(),
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      Get.offAllNamed(AppRoutes.login); // Redirect to login if unauthorized
      throw Exception('Unauthorized: Please log in again.');
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/tasks/${task.id}'),
      headers: getHeaders(),
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      Get.offAllNamed(AppRoutes.login); // Redirect to login if unauthorized
      throw Exception('Unauthorized: Please log in again.');
    } else {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/tasks/$taskId'),
      headers: getHeaders(),
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        Get.offAllNamed(AppRoutes.login); // Redirect to login if unauthorized
        throw Exception('Unauthorized: Please log in again.');
      } else {
        throw Exception('Failed to delete task: ${response.body}');
      }
    }
  }

  // --- Assistant API Calls (Require Token) ---
  Future<List<Assistant>> getAssistants() async {
    final response = await http.get(Uri.parse('$_baseUrl/assistants'), headers: getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((assistant) => Assistant.fromJson(assistant)).toList();
    } else if (response.statusCode == 401) {
      Get.offAllNamed(AppRoutes.login); // Redirect to login if unauthorized
      throw Exception('Unauthorized: Please log in again.');
    } else {
      throw Exception('Failed to load assistants: ${response.body}');
    }
  }


  
}