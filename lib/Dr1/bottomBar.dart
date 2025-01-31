import 'package:flutter/material.dart';
import 'package:services/Dr1/DroneHomePage.dart';
import 'package:services/Dr1/Labs.dart';
import 'package:services/Dr1/Medicine.dart';
import 'package:services/Dr1/myOrders.dart';
import 'package:services/Dr1/profile.dart';

import '../constants/constants.dart';

class DroneBottomNavigation extends StatefulWidget {
  @override
  _DroneBottomNavigationState createState() => _DroneBottomNavigationState();
}

class _DroneBottomNavigationState extends State<DroneBottomNavigation> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    Dronehomepage(),
    LabsScreen(),
    MedicineHomePage(),
    DrOneProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: d1blue,
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor:Colors.black,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home-9-line.png',
              height: 25,
                color: Colors.black45
            ),
            activeIcon: Image.asset(
              'assets/icons/home-9-fill.png',
              height: 25,
                color: Colors.black
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Image.asset(
              'assets/icons/flask-line.png',
              height: 30,
                color: Colors.black45
            ),
            activeIcon: Image.asset(
              'assets/icons/flask-fill.png',
              height: 30,
                color: Colors.black
            ),
            label: "Labs",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/store-2-line.png',
              color: Colors.black45,
              height: 25,
            ),
            activeIcon: Image.asset(
              'assets/icons/store-2-fill.png',
              height: 25,
                color: Colors.black
            ),
            label: "Medicine",
          ),
          BottomNavigationBarItem(
            icon:Image.asset('assets/icons/account-circle-2-line.png',
              color: Colors.black45,),
            activeIcon: Image.asset('assets/icons/account-circle-2-fill.png',
              color:Colors.black,),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}