import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Controller/email_verification_controller.dart';
import '../Controller/signup_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'emailotp_screen.dart';
// import 'emailotp_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final EmailVerificationController emailVerificationController = Get.put(EmailVerificationController());
  final SignupController signupController = Get.put(SignupController());

  bool emailCheckBox = false;
  bool isLoading = false;

  void sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    String email = emailController.text.trim();
    String otp = (Random().nextInt(900000) + 100000).toString();
    var result = await emailVerificationController.SendEmailOtp(email: email, otp: otp);
    setState(() => isLoading = false);
    if (result["status"] == 200) {
      print("Result: $result");
     Navigator.of(context).push(MaterialPageRoute(builder: (e) => EmailOtpScreen(email: email, sendOtp: otp)));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              "Notification",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          content:  Text(
            result["message"].toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScaffold(
          showBackArrow: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("What's your email?",
                          style: TextStyle(fontSize: 25, color: AppColor.textColor, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: AppColor.textfieldColor,
                        filled: true,
                        hintText: 'Enter email',
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter an email address';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Checkbox(
                          value: emailCheckBox,
                          onChanged: (val) => setState(() => emailCheckBox = val ?? false),
                        ),
                        const Expanded(
                          child: Text(
                            "I don't want to receive special offers and personalized recommendations via text messages or calls",
                            style: TextStyle(fontSize: 15, color: Color(0xff777777)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                      color: AppColor.textColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text("Back", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: isLoading ? null : sendOtp,
                          child: Row(
                            children: [
                              if (isLoading) const SizedBox(width: 20, height: 20),
                              if (!isLoading) const SizedBox(width: 30),
                              const Text("Next", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if(isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child:  const Center(child: CircularProgressIndicator(color: Colors.white,)),
          ),
      ],
    );
  }
}
