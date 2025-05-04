import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylicai/Controller/check_limit_controller.dart';
import 'package:stylicai/Utills/background_selection_screen.dart';
import 'package:stylicai/Utills/color_type_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/GarmentController.dart';
import 'app_color.dart';

class PhotoshootTypeScreen extends StatefulWidget {
  final GarmentController garmentController;
  const PhotoshootTypeScreen({super.key, required this.garmentController});

  @override
  State<PhotoshootTypeScreen> createState() => _PhotoshootTypeScreenState();
}

class _PhotoshootTypeScreenState extends State<PhotoshootTypeScreen> {
  final photoshootTypes = ['Single Photo', 'Full Photoshoot'];
  final photoshootTypesimages = ['single_coin.png', 'multi_coin.png'];
  String? selectedPhotoshootType;

  final CheckLimitController checkLimitController = CheckLimitController();

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
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select your photoshoot type", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.textColor)),
                SizedBox(height:  10,),
                Divider(thickness: 1,),
                Container(
                  height: 600,
                  child: ListView.builder(
                    itemCount: photoshootTypes.length,
                    // separatorBuilder: (context, index) {
                    //   return Divider(thickness: 1,);
                    // },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedPhotoshootType = photoshootTypes[index].toString();
                          });
                          final response = await checkLimitController.checklimit(photoshootType: photoshootTypes[index].toString());
                          if (response['isVerified'] == true) {
                            if (photoshootTypes[index].toString().toLowerCase()=="full photoshoot") {
                              widget.garmentController.setPhotoshootType(photoshootTypes[index].toString());
                              widget.garmentController.setColorType("nothing");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BackgroundSelectionScreen(garmentController: widget.garmentController,),
                                ),
                              );
                            } else {
                              widget.garmentController.setPhotoshootType(photoshootTypes[index].toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ColorTypeScreen(garmentController: widget.garmentController,),
                                ),
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white,
                                titlePadding: EdgeInsets.zero,
                                title: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Notification",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  "Don't have enough credits!",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }




                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10),
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.textColor,
                            border: Border.all(
                              // color: signUpController.gender == label ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor.backGroundColor,
                                  ),
                                  child: Image.asset("assets/images/${photoshootTypesimages[index]}"),
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  photoshootTypes[index].toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      );
  }

}
