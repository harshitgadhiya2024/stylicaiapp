import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stylicai/Utills/globle_variable.dart';


class CheckLimitController extends GetxController {

  Future<Map<String, Object>> checklimit({
    required String photoshootType,
  }) async {

    try {
      await GlobleVariables.loadSavedUserId();
      final url = Uri.parse('https://backendapp.stylic.ai/stylic/check_limit');

      final Map<String, dynamic> data = {
        'user_id': GlobleVariables.userId,
        'photoshoot_type': photoshootType,

      };
      print(data);

      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Response JSON: $jsonData");
        bool isVerified = jsonData['data']['is_verified'];
        print(isVerified);
        int status = jsonData['status'];
        print(status);
        print("coming in here");

        return {
          'isVerified': isVerified,
          'status': status,
        };
      } else {
        final jsonData = json.decode(response.body);
        print("data was: ${jsonData}");
        int status = jsonData['status'];
        return {
          'isVerified': false,
          'status': status,
        };
      }
    } catch (e) {
      print(e);
      return {
        'isVerified': false,
        'status': 403,
      };
    }
  }
}
