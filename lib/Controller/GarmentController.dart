// Controller to manage garment data and API calls
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stylicai/Utills/globle_variable.dart';

class GarmentController {
  File? garmentPhoto;
  String? garmentType;
  String? gender;
  String? ageGroup;
  String? garmentDescription;
  String? photoshootType;
  String? colorType;
  String? backgroundId;


  void setGarmentPhoto(File photo) {
    garmentPhoto = photo;
    print(garmentPhoto);
  }

  void setGarmentType(String type) {
    garmentType = type;
    print(garmentType);
  }

  void setGender(String g) {
    gender = g;
    print(gender);
  }

  void setAgeGroup(String age) {
    ageGroup = age;
    print(ageGroup);
  }

  void setGarmentDescription(String desc) {
    garmentDescription = desc;
    print(garmentDescription);
  }

  void setPhotoshootType(String type) {
    photoshootType = type;
    print(photoshootType);
  }

  void setColorType(String color) {
    colorType = color;
    print(colorType);
  }

  void setBackgroundId(String id) {
    backgroundId = id;
    print(backgroundId);
  }

  Future<bool> submitGarmentData() async {
    try {
      await GlobleVariables.loadSavedUserId();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://backendapp.stylic.ai/stylic/create-photoshoot?user_id=${GlobleVariables.userId}'),
      );
      request.fields['garment_type'] = garmentType ?? '';
      request.fields['gender'] = gender ?? '';
      request.fields['age_group'] = ageGroup ?? '';
      request.fields['garment_description'] = garmentDescription ?? '';
      request.fields['photoshoot_type'] = photoshootType ?? '';
      request.fields['color_type'] = colorType ?? '';
      request.fields['background_id'] = backgroundId ?? '';
      print(garmentPhoto!.path);
      if (garmentPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'garment_photo',
          garmentPhoto!.path,
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
