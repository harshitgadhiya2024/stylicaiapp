// route_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteController extends GetxController {
  var routePoints = <Map<String, dynamic>>[].obs;

  Future<void> fetchRoute(String from, String to) async {
    try {
      var url = Uri.parse("https://stylicai.stylic.ai/stylicai/get-cities-for-location");

      var request = http.MultipartRequest('POST', url);
      request.fields['from'] = from;
      request.fields['to'] = to;

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var decoded = json.decode(responseData);

      if (decoded['status'] == 200) {
        routePoints.value = List<Map<String, dynamic>>.from(decoded['data']);
      } else {
        Get.snackbar("Error", "Failed to fetch route");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
