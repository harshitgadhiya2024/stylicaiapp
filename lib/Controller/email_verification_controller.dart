import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class EmailVerificationController extends GetxController {

  Future<Map<String, Object>> SendEmailOtp({
    required String email,
    required String otp,
  }) async {
    
    try {
      final url = Uri.parse('https://backendapp.stylic.ai/stylic/otp-email-verification');

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
        String message = jsonData['data']['message'];
        int status = jsonData['status'];

        return {
          'message': message,
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
