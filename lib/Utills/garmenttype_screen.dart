import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylicai/Utills/gender_selection_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/GarmentController.dart';
import 'app_color.dart';

class GarmenttypeScreen extends StatefulWidget {
  final GarmentController garmentController;
  const GarmenttypeScreen({super.key, required this.garmentController});

  @override
  State<GarmenttypeScreen> createState() => _GarmenttypeScreenState();
}

class _GarmenttypeScreenState extends State<GarmenttypeScreen> {
  final garmentTypes = [
    'Blazer', 'Shirt', 'T-Shirt', 'Sweat-Shirt', 'Boxer', 'Top', 'Camisole', 'Jeans', 'Dress', 'Lingerie', 'Jacket', 'Other'
  ];
  String? selectedType;

  Future<void> gotonext(String value) async {
    try {
      setState(() {
        selectedType = value.toString();
      });
      widget.garmentController.setGarmentType(value.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenderSelectionScreen(garmentController: widget.garmentController,),
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
            children: [
              Center(child: Text("Select your garment type", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColor.textColor))),
              SizedBox(height:  10,),
              Divider(thickness: 1,),
              Container(
                height: 600,
                child: ListView.builder(
                  itemCount: garmentTypes.length,
                  // separatorBuilder: (context, index) {
                  //   return Divider(thickness: 1,);
                  // },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        gotonext(garmentTypes[index].toString());
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
                                child: Image.asset("assets/images/t${index+1}.png"),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                garmentTypes[index].toString(),
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
