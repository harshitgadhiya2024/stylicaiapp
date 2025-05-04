// Controller to manage garment data and API calls
import 'dart:io';

import 'package:http/http.dart' as http;

import '../Utills/globle_variable.dart';

class UploadBackGarmentController {
  File? garmentbackPhoto;
  String? photoshootId;

  void setGarmentPhoto(File photo) {
    garmentbackPhoto = photo;
    print(garmentbackPhoto);
  }

  void setphotoshootId(String photoshootid) {
    photoshootId = photoshootid;
    print(photoshootId);
  }

  Future<bool> submitbackimages() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://backendapp.stylic.ai/stylic/upload_back_garment?user_id=${GlobleVariables.userId}&photoshoot_id=${photoshootId}'),
      );
      print(garmentbackPhoto!.path);
      if (garmentbackPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'garment_photo',
          garmentbackPhoto!.path,
        ));
      }
      print(request.fields);
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting data: $e');
      return false;
    }
  }
}
