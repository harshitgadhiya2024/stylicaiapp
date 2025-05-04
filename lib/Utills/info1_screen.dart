
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'info2_screen.dart';

class Info1Screen extends StatefulWidget {
  const Info1Screen({super.key});

  @override
  State<Info1Screen> createState() => _Info1ScreenState();
}

class _Info1ScreenState extends State<Info1Screen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Container(
                  height: 250,
                  child: Image.asset("assets/images/2.png")),
              const SizedBox(height: 20,),
              const Text("AI Magic Happens", style: TextStyle(color: AppColor.textColor, fontSize: 30, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 10,),
              const Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text("Our AI seamlessly applies your", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text("garment to the AI generated model,", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text("generating a professional photoshoot.", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.textColor
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white,),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Info2Screen(),
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
                        child: Icon(Icons.arrow_forward, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );;
  }
}
