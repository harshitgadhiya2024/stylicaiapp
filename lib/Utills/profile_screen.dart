import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stylicai/Controller/user_data_controller.dart';
import 'package:stylicai/Utills/buy_more_coin_screen.dart';
import 'package:stylicai/Utills/profile_detail_screen.dart';
import 'package:stylicai/Utills/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_color.dart';
import 'change_password_screen.dart';
import 'confirm_email_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDataController userDataController = Get.put(UserDataController());

  bool isLoading = true;


  Future<void> _launchURL() async {
    const url = 'https://stylic.ai/terms-and-condition';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  Future<void> fetchUserData() async {
    // Set loading to true while fetching
    setState(() {
      isLoading = true;
    });

    await userDataController.fetchUserData();


    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (userDataController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (userDataController.userModel.value == null) {
          return Center(child: Text("No data"));
        }

        final user = userDataController.userModel.value!;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async{
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileDetailScreen(
                          firstName: user.firstName,
                          lastName: user.lastName,
                          companyName: user.companyName,
                          phoneNumber: user.phoneNumber,
                          gender: user.gender,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColor.textColor,
                          child: (Text(user.firstName[0].toUpperCase(), style: TextStyle(fontSize: 50, color: Colors.white),))
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.firstName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: AppColor.textColor
                            ),
                          ),
                          // SizedBox(
                          //   height: ,
                          // ),
                          Text(
                            "User",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded),
                      const SizedBox(width: 11),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.textColor,
                    border: Border.all(
                      // color: signUpController.gender == label ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.backGroundColor,
                          ),
                          child: Image.asset("assets/images/single_coin.png"),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          "Single Coin",
                          style: const TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Spacer(),
                        Text(user.photoCoin.toString(), style: TextStyle(color: Colors.white, fontSize: 17),),
                        SizedBox(width: 30,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1,),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 10),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.textColor,
                    border: Border.all(
                      // color: signUpController.gender == label ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor.backGroundColor,
                          ),
                          child: Image.asset("assets/images/multi_coin.png"),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          "Photoshoot Coin",
                          style: const TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Spacer(),
                        Text(user.photoshootCoin.toString(), style: TextStyle(color: Colors.white, fontSize: 17),),
                        SizedBox(width: 30,)
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                // Text(
                //   "Take a moment",
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: AppColor.bottomcurveColor,
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (e) => const ConfirmEmailScreen(),
                      ),
                    );
                  },
                  child:  Row(
                    children: [
                      Icon(Icons.edit, color: AppColor.textColor),
                      SizedBox(width: 10),
                      Text(
                        "Change Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                const Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.buttonColor,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (e) => ChangePasswordScreen()),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.lock_reset),
                      SizedBox(width: 10,),
                      Text(
                        "Change password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (e) => BuyMoreCoinScreen()),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.accessibility),
                      SizedBox(width: 10,),
                      Text(
                        "Buy more coin",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                InkWell(
                  // onTap: () {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (e) => ProfilePictureScreen()),
                  //   );
                  // },
                  child: const Row(
                    children: [
                      Icon(Icons.star_rate),
                      SizedBox(width: 10,),
                      Text(
                        "Rate the app",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (e) => HelpScreen()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.help),
                      SizedBox(width: 10,),
                      Text(
                        "Help",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _launchURL,
                  child: const Row(
                    children: [
                      Icon(Icons.security),
                      SizedBox(width: 10,),
                      Text(
                        "Terms and Conditions",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    await prefs.setBool('seenIntro', false);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (e) => WelcomeScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 10),
                // InkWell(
                //   // onTap: () {
                //   //   Navigator.of(context).push(
                //   //     MaterialPageRoute(builder: (e) => ProfilePictureScreen()),
                //   //   );
                //   // },
                //   child: Container(
                //     width: double.infinity,
                //     height: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(5),
                //       color: Colors.red,
                //     ),
                //     child: Center(
                //       child: Text(
                //         "Close my account",
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //           fontSize: 16,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 110),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerifyTile(String text, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add, color: Colors.blue),
      label: Text(text, style: const TextStyle(color: Colors.blue)),
    );
  }
}
