import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylicai/Utills/agegroup_section_secreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/GarmentController.dart';
import 'app_color.dart';

class GenderSelectionScreen extends StatefulWidget {
  final GarmentController garmentController;
  const GenderSelectionScreen({super.key, required this.garmentController});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  final genders = ['Male', 'Female'];
  final gendericons = ['male', 'female'];
  String? selectedGender;

  Future<void> genderselection(String value) async {
    try {
      setState(() {
        selectedGender = value.toString();
      });
      widget.garmentController.setGender(value.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgegroupSectionSecreen(garmentController: widget.garmentController,),
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
              Text("Select your gender", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.textColor)),
              SizedBox(height:  10,),
              Divider(thickness: 1,),
              Container(
                height: 600,
                child: ListView.builder(
                  itemCount: genders.length,
                  // separatorBuilder: (context, index) {
                  //   return Divider(thickness: 1,);
                  // },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        genderselection(genders[index].toString());
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
                              //   child: Icon(Icons.),
                              // ),
                              Text(
                                genders[index].toString(),
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
        )
    );
  }

}
