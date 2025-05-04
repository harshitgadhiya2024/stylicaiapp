import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:stylicai/Utills/app_color.dart';
import 'package:stylicai/Utills/dashboard_screen.dart';
import 'package:stylicai/Utills/history_screen.dart';
import 'package:stylicai/Utills/photoshoot_list_screen.dart';
import 'package:stylicai/Utills/profile_screen.dart';
import 'package:stylicai/Utills/showcase_screen.dart';
import 'package:stylicai/Utills/take_photo_screen.dart';

import '../Controller/GarmentController.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key, this.userData});
  final Map<String, dynamic>? userData;

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  final GarmentController controller = GarmentController();
  final _pageController = PageController();
  final NotchBottomBarController _bottomBarController =
      NotchBottomBarController();

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const PhotoshootListScreen(),
    const TakePhotoScreen(),
    const TransactionHistoryScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        extendBody: true,
        bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _bottomBarController,
          color: AppColor.buttonColor,
          showLabel: false,
          notchColor: AppColor.textColor,
          removeMargins: false,
          bottomBarWidth: MediaQuery.of(context).size.width * 0.85,
          durationInMilliSeconds: 300,

          bottomBarItems: const [
            BottomBarItem(
                inActiveItem: Icon(Icons.dashboard, color: Colors.white,),
                activeItem: Icon(Icons.dashboard, color: Colors.white,)),
            BottomBarItem(
                inActiveItem: Icon(Icons.photo_library, color: Colors.white,),
                activeItem: Icon(Icons.photo_library, color: Colors.white)),
            BottomBarItem(
                inActiveItem: Icon(Icons.camera,color: Colors.white,),
                activeItem: Icon(Icons.camera, color: Colors.white)),
            BottomBarItem(
                inActiveItem: Icon(Icons.history,color: Colors.white,),
                activeItem: Icon(Icons.history, color: Colors.white)),
            BottomBarItem(
                inActiveItem: Icon(Icons.person,color: Colors.white,),
                activeItem: Icon(Icons.person, color: Colors.white)),
          ],
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          kIconSize: 24,
          kBottomRadius: 35.0,
        ),
      ),
    );
  }
}
