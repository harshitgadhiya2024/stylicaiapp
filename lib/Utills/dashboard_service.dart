import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/dashboard_model.dart';

class DashboardService {
  final String baseUrl = 'https://backendapp.stylic.ai/';

  Future<DashboardResponse> getDashboardData(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/stylic/dashboard?user_id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DashboardResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}