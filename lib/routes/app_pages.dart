import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../screens/task_form_screen.dart';
import '../screens/task_list_screen.dart';
import 'app_routes.dart';


class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.tasks,
      page: () => TaskListScreen(),
      binding: BindingsBuilder(() {
        Get.put(TaskController()); // Initialize TaskController when TaskListScreen is loaded
      }),
    ),
    GetPage(
      name: AppRoutes.taskForm,
      page: () => TaskFormScreen(),
      // No binding here as TaskController is already put in TaskListScreen,
      // and we just want to access it from TaskFormScreen
    ),
  ];
}