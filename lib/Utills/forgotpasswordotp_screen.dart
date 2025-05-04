import 'dart:async';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../Controller/forgot_password_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'new_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  String email;
  String sendOtp;
  String user_id;

  ForgotPasswordOtpScreen({super.key, required this.email, required this.sendOtp,required this.user_id});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());
  final ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());

  bool canResend = false;
  int countdown = 30;
  Timer? countdownTimer;
  bool lastOtpFailed = false;
  bool isLoading = false;

  late String generatedOtp;
  late String currentOtp;

  @override
  void initState() {
    super.initState();
    currentOtp = widget.sendOtp;
    startCountdown();
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    countdownTimer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      canResend = false;
      countdown = 30;
    });

    countdownTimer?.cancel(); // Just in case

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void verifyOtp() {
    setState(() {
      isLoading = true;
    });
    String enteredOtp = '';
    for(var controller in otpControllers){
      enteredOtp += controller.text;
    }
    if (enteredOtp == currentOtp) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (e) => NewPasswordScreen(user_id: widget.user_id)));
    } else {
      setState(() {
        isLoading = false;
        lastOtpFailed = true;
      });

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
          content: const Text(
            "The OTP you entered is incorrect. Please try again.",
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


  void ResendOtp() async {

    setState(() => isLoading = true);

    String otp = (Random().nextInt(900000) + 100000).toString();

    var result = await forgotPasswordController.forgotPassword(email:widget.email, otp: otp);

    setState(() {
      currentOtp = otp;
      isLoading = false;
    });

    if (result["status"] == 200) {
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
              color: Colors.green,
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
            "Password sent successfully",
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
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"].toString())));
      for(var controller in otpControllers){
        controller.clear();
      }
      lastOtpFailed = false;
      startCountdown();
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
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"].toString())));
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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Enter OTP",
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          width: 45,
                          height: 50,
                          child: TextField(
                            controller: otpControllers[index],
                            focusNode: otpFocusNodes[index],
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              filled: true,
                              fillColor: AppColor.textfieldColor,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: canResend && !isLoading ? ResendOtp : null,
                        child: Text(
                          canResend ? "Resend OTP" : "Resend in $countdown s",
                          style: TextStyle(
                            fontSize: 16,
                            color: canResend ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: AppColor.textColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          onTap: isLoading ? null : verifyOtp,
                          child: const Row(
                            children: [
                              SizedBox(width: 30),
                              Text("Next", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.white),
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
        if(isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child:  const Center(child: CircularProgressIndicator(color: Colors.white,)),
          ),
      ],
    );
  }
}
