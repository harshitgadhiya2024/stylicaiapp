import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/reset_password_controller.dart';
import 'app_color.dart';
import 'globle_variable.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmnNewPasswordController =
  TextEditingController();

  final ResetPasswordController resetPasswordController = Get.put(
    ResetPasswordController(),
  );

  // ignore: unused_field
  final _passwordformkey = GlobalKey<FormState>();
  bool newPassword = true;
  bool confirmPassword = true;

  void changepassword() async {
    var result = await resetPasswordController.resetData(newPassword: newpasswordController.text, confirmPassword: confirmnNewPasswordController.text, user_id: GlobleVariables.userId);
    if (result["status"] == 200) {
      print("Result: $result");
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
              "Success",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text(
            "Password Change Sucessfully",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
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
              onPressed: () => Navigator.pop(context),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Form(
            key: _passwordformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: newpasswordController,
                    style: TextStyle(color: Colors.white),
                    obscuringCharacter: "*",
                    obscureText: newPassword,
                    decoration: InputDecoration(
                      fillColor: AppColor.textfieldColor,
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            newPassword = !newPassword;
                          });
                        },
                        icon: Icon(
                          newPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      suffixIconColor: Colors.white,
                      // label: const Text('Password',style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                      hintText: 'Enter new password',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'new password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: confirmnNewPasswordController,
                    style: const TextStyle(color: Colors.white),
                    obscuringCharacter: "*",
                    obscureText: confirmPassword,
                    decoration: InputDecoration(
                      fillColor: AppColor.textfieldColor,
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmPassword = !confirmPassword;
                          });
                        },
                        icon: Icon(
                          confirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      suffixIconColor: Colors.white,
                      // label: const Text('Password',style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                      hintText: 'Enter confirm password',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != newpasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.red
                          ),
                          child: const Text("Cancel", style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_passwordformkey.currentState!.validate()) {
                            changepassword();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColor.textColor
                          ),
                          child: const Text("Save", style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),),
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
