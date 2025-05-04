import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/forgot_password_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'forgotpasswordotp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final ForgotPasswordController forgotPasswordController =
  Get.put(ForgotPasswordController());

  final _emailformkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Form(
            key: _emailformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: 25,
                        color: AppColor.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: AppColor.textfieldColor,
                      filled: true,
                      hintText: 'Enter email',
                      hintStyle:
                      const TextStyle(color: Colors.white, fontSize: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                const Spacer(),
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
                            Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Back",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 120,),
                      InkWell(
                        onTap: () async {
                          String email = emailController.text.trim();
                          String otp =
                          (Random().nextInt(900000) + 100000).toString();
                          if (_emailformkey.currentState!.validate()) {
                            var result = await forgotPasswordController
                                .forgotPassword(email: email, otp: otp);
                            if (result["status"] == 200) {
                              String user_id = result["user_id"].toString();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (e) => ForgotPasswordOtpScreen(
                                    email: email,
                                    sendOtp: otp,
                                    user_id: user_id,
                                  )));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Text(
                                    result["message"].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        side: const BorderSide(
                                            color: Colors.black),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text("OK",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: Colors.white,
                            )
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
