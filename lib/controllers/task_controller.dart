import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs; // Observable list of tasks
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading(true);
      errorMessage('');
      var fetchedTasks = await _apiService.getTasks();
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      errorMessage('Failed to load tasks: ${e.toString()}');
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTask(String title, String? description) async {
    try {
      isLoading(true);
      errorMessage('');
      final newTask = Task(title: title, description: description);
      final createdTask = await _apiService.createTask(newTask);
      tasks.insert(0, createdTask); // Add to the beginning of the list
      Get.back(); // Go back to the task list screen
      Get.snackbar('Success', 'Task created successfully!', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    } catch (e) {
      errorMessage('Failed to create task: ${e.toString()}');
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      isLoading(true);
      errorMessage('');
      final updatedTask = await _apiService.updateTask(task);
      int index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask; // Update the task in the list
      }
      Get.back(); // Go back to the task list screen
      Get.snackbar('Success', 'Task updated successfully!', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    } catch (e) {
      errorMessage('Failed to update task: ${e.toString()}');
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      isLoading(true);
      errorMessage('');
      await _apiService.deleteTask(taskId);
      tasks.removeWhere((task) => task.id == taskId); // Remove from the list
      Get.snackbar('Success', 'Task deleted successfully!', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    } catch (e) {
      errorMessage('Failed to delete task: ${e.toString()}');
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}