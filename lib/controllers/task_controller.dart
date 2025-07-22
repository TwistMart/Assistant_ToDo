import 'package:get/get.dart';


import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var isLoading = true.obs;
  var assistants = <Assistant>[].obs;

  final ApiService _apiService = Get.find<ApiService>();



  @override
  void onInit() {
    super.onInit();
    // This part should only run AFTER the user is logged in
    // We'll call fetchTasks and fetchAssistants when needed (e.g., after login and navigating to home)
  }

  // Call this method explicitly after successful login or on entering the TaskListScreen
  Future<void> initializeData() async {
    if (tasks.isEmpty && !isLoading.value) { // Only fetch if not already loading and no tasks
      await fetchTasks();
      await fetchAssistants();
    }
  }





  Future<void> fetchTasks() async {
    try {
      isLoading(true);
      var fetchedTasks = await _apiService.getTasks();
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks: $e');
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAssistants() async {
    try {
      var fetchedAssistants = await _apiService.getAssistants();
      assistants.assignAll(fetchedAssistants);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load assistants: $e');
      print(e);
    }
  }

  // ... rest of your controller code (addTask, updateTask, deleteTask) remains the same
  // Make sure to set the userId correctly. For demonstration, it's 1. In a real app, it would be the logged-in user's ID.
  Future<void> addTask(String title, String? description, int? assignedToId) async {
    try {
      final newTask = Task(
        userId: 1, // <<< IMPORTANT: REPLACE WITH ACTUAL LOGGED-IN USER ID
        title: title,
        description: description,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        assignedToId: assignedToId,
      );
      final createdTask = await _apiService.createTask(newTask);
      tasks.add(createdTask);
      Get.back(); // Go back to the task list after adding
      Get.snackbar('Success', 'Task added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
      print(e);
    }
  }


  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await _apiService.updateTask(task);
      int index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
      Get.back(); // Go back to the task list after updating
      Get.snackbar('Success', 'Task updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: $e');
      print(e);
    }
  }


  


}