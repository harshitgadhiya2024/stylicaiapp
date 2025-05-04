
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stylicai/Utills/globle_variable.dart';

class UserVerificationController extends GetxController{

  var isVerified = true.obs;
  var isLoading = true.obs;

  Future<void> checkVerification() async{
    print("api calling: ${GlobleVariables.userId}");
    try{

      // final url = Uri.parse('https://stylicai.stylic.ai/stylicai/check-verified?user_id');
      //
      // final Map<String, dynamic> data = {
      //   'user_id' : GlobleVariables.userId
      //
      // };
      //
      // final response = await http.post(url, body: data);
      //

      final response = await http.get(Uri.parse("https://stylicai.stylic.ai/stylicai/check-verified?user_id=${GlobleVariables.userId}"));
      print(response);
      if(response.statusCode == 200){
        final data = json.decode(response.body);
        print("verification response :$data");
        isVerified.value = data['data']['verified'];
        isLoading.value = false;
      }
      else{
        print('Failed to check verification. Status code: ${response.statusCode}');
        isVerified.value = false;
        isLoading.value = false;
      }
    }
    catch(e){
      print('Error checking verification: $e');
      isVerified.value = false;
      isLoading.value = false;
    }
  }
}