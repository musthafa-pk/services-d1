import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doctor_one/constants/constants.dart';
import 'package:flutter/material.dart';
import '../Constants/AppColors.dart';
import '../MedOneWidgets/customWidgets.dart';
import 'CreatingProfile/Adding medicine one.dart';
import 'CreatingProfile/pastOrder.dart';
import 'MedOneHomeScreen.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();

  // Pages for navigation
  final List<Widget> _pages = [

    MedOneHomeScreen(),
    MedicationOptionsContainer(), // Renamed and fixed this widget
    // NotificationsPage(),
    // ProfilePage(), // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: _pages,
        physics: const BouncingScrollPhysics(), // Smooth swipe with bounce effect
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color:pharmacyBlue,
        height: 60,
        index: _pageIndex, // Sync current index
        items: <Widget>[
          _buildIcon(_pageIndex == 0
              ? 'assets/medone/icons/homeicon.png'
              : 'assets/medone/icons/homeiconnotselected.png',
              25,Colors.black),
          _buildIcon(_pageIndex == 1
              ? 'assets/medone/icons/addmed.png'
              : 'assets/medone/icons/addmednotselected.png',
              30,Colors.black),
          // _buildIcon(_pageIndex == 2
          //     ? 'assets/icons/bellicon.png'
          //     : 'assets/icons/belliconnotselected.png',
          //     25),
          // Icon(
          //   Icons.person,
          //   size: 30,
          //   color: _pageIndex == 3 ? Colors.white : Colors.white.withOpacity(0.3),
          // ),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }

  // Build navigation icons
  Widget _buildIcon(String assetPath, double size,Color iconColor) {
    return Image.asset(
      assetPath,
      height: size,
      width: size,
      color: iconColor,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Separate widget for the medication options container
class MedicationOptionsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Do you have any past orders or need to add it manually?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // "Past Order" button
            Dronewidgets.mainButton(
              title: 'Past Order',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicineListPastorder()),
                );
              },
            ),
            SizedBox(height: 12),
            // "Add Medication" button
            Dronewidgets.mainButton(
              title: 'Add Medication',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddingMedicineone()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:med_one/app_colors.dart';
// import 'package:med_one/view/Home_pages/Notifications.dart';
// import 'package:med_one/view/Home_pages/homepage.dart';
// import 'package:med_one/view/Creating%20Profile/Adding%20medcine%20one.dart';
// import '../widgets/CustomWidgets.dart';
// import 'Creating Profile/Pastorder.dart';
// import 'Home_pages/my profile/profile.dart';
//
// class BottomNavigation extends StatefulWidget {
//   @override
//   _BottomNavigationState createState() => _BottomNavigationState();
// }
//
// class _BottomNavigationState extends State<BottomNavigation> {
//   int _pageIndex = 0;
//   final PageController _pageController = PageController();
//
//   // Pages for navigation
//   final List<Widget> _pages = [
//     Homescreen(),
//     MedicationOptionsContainer(), // Renamed and fixed this widget
//     NotificationsPage(),
//     ProfilePage(), // Profile page
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.pageColor,
//       body: PageView(
//         controller: _pageController,
//         onPageChanged: (index) {
//           setState(() {
//             _pageIndex = index;
//           });
//         },
//         children: _pages,
//         physics: const BouncingScrollPhysics(), // Smooth swipe with bounce effect
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.transparent,
//         color: AppColors.primaryColor2,
//         height: 60,
//         index: _pageIndex, // Sync current index
//         items: <Widget>[
//           _buildIcon(_pageIndex == 0
//               ? 'assets/icons/homeicon.png'
//               : 'assets/icons/homeiconnotselected.png',
//               25),
//           _buildIcon(_pageIndex == 1
//               ? 'assets/icons/addmed.png'
//               : 'assets/icons/addmednotselected.png',
//               30),
//           _buildIcon(_pageIndex == 2
//               ? 'assets/icons/bellicon.png'
//               : 'assets/icons/belliconnotselected.png',
//               25),
//           Icon(
//             Icons.person,
//             size: 30,
//             color: _pageIndex == 3 ? Colors.white : Colors.white.withOpacity(0.3),
//           ),
//         ],
//         onTap: (index) {
//           setState(() {
//             _pageIndex = index;
//           });
//           _pageController.animateToPage(
//             index,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//           );
//         },
//       ),
//     );
//   }
//
//   // Build navigation icons
//   Widget _buildIcon(String assetPath, double size) {
//     return Image.asset(
//       assetPath,
//       height: size,
//       width: size,
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
//
// // Separate widget for the medication options container
// class MedicationOptionsContainer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Center(
//             child: Container(
//               height: 450,width: 450,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),border: Border.all()),
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Do you have any past orders or need to add it manually?',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.grey,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 20),
//                     // "Past Order" button
//                     Dronewidgets.mainButton(
//                       title: 'Past Order',
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => MedicineListPastorder()),
//                         );
//                       },
//                     ),
//                     SizedBox(height: 12),
//                     // "Add Medication" button
//                     Dronewidgets.mainButton(
//                       title: 'Add Medication',
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => AddingMedicineone()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }