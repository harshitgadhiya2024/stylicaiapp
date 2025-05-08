import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:stylicai/Utills/globle_variable.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var uploadedImageUrl = ''.obs;

  Future<void> uploadProfilePhoto(File image) async {
    isLoading.value = true;
    String url = "https://stylicai.stylic.ai/upload-profile-photo";
    print("upload pic: $image");
    await GlobleVariables.loadSavedUserId();
    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://stylicai.stylic.ai/upload-profile-photo'));
      request.fields.addAll({
        'user_id': GlobleVariables.userId
      });
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = json.decode(respStr);
        final imageUrl = jsonResponse["data"]["profile_url"];
        uploadedImageUrl.value = imageUrl;
        print("photo upload ${imageUrl}");
        Get.snackbar("Success", "Profile photo uploaded!");
      } else {
        Get.snackbar("Error", "Upload failed: ${response.statusCode}");
        print("Error photo upload");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
