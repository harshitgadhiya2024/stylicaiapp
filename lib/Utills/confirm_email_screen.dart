import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

import '../Controller/user_data_controller.dart';
import '../Controller/email_verification_controller.dart';
import '../Controller/update_user_data_controller.dart';
import 'app_color.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController(),);
  final List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode(),);
  final EmailVerificationController emailVerificationController = Get.put(EmailVerificationController(),);
  final UpdateUserDataController updateUserDataController = Get.put(UpdateUserDataController(),);

  String generatedOtp = "";
  bool otpSent = false;
  bool isLoading = false;
  bool isVerifying = false;

  bool canResend = false;
  int resendTimer = 30;
  Timer? _timer;


  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    emailController.dispose();
    super.dispose();
  }

  void startResendTimer() {
    setState(() {
      canResend = false;
      resendTimer = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (resendTimer > 0) {
          resendTimer--;
        } else {
          canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's your email?",
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: AppColor.textfieldColor,
                      filled: true,
                      hintText: 'Enter email',
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter an email address';
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: InkWell(
                      onTap: isLoading ? null : sendOtp,
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isLoading ? Colors.grey : AppColor.textColor,
                        ),
                        child:
                        Text(
                          "Send OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 90),
                  if (otpSent) ...[
                    Center(
                      child: const Text(
                        "Enter OTP",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: AppColor.textfieldColor,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(otpFocusNodes[index + 1]);
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(otpFocusNodes[index - 1]);
                                }
                                if (index == 5 && value.isNotEmpty) {
                                  validateOtp();
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: canResend ? sendOtp : null,
                          child: Text(
                            canResend
                                ? "Resend OTP"
                                : "Resend OTP in ${resendTimer}s",
                            style: TextStyle(
                              color: canResend ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: isVerifying ? null : validateOtp,
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                            isVerifying ? Colors.grey : AppColor.textColor,
                          ),
                          child:
                          isVerifying
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "Verify OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        )
    );
  }

  String generateOtp() {
    Random random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  void sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    String email = emailController.text.trim();

    // We'll use the random OTP generator that already exists
    String otp = (Random().nextInt(900000) + 100000).toString();

    try {
      var result = await emailVerificationController.SendEmailOtp(
        email: email,
        otp: otp,
      );

      setState(() => isLoading = false);

      if (result["status"] == 200) {
        // Store the OTP that was sent
        setState(() {
          otpSent = true;
          generatedOtp = otp; // Save the OTP we generated and sent
        });
        startResendTimer();

        // Show success message for sending OTP
        Fluttertoast.showToast(
          msg: "OTP sent successfully to $email",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Text(
              result["message"].toString(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
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
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(
        msg: "Error sending OTP: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void validateOtp() async {
    setState(() {
      isVerifying = true;
    });

    String enteredOtp = '';
    for (var controller in otpControllers) {
      enteredOtp += controller.text;
    }

    if (enteredOtp.length != 6) {
      Fluttertoast.showToast(
        msg: "OTP must be 6 digits",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isVerifying = false;
      });
      return;
    }

    if (enteredOtp == generatedOtp) {
      final email = emailController.text.trim();

      try {
        final result = await updateUserDataController.UpdateuserData(
          email: email,
        );

        setState(() {
          isVerifying = false;
        });

        if (result['status'] == 200) {
          // Show success dialog instead of toast
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  "Success",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Text(
                "Email Updated Successfully",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: result['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (error) {
        setState(() {
          isVerifying = false;
        });
        Fluttertoast.showToast(
          msg: "An error occurred. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      setState(() {
        isVerifying = false;
      });
      Fluttertoast.showToast(
        msg: "Invalid OTP",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}