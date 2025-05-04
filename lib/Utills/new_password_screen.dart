
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/reset_password_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.user_id});

  final String user_id;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmnNewPasswordController = TextEditingController();

  final ResetPasswordController resetPasswordController = Get.put(ResetPasswordController());

  final _passwordformkey = GlobalKey<FormState>();
  bool newPassword = true;
  bool confirmPassword = true;


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Form(
            key: _passwordformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Reset Password", style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold),),
                ),
                const SizedBox(height: 25,),

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
                      prefixIcon: Icon(Icons.lock, color: AppColor.buttonColor,),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            newPassword = !newPassword;
                          });
                        },
                        icon: Icon(newPassword ? Icons.visibility_off : Icons.visibility),
                      ),
                      suffixIconColor: Colors.white,
                      // label: const Text('Password',style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                      hintText: 'Enter new password',
                      hintStyle:const TextStyle(color: Colors.white,fontSize: 15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                const SizedBox(height: 20,),
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
                        icon: Icon(confirmPassword ? Icons.visibility_off : Icons.visibility),
                      ),
                      prefixIcon: Icon(Icons.lock_reset, color: AppColor.buttonColor,),
                      suffixIconColor: Colors.white,
                      // label: const Text('Password',style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                      hintText: 'Enter confirm password',
                      hintStyle:const TextStyle(color: Colors.white,fontSize: 15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                Center(
                  child: ElevatedButton (
                    onPressed: () async{
                      if(_passwordformkey.currentState!.validate()){
                        var response = await resetPasswordController.resetData(
                            newPassword: newpasswordController.text,
                            confirmPassword: confirmnNewPasswordController.text,
                            user_id: widget.user_id
                        );
                        if (response["status"]==200) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                  builder: (e) => LoginScreen()));
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
                                response["message"].toString(),
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.textColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
