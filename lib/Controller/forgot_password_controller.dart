
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController{
  Future<Map<String, Object>> forgotPassword({
    required String email,
    required String otp,
  }) async {

    try {
      final url = Uri.parse('https://backendapp.stylic.ai/stylic/forgot-password');

      final Map<String, dynamic> data = {
        'email': email,
        'otp': otp,
      };

      final response = await http.post(url, body: data);

      print("Email: $email");
      print("otp: $otp");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Response JSON: $jsonData");
        String user_id = jsonData['data']['user_id'];
        int status = jsonData['status'];

        return {
          'user_id': user_id,
          'status': status,
        };
      } else {
        final jsonData = json.decode(response.body);
        print("data was: ${jsonData}");
        String message = jsonData['data']['message'];
        int status = jsonData['status'];
        return {
          'message': message,
          'status': status,
        };
      }
    } catch (e) {
      return {
        'message': 'Please try again..',
        'status': 403,
      };
    }
  }
}