import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TaskController taskController = Get.find();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Task? _editingTask; // Task being edited, if any

  @override
  void initState() {
    super.initState();
    _editingTask = Get.arguments as Task?; // Get task passed for editing
    _titleController = TextEditingController(text: _editingTask?.title ?? '');
    _descriptionController = TextEditingController(text: _editingTask?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (_editingTask == null) {
        // Add new task
        taskController.addTask(title, description);
      } else {
        // Update existing task
        final updatedTask = Task(
          id: _editingTask!.id,
          title: title,
          description: description,
          createdAt: _editingTask!.createdAt, // Preserve original creation date
          updatedAt: DateTime.now(), // Update the updated_at manually for local UI
        );
        taskController.updateTask(updatedTask);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editingTask == null ? 'Add New Task' : 'Edit Task',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white), // For back button color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter task description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: taskController.isLoading.value ? null : _saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: taskController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _editingTask == null ? 'Add Task' : 'Update Task',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}