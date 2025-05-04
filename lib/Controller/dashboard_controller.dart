import 'package:get/get.dart';

import '../Model/dashboard_model.dart';
import '../Utills/dashboard_service.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = DashboardService();

  // Observable variables
  final Rx<DashboardData?> dashboardData = Rx<DashboardData?>(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Get filtered categories with count > 0
  List<MapEntry<String, int>> get activeCategories {
    if (dashboardData.value == null) return [];

    return dashboardData.value!.cateBaasedMapping.entries
        .where((entry) => entry.value > 0)
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    // You can uncomment this if you want to fetch data when the controller is initialized
    // fetchDashboardData('d7669a67-5ed9-4577-bee5-912966ebf3ec');
  }

  Future<void> fetchDashboardData(String userId) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _dashboardService.getDashboardData(userId);
      dashboardData.value = response.data;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void refreshDashboard(String userId) {
    fetchDashboardData(userId);
  }
}