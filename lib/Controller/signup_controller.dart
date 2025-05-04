
import 'dart:convert';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utills/globle_variable.dart';
class SignupController extends GetxController {
  String firstName = '';
  String lastName = '';
  String companyName = '';
  String email = '';
  String password = '';
  String phoneNumber = '';

  void saveFirstName(String value) {
    firstName = value;
  }

  void saveLastName(String value) {
    lastName = value;
  }

  void saveCompanyName(String value) {
    companyName = value;
  }

  void savePassword(String value) {
    password = value;
  }

  void saveEmail(String value) {
    email = value;
  }

  void savePhoneNumber(String value) {
    phoneNumber = value;
  }

  Future<Map<String, Object>> SignupData() async {
    try {
      final url = Uri.parse('https://backendapp.stylic.ai/stylic/register-user');

      final Map<String, dynamic> data = {
        'first_name': firstName,
        'last_name': lastName,
        'company_name': companyName,
        'password': password,
        'email': email,
        'phone_number': phoneNumber,
      };

      print("json data: ${data}");

      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("data was: ${jsonData}");
        String user_id = jsonData['data']['user_id'];
        int status = jsonData['status'];
        GlobleVariables.userId = jsonData["data"]["user_id"].toString();
        print("GlobalVariables.regId :- ${GlobleVariables.userId}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', GlobleVariables.userId);
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
        'message': 'Please try again',
        'status': 403,
      };
    }
  }
}
