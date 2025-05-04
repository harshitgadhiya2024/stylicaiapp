import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylicai/Utills/email_screen.dart';
import 'package:stylicai/Utills/password_screen.dart';

import '../Controller/signup_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';

class CompanynameScreen extends StatefulWidget {
  const CompanynameScreen({super.key});

  @override
  State<CompanynameScreen> createState() => _CompanynameScreenState();
}

class _CompanynameScreenState extends State<CompanynameScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final SignupController signupController = Get.put(SignupController());

  final _nameformkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Form(
            key: _nameformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("What's your company name?", style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold),),
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: companyNameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: AppColor.textfieldColor,
                      prefixIcon: Icon(Icons.domain, color: Colors.white,),
                      filled: true,
                      hintText: 'Your Company Name',
                      hintStyle: const TextStyle(
                          color: Colors.white, fontSize: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your company name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20,),
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
                      // const SizedBox(width: 60,),
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
                                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 120,),
                      InkWell(
                        onTap: () {
                          if (_nameformkey.currentState!.validate()) {
                            signupController.saveCompanyName(companyNameController.text.trim());
                            Navigator.of(context).push(MaterialPageRoute(builder: (e) => PasswordScreen()));
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
