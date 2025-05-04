import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utills/bottom_navigation_bar_screen.dart';
import '../Utills/globle_variable.dart';

class LoginController extends GetxController {
  Future<void> loginProcess({
    required BuildContext context,
    required String email,
    required String password,
    required bool remember_me,
  }) async {
    try {
      final url = Uri.parse('https://backendapp.stylic.ai/stylic/login');
      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        int status = responseData['status'];
        if (status == 200) {
          GlobleVariables.userId = responseData["data"]["user_id"].toString();
          print("GlobalVariables.regId :- ${GlobleVariables.userId}");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (remember_me) {
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('userId', GlobleVariables.userId);
          }
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BottomNavigationBarScreen()),
                (Route<dynamic> route) => false,
          );
        } else {
          Fluttertoast.showToast(
            msg: responseData['message'] ?? 'Invalid credentials',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Login failed. Status code: ${response.statusCode}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error during login: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
