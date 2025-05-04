import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stylicai/Controller/user_data_controller.dart';
import 'package:stylicai/Utills/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_color.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String companyName;
  final String phoneNumber;
  final String gender;

  const ProfileDetailScreen({super.key, required this.firstName, required this.lastName, required this.companyName, required this.phoneNumber, required this.gender});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColor.textColor,
                      child: (Text(widget.firstName[0].toUpperCase(), style: TextStyle(fontSize: 50, color: Colors.white),))
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.firstName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        "User",
                        style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              const Text(
                "Personal Details",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("First Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      Text(widget.firstName, style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Last Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      Text(widget.lastName, style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Company Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      Text(widget.companyName, style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Phone Number", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      Text(widget.phoneNumber, style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
            ],
          ),
      ),
    );
  }
}
