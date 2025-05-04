import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylicai/Utills/garmenttype_screen.dart';
import 'package:stylicai/Utills/photoshoot_list_screen.dart';
import 'package:stylicai/Utills/photoshoot_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../Controller/upload_back_garment_controller.dart';
import 'app_color.dart';
import 'globle_variable.dart';

class UploadBackPhotoScreen extends StatefulWidget {
  final UploadBackGarmentController uploadBackGarmentController;
  const UploadBackPhotoScreen({super.key, required this.uploadBackGarmentController});

  @override
  State<UploadBackPhotoScreen> createState() => _UploadBackPhotoScreenState();
}

class _UploadBackPhotoScreenState extends State<UploadBackPhotoScreen> {
  final PhotoshootService _service = PhotoshootService();

  Future<void> _requestPermissions() async {
    if (await Permission.camera.request().isGranted &&
        await Permission.photos.request().isGranted) {
      // Permissions granted, proceed with image picking
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    await _requestPermissions(); // Request permissions before picking
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85, // Compress image to reduce size
      maxWidth: 1024, // Resize to avoid large files
      maxHeight: 1024,
    );

    if (pickedFile != null) {
      // Save the image to a persistent directory
      final Directory directory = await getApplicationDocumentsDirectory();
      final String newPath =
          '${directory.path}/garment_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final File newImage = await File(pickedFile.path).copy(newPath);

      setState(() {
        widget.uploadBackGarmentController.setGarmentPhoto(newImage);
      });
    } else {
      print("No image selected");
    }

    // final pickedFile = await _picker.pickImage(source: source);
    // if (pickedFile != null) {
    //   setState(() {
    //     garmentController.setGarmentPhoto(File(pickedFile.path));
    //   });
    //   // garmentController.setGarmentPhoto(File(pickedFile.path));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Select your back garment photo", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.textColor))),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        _pickImage(ImageSource.camera);
                      },
                      child: Container(
                        height: 50,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.buttonColor),
                        child: const Center(
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 28,)
                        ),
                      )
                  ),
                  InkWell(
                      onTap: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        height: 50,
                        width: 140,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.buttonColor),
                        child: const Center(
                            child: Icon(Icons.photo_size_select_actual, color: Colors.white, size: 28,)
                        ),
                      )
                  ),
                ],),
              SizedBox(height: 20,),
              Container(
                  height: 360,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Colors.grey, style: BorderStyle.solid)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.uploadBackGarmentController.garmentbackPhoto != null
                            ? Center(child: Image.file(widget.uploadBackGarmentController.garmentbackPhoto!, height: 250))
                            : Center(child: Text('No photo selected')),
                        if (widget.uploadBackGarmentController.garmentbackPhoto!=null)
                          InkWell(
                            onTap: () async {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              bool success = await widget.uploadBackGarmentController.submitbackimages();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => PhotoshootListScreen(),
                              //   ),
                              // );
                              // Close loading indicator
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: success ? Colors.green : Colors.red,
                                  content: Text(success
                                      ? 'Upload back successfully!'
                                      : 'Upload failed!'),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColor.textColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("Upload", style: TextStyle(fontSize: 16, color: Colors.white),),
                            ),
                          )
                      ],
                    ),
                  )
              ),
              SizedBox(height: 20),
              Spacer(),
              Text("Please follow some instrution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColor.textColor),),
              SizedBox(height: 10,),
              Text("Take a picture with plain background and proper visible same like above image", style: TextStyle(color: Colors.grey),),
            ],
          ),
        )
    );
  }

}
