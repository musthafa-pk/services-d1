import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/AppColors.dart';
import '../MedOneConstants.dart';
import '../MedOneWidgets/customWidgets.dart';
import 'Edit Routine.dart';
import 'MedicationHistory.dart';
import 'MyMedicine.dart';


class ProfilePage extends StatefulWidget {


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  @override
  void initState() {
    _loadUserName();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _loadUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString("username") ?? 'No user name found';
    });
  }

  String _getFirstLetter() {
    if (userName.isNotEmpty && userName != 'No user name found') {
      return userName[0].toUpperCase();
    }
    return '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // For the background color at the bottom
      body: Column(
        children: [
          // Purple background with circular image
          Stack(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,// Purple color
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 40,
                child: Dronewidgets.backButton(context),
              ),
              Positioned(
                top: -100, // Adjust the position as needed
                left: -100, // Adjust the position as needed
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor2, // Darker shade of teal
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // CircleAvatar(
                    //   radius: 50,
                    //   child: Icon(CupertinoIcons.person),
                    //
                    //   // You can also use Image.asset if you have a local image
                    // ),

                    CircleAvatar(backgroundColor: AppColors.primaryColor2,radius: 50,
                      child: TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                          // );
                        },
                        child: Text( _getFirstLetter(),style: text40023,),
                      ),
                    ),
                    SizedBox(height: 30),

                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Text(
                    //   'crisJoe@gmail.com',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                  left: 20,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                      child: Icon(Icons.arrow_back))),

            ],
          ),
          SizedBox(height: 20),
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16), // Add padding
              children: [
                // ProfileMenuItem(
                //   icon: Icons.person,
                //   title: 'My Profile',
                //   onTap: () {
                //     // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(),));
                //   },
                // ),
                ProfileMenuItem(
                  icon: Icons.medical_services_outlined,
                  title: 'My Medicine',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Mymedicine(),));
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.medical_services,
                  title: 'Medication History',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MedicationHistories(),));
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.edit,
                  title: 'Edit Routine',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditDailyRoutine(),));
                  },
                ),
                // ProfileMenuItem(
                //   icon: Icons.help,
                //   title: 'FAQ',
                //   onTap: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => FAQPage(),));
                //   },
                // ),
                // ProfileMenuItem(
                //   icon: Icons.info,
                //   title: 'About App',
                //   onTap: () {
                //     // Navigate to About App
                //   },
                // ),
                // ProfileMenuItem(
                //   icon: Icons.logout,
                //   title: 'Logout',
                //   onTap: () {
                //     // Show logout confirmation dialog
                //     _showLogoutDialog(context);
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            // TextButton(
            //   onPressed: () async {
            //     // Call the logout function and navigate back to the login screen
            //     await logout();
            //
            //   },
            //   child: Text('Logout'),
            // ),
          ],
        );
      },
    );
  }

  // Function to clear SharedPreferences and perform logout actions
  // Future<void> logout() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.clear();
  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your LoginPage widget
  //         (Route<dynamic> route) => false, // This will remove all previous routes
  //   );
  //   // Clear all preferences or use specific remove as needed
  //   // Optionally, you can navigate to the login screen or perform other actions
  //   print('User logged out and preferences cleared.');
  // }
}


class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: AppColors.containercolor,
          child: Icon(icon, color: Colors.black)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: CircleAvatar(
          backgroundColor: AppColors.containercolor,
          child: Icon(Icons.arrow_forward_ios, color: Colors.grey,size: 15,)),
      onTap: onTap,
    );
  }
}