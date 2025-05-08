import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylicai/Utills/globle_variable.dart';

import '../Controller/dashboard_controller.dart';
import 'app_color.dart';

class DashboardScreen extends StatelessWidget {

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    // Fetch data when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDashboardData();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error: ${controller.errorMessage.value}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchDashboardData(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.dashboardData.value == null) {
          return const Center(child: Text('No data available'));
        }

        final data = controller.dashboardData.value!;

        return RefreshIndicator(
          onRefresh: () => controller.fetchDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Credits section
                  _buildCreditsSection(data),
                  const SizedBox(height: 25),

                  // Photoshoot stats section
                  _buildPhotoshootStatsSection(data),
                  const SizedBox(height: 25),

                  // Categories section
                  _buildCategoriesSection(data, controller),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCreditsSection(dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: const Text(
            'Your Credits',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: _buildInfoCreditCard(
                'Single Photo',
                '${data.photoCredit}',
                Icons.photo_camera,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildInfoCreditCard(
                'Photoshoot',
                '${data.photoshootCredit}',
                Icons.collections,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoshootStatsSection(dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: const Text(
            'Photoshoot Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Total',
                '${data.totalPhotoshoot}',
                Icons.analytics,
                Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Pending',
                '${data.pendingPhotoshoot}',
                Icons.pending_actions,
                Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Completed',
                '${data.completedPhotoshoot}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(dynamic data, DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        controller.activeCategories.isEmpty
            ? const Card(
          elevation: 2,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Center(
              child: Text(
                'No active categories yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.activeCategories.length,
          itemBuilder: (context, index) {
            final category = controller.activeCategories[index];
            return _buildCategoryListTile(category.key, category.value);
          },
        ),
      ],
    );
  }

  Widget _buildInfoCreditCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      color: AppColor.textColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColor.buttonColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListTile(String category, int count) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count item${count > 1 ? 's' : ''}',
            style: const TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}