// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class GlobleVariables {
//     static String userId = "";
// }
//
// String userId = "";
// String googleMapKey = "AIzaSyB-Z1yfO79TH2uuDT9-fu-0YmHCRL_B9IA";
// const CameraPosition kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
// );

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobleVariables {
    static String userId = "";

    // Method to load user ID from SharedPreferences
    static Future<void> loadSavedUserId() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if (isLoggedIn) {
            userId = prefs.getString('userId') ?? "";
            print("Loaded userId from SharedPreferences: $userId");
        }
    }

    // Method to clear user session on logout
    static Future<void> clearUserSession() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('userId');
        userId = "";
    }
}

// Keep your existing global variables
String googleMapKey = "AIzaSyB-Z1yfO79TH2uuDT9-fu-0YmHCRL_B9IA";
const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
);