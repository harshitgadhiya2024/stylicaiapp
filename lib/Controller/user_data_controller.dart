import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:stylicai/Utills/globle_variable.dart';

class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String companyName;
  final String photoCoin;
  final String photoshootCoin;
  final String gender;
  final String password;
  final String phoneNumber;
  final String userId;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.photoCoin,
    required this.photoshootCoin,
    required this.gender,
    required this.password,
    required this.phoneNumber,
    required this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      companyName: json['company_name'] ?? '',
      photoCoin: json['photo_coin'] ?? '',
      photoshootCoin: json['photoshoot_coin'] ?? '',
      gender: json['gender'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }
}

class UserDataController extends GetxController {
  var userModel = Rxn<UserModel>();
  final isLoading = false.obs;
  final error = ''.obs;

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final url = Uri.parse('https://backendapp.stylic.ai/stylic/get-user-data');

      final Map<String, dynamic> data = {
        "user_id": GlobleVariables.userId,
      };
      print("userid was: ${GlobleVariables.userId}");
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        print("output in data: ${data}");
        data["photo_coin"] = data["photo_coin"].toString();
        data["photoshoot_coin"] = data["photoshoot_coin"].toString();
        userModel.value = UserModel.fromJson(data);
      } else {
        print(response.body);
      }
      isLoading.value = false;
    } catch (e) {
      print("error in fetching data: ${e}");
    }
  }
}