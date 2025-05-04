import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'info1_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                  height: 250,
                  child: Image.asset("assets/images/1.png")),
              const SizedBox(height: 30,),
              const Text("Upload Your Garment", style: TextStyle(color: AppColor.textColor, fontSize: 30, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text("Snap a picture of your apparel and", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text("upload it to our platform", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Info1Screen(),
                        ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.textColor
                        ),
                        child: const Icon(Icons.arrow_forward, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
