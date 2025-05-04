import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylicai/Utills/photoshoot_type_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/GarmentController.dart';
import 'app_color.dart';

class GarmentDescriptionScreen extends StatefulWidget {
  final GarmentController garmentController;
  const GarmentDescriptionScreen({super.key, required this.garmentController});

  @override
  State<GarmentDescriptionScreen> createState() => _GarmentDescriptionScreenState();
}

class _GarmentDescriptionScreenState extends State<GarmentDescriptionScreen> {
  final _descriptionController = TextEditingController();

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
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 50, top: 20),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter garment description',
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                if (_descriptionController.text.isNotEmpty) {
                  widget.garmentController.setGarmentDescription(_descriptionController.text);
                } else {
                  widget.garmentController.setGarmentDescription("nothing");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoshootTypeScreen(garmentController: widget.garmentController,),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColor.textColor
                ),
                child: const Text("Next", style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
