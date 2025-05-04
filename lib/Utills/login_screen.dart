
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/login_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'bottom_navigation_bar_screen.dart';
import 'firstname_screen.dart';
import 'forgotpassword_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final LoginController loginController = Get.put(LoginController());

  bool obsecurePassword = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60,),
              Container(
                  width: 200,
                  child: Image.asset("assets/images/blacklogo.png")),
              const SizedBox(height: 40,),
              const Text("Welcome back!", style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(

                  fillColor: AppColor.textfieldColor,
                  filled: true,
                  hintText: 'Enter email',
                  prefixIcon: Icon(
                    Icons.email, color: AppColor.buttonColor,),
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),

                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(
                      value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15,),
              TextFormField(
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                obscuringCharacter: "*",
                obscureText: obsecurePassword,
                decoration: InputDecoration(
                  fillColor: AppColor.textfieldColor,
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePassword = !obsecurePassword;
                      });
                    },
                    icon: Icon(obsecurePassword ? Icons.visibility_off : Icons
                        .visibility),
                  ),
                  suffixIconColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.lock, color: AppColor.buttonColor,),
                  hintText: 'Enter password',
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Checkbox(
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      }
                  ),
                  const Text("Remember me",
                    style: TextStyle(color: AppColor.textColor),),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (e) => ForgotPasswordScreen()));
                    },
                    child: Text("Forgot password ?", style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(width: 10,),

                ],
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    loginController.loginProcess(
                      context: context,
                      email: emailController.text,
                      password: passwordController.text, remember_me: rememberMe,

                    );
                  }
                  else if (emailController.text.isEmpty){
                    Fluttertoast.showToast(
                      msg: "Please enter email address",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                  else {
                    Fluttertoast.showToast(
                      msg: "Please enter password",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 140,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColor.textColor
                  ),
                  child: const Text("Sign In", style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account ?',
                    style: TextStyle(color: Color(0xff777777)),),
                  const SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (e) => const FirstNameScreen()));
                    },
                    child: const Text('Sign Up', style: TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
