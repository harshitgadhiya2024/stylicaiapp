
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BuymoreController extends GetxController{

  Future<Map<String, Object>> requestacoin({
    required String username,
    required String email,
    required String phonenumber,
    required String user_id,
  }) async{
    try{
      final url = Uri.parse('https://backendapp.stylic.ai/stylic/request_more_coin?user_id=${user_id}');

      final Map<String,dynamic> data = {
        'user_name' : username,
        'email' : email,
        'phonenumber': phonenumber
      };
      print(data);

      final response = await http.post(url,body: data);
      final jsonData = json.decode(response.body);
      print("data was: ${jsonData}");
      String message = jsonData['data']['message'];
      int status = jsonData['status'];
      if(response.statusCode == 200){
        return {
          'message': message,
          'status': status,
        };
      } else {
        return {
          'message': message,
          'status': status,
        };
      }
    }
    catch(e){
      print('Error during Change Password: $e');
      return {
        'message': "Please try again..",
        'status': 403,
      };
    }
  }
}