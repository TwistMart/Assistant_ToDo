import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:daily_todo_app/models/task_model.dart' as app_models;

import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart' as app_models; // Alias to avoid conflict with Task widget

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TaskController taskController = Get.find<TaskController>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  app_models.Task? _editingTask;
  app_models.Assistant? _selectedAssistant;

  @override
  void initState() {
    super.initState();
    _editingTask = Get.arguments as app_models.Task?;
    _titleController = TextEditingController(text: _editingTask?.title ?? '');
    _descriptionController = TextEditingController(text: _editingTask?.description ?? '');

    if (_editingTask?.assignedToId != null) {
      _selectedAssistant = taskController.assistants.firstWhereOrNull(
        (assistant) => assistant.id == _editingTask!.assignedToId,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_editingTask == null) {
        // Add new task
        taskController.addTask(
          _titleController.text,
          _descriptionController.text.isEmpty ? null : _descriptionController.text,
          _selectedAssistant?.id,
        );
      } else {
        // Update existing task
        taskController.updateTask(
          _editingTask!,
          // title: _titleController.text,
          // description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          // assignedToId: _selectedAssistant?.id,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingTask == null ? 'Add New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Obx(() {
                if (taskController.assistants.isEmpty) {
                  return const Text('No assistants available.');
                }
                return DropdownButtonFormField<app_models.Assistant>(
                  decoration: const InputDecoration(
                    labelText: 'Assign to Assistant (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedAssistant,
                  items: taskController.assistants.map((assistant) {
                    return DropdownMenuItem<app_models.Assistant>(
                      value: assistant,
                      child: Text(assistant.name),
                    );
                  }).toList(),
                  onChanged: (app_models.Assistant? newValue) {
                    setState(() {
                      _selectedAssistant = newValue;
                    });
                  },
                  hint: const Text('Select an assistant'),
                  isExpanded: true,
                );
              }),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(_editingTask == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}