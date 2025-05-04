import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/photoshoot.dart';

class PhotoshootService {
  final String baseUrl = 'https://backendapp.stylic.ai/stylic';

  // Get all photoshoots for a user
  Future<List<Photoshoot>> getAllPhotoshoots(String userId) async {
    final url = Uri.parse('$baseUrl/get-all-photoshoot?user_id=${userId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final photoshoots = (jsonResponse['data'] as List)
            .map((data) => Photoshoot.fromJson(data))
            .toList();
        return photoshoots;
      } else {
        throw Exception('Failed to load photoshoots: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

// Additional methods can be added here for other API endpoints
// For example, getting a single photoshoot by ID, creating a new photoshoot, etc.
}