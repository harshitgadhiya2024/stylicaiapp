
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart'as http;

class MobileOtpController extends GetxController{

  Future<Map<String,dynamic>> sendOtpToPhone(String phoneNumber) async{
    final url = Uri.parse("");
    try{
      final response = await http.post(
        url,
        headers: {"Content-Type" : "application/json"},
        body: jsonEncode({"phone" : phoneNumber}),
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return {"status" : 200, "otp" : data['otp'], "message" : "OTP sent"};
      }
      else{
        return {"status": response.statusCode, "message": "Failed to send OTP"};
      }
    }
    catch(e){
      return {"status": 403, "message": "Something went wrong"};
    }
  }
}