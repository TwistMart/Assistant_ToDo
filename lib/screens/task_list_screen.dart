import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../controllers/task_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  final TaskController taskController = Get.find(); // Find the already initialized controller

  TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily To-Do', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (taskController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(taskController.errorMessage.value, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => taskController.fetchTasks(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (taskController.tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No tasks yet!\nTap the + button to add one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: taskController.tasks.length,
            itemBuilder: (context, index) {
              final task = taskController.tasks[index];
              return Slidable(
                key: ValueKey(task.id), // Unique key for Slidable
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _confirmDelete(context, task.id!);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: TaskCard(
                  task: task,
                  onDelete: (id) => _confirmDelete(context, id),
                  onEdit: () {
                    Get.toNamed(AppRoutes.taskForm, arguments: task); // Pass task for editing
                  },
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.taskForm); // Navigate to add task form
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int taskId) {
    Get.defaultDialog(
      title: 'Delete Task',
      middleText: 'Are you sure you want to delete this task?',
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            taskController.deleteTask(taskId);
            Get.back(); // Close the dialog
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}