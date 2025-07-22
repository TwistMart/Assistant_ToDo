import 'package:assistant_app/services/api_service.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';


class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if a token already exists (e.g., from a previous session)
    _apiService.setAuthToken(''); // Initialize with empty to trigger load
    if (_apiService.getHeaders().containsKey('Authorization')) {
      isLoggedIn(true);
      Get.offAllNamed(AppRoutes.home); // Go to home if already logged in
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      await _apiService.login(email, password); // This sets the token internally
      isLoggedIn(true);
      Get.offAllNamed(AppRoutes.home); // Navigate to home on success
      Get.snackbar('Success', 'Logged in successfully!');
    } catch (e) {
      Get.snackbar('Login Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      isLoggedIn(false); // Ensure false on error
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    isLoading(true);
    await _apiService.clearAuthToken();
    isLoggedIn(false);
    Get.offAllNamed(AppRoutes.login); // Go back to login screen
    isLoading(false);
    Get.snackbar('Logged Out', 'You have been logged out.');
  }
}