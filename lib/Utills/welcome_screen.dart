
import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'firstname_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Container(
            height: 200,
            child: Image.asset("assets/images/banner.png"),
          ),
          SizedBox(height: 40,),
          Container(
            width: 200,
              child: Image.asset("assets/images/blacklogo.png")),
          SizedBox(height: 20,),
          const Text("Models Without Limits",style: TextStyle(color: AppColor.textColor, fontSize: 24,fontWeight: FontWeight.bold),),
          // const Text("Make your Dream Ride!",style: TextStyle(color: AppColor.bottomcurveColor, fontSize: 18,fontWeight: FontWeight.bold),),
          const SizedBox(height: 5,),

          // const Padding(
          //   padding: EdgeInsets.only(left: 15,right: 15),
          //   child: Center(child: Text("Make your dream ride",style: TextStyle(color: AppColor.textColor,fontSize: 20),)),
          // ),

          Spacer(),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50)),
              color: AppColor.textColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (e) => LoginScreen()));
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.buttonColor),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (e) => FirstNameScreen()));
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.buttonColor),
                    child: const Center(
                        child: Text(
                      "Signup",
                      style: TextStyle(
                          color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
