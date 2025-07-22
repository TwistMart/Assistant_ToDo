import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends GetView<TaskController> {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'), // As per the UI screenshot
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.tasks.isEmpty) {
          return const Center(child: Text('No tasks found. Add a new one!'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return Dismissible(
                key: Key(task.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await Get.defaultDialog(
                    title: "Delete Task",
                    middleText: "Are you sure you want to delete '${task.title}'?",
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back(result: true); // Confirm deletion
                    },
                    onCancel: () {
                      Get.back(result: false); // Cancel deletion
                    },
                  );
                },
                onDismissed: (direction) {
                  // controller.deleteTask(task.id!);
                },
                child: TaskCard(
                  task: task,
                  onTap: () {
                    Get.toNamed(AppRoutes.taskForm, arguments: task);
                  },
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.taskForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}