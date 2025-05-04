import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylicai/Utills/background_selection_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/GarmentController.dart';
import 'app_color.dart';

class ColorTypeScreen extends StatefulWidget {
  final GarmentController garmentController;
  const ColorTypeScreen({super.key, required this.garmentController});

  @override
  State<ColorTypeScreen> createState() => _ColorTypeScreenState();
}

class _ColorTypeScreenState extends State<ColorTypeScreen> {
  final colorTypes = ['Single Color', 'Multi Color'];
  String? selectedColorType;

  Future<void> colortypeselect(String value) async {
    try {
      setState(() {
        selectedColorType = value.toString();
      });
      widget.garmentController.setColorType(value.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BackgroundSelectionScreen(garmentController: widget.garmentController,),
        ),
      );
    } catch (e) {
      print('Error fetching backgrounds: $e');
    }
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
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select your color type", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.textColor)),
            SizedBox(height:  10,),
            Divider(thickness: 1,),
            Container(
              height: 600,
              child: ListView.builder(
                itemCount: colorTypes.length,
                // separatorBuilder: (context, index) {
                //   return Divider(thickness: 1,);
                // },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      colortypeselect(colorTypes[index].toString());
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
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
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            // Container(
                            //   height: 40,
                            //   width: 40,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(5),
                            //     color: AppColor.backGroundColor,
                            //   ),
                            //   child: Icon(Icons.eighteen_mp),
                            // ),
                            Text(
                              colorTypes[index].toString(),
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
