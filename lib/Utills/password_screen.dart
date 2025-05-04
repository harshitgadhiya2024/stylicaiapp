
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylicai/Utills/mobilenumber_screen.dart';

import '../Controller/signup_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});


  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {

  final _passwordkeyform = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  final SignupController signupController = Get.put(SignupController());

  bool obsecurePassword = true;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 8) {
      // return "Password must be exactly 8 characters long";
      return "Password must be at least 8 characters long";
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return "Password must contain at least 1 letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least 1 number";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password must contain at least 1 special character";
    }
    return null; // Password is valid
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Form(
            key: _passwordkeyform,
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Choose your password?", style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold),),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20,top: 15, right: 20),
                  child: Text(
                    "It must have at least 8 characters & 1 letter, number, special character.",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor.textColor),
                  ),
                ),
                const SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    obscuringCharacter: "*",
                    obscureText: obsecurePassword,
                    decoration: InputDecoration(
                      fillColor: AppColor.textfieldColor,
                      filled: true,
                      prefixIcon: Icon(Icons.lock, color: Colors.white,),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecurePassword = !obsecurePassword;
                          });
                        },
                        icon: Icon(obsecurePassword ? Icons.visibility_off : Icons.visibility),
                      ),
                      suffixIconColor: Colors.white,
                      // label: const Text('Password',style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                      hintText: 'Enter password',
                      hintStyle:const TextStyle(color: Colors.white,fontSize: 15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: validatePassword,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 120,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: AppColor.textColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new, size: 18,
                              color: Colors.white,),
                            SizedBox(width: 8,),
                            Text("Back", style: TextStyle(
                                fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: ()async{
                          if(_passwordkeyform.currentState!.validate()){
                              signupController.savePassword(passwordController.text.trim());
                              Navigator.of(context).push(MaterialPageRoute(builder: (e) => const MobileNumberScreen()));
                          }
                        },
                        child: const Row(
                          children: [
                            SizedBox(width: 30,),
                            Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8,),
                            Icon(Icons.arrow_forward_ios_rounded,size: 18,color: Colors.white,)
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
