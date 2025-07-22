import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../screens/task_form_screen.dart';
import '../screens/task_list_screen.dart';
import '../services/api_service.dart';
import 'app_routes.dart';


class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const TaskListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ApiService>(() => ApiService()); // Initialize ApiService
        Get.lazyPut<TaskController>(() => TaskController());
      }),
    ),
    GetPage(
      name: AppRoutes.taskForm,
      page: () => const TaskFormScreen(),
      binding: BindingsBuilder(() {
        // No explicit binding needed here as TaskController is already initialized by TaskListScreen
        // and is available globally via Get.find()
      }),
    ),
  ];
}