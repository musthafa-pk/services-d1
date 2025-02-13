
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doctor_one/medOne/HomePage/Profile.dart';
import 'package:doctor_one/res/medOneUrls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../../res/appUrl.dart';
import '../../utils/utils.dart';
import '../Constants/AppColors.dart';
import '../HomePage/Chat Bot/chatBot.dart';
import '../MedOneConstants.dart';
class MedOneHomeScreen extends StatefulWidget {
  @override
  _MedOneHomeScreenState createState() => _MedOneHomeScreenState();
}

class _MedOneHomeScreenState extends State<MedOneHomeScreen> with SingleTickerProviderStateMixin {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // void _setupFCM() async {
  //   // Request permission for notifications
  //   NotificationSettings settings = await _firebaseMessaging.requestPermission();
  //
  //   // Handle foreground messages
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       print('Message Title: ${message.notification?.title}');
  //       print('Message Body: ${message.notification?.body}');
  //     }
  //   });
  //
  //   // Handle background and terminated state
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     // Navigate or handle the message accordingly
  //   });
  // }

  void _setupFCM()async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        print('Message Title: ${message.notification?.title}');
        print('Message Body: ${message.notification?.body}');

        // Show the notification manually using local notifications
        await _showNotification(
          message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body',
        );
      }
    });

    // Handle background and terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigate or handle the message accordingly
    });
  }

  // Function to show a local notification
  Future<void> _showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails(
      'your_channel_id', // channel ID
      'your_channel_name', // channel name
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );

    var platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      title,
      body,
      platformDetails,
      payload: 'Notification Payload',
    );
  }

  void _retrieveToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int? userId = preferences.getInt('userId');

    String? token = await _firebaseMessaging.getToken();

    preferences.setString('fcmToken', token!);

    print("FCM Token from sharedprefrences : $token");

    Util.sendfcmtoken(token!);

    // Save the token to send push notifications
  }

  Future<void> firebaseNotificationget(int userId, String fcmToken) async {
    print('periodicaly  called....');
    final String url = MedOneUrls.firebaseNotification;  // Replace with your actual API URL

    SharedPreferences preferences = await SharedPreferences.getInstance();

    // String? userId = preferences.getString('userID');
    String? fcmtokensp = preferences.getString('fcmtoken');

    // Prepare the data to be sent in the body
    final Map<String, dynamic> body = {
      // "userId": int.parse(userId.toString()),
      "userId": userId,
      "fcmToken": fcmtokensp,
    };

    print('send fcm $fcmToken');
    print('send fcm $url');
    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',  // Set content type to JSON
        },
        body: json.encode(body),  // Encode body as JSON
      );

      print('helooooo${response.statusCode}');
      print('oooi:${response.body}');
      // Handle the response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _showNotification('${data['data']}', "body");
          print('sssssss${data}');
        } else {
          print('hellll: ${data['message']}');
        }
      } else {
        print('Error here: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// Function to call sendFcmToken every minute
//   void startSendingTokenPeriodically() {
//     // Set the interval to 1 minute (60 seconds)
//     Timer.periodic(Duration(minutes: 1), (timer) async {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//
//       // Retrieve userId and fcmtoken from SharedPreferences
//       String? userId = preferences.getString('userID');
//       String? fcmtoken = preferences.getString('fcmToken');
//
//       // Log the FCM token for debugging
//       print('Stored FCM token: $fcmtoken');
//
//       // Check if userId and fcmtoken are available
//       if (userId != null && fcmtoken != null) {
//         print('Sending FCM token for userId $userId');
//
//         // Call the function to send the FCM token to the backend
//         await firebaseNotificationget(int.parse(userId), fcmtoken);
//       } else {
//         print('Error: userId or FCM token is missing');
//       }
//     });
//   }


  ///fcmnoti ended


  Future<List<Map<String, dynamic>>>? futureMedicines;

  String? token;

  String userName = '';

  @override
  void initState() {
    print('in home');
    super.initState();
    _loadUserName();

    // Initialize local notifications
    var initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),

    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


    _setupFCM();
    _retrieveToken();
    // startSendingTokenPeriodically();
    futureMedicines = fetchMedicineSchedule(context); // Initialize the Future here
    // _loadUserName();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true); // Repeat the animation with reverse

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // String userName = '';
  @override

  // Future<void> _loadUserName() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     userName = preferences.getString("userName") ?? 'No user name found';
  //   });
  // }

  // String _getFirstLetter() {
  //   if (userName.isNotEmpty && userName != 'No user name found') {
  //     return userName[0].toUpperCase();
  //   }
  //   return '?';
  // }

  // void _retrieveToken() async {
  //   // Get the FCM token
  //   token = await _firebaseMessaging.getToken();
  //
  //   if (token != null) {
  //     print("FCM Token: $token");
  //
  //     // Send the token to the server
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     String? userId = preferences.getString('userID');
  //
  //     if (userId != null) {
  //       firebaseNotificationget(int.parse(userId), token!);
  //     } else {
  //       print("User ID is not found in SharedPreferences");
  //     }
  //   } else {
  //     print("Failed to retrieve FCM Token");
  //   }
  // }




  Future<List<Map<String, dynamic>>> fetchMedicineSchedule(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');
    final url = MedOneUrls.notifyMedicineSchedule;

    // List of colors
    final List<Color> colors = [
      AppColors.homecardcolor1,
      AppColors.homecardcolor2,
      AppColors.homecardcolor3,
      AppColors.homecardcolor4,
      AppColors.homecardcolor5,
      AppColors.homecardcolor6,
      AppColors.homecardcolor7,
      AppColors.homecardcolor8,
      AppColors.homecardcolor9,
      AppColors.homecardcolor10,
    ];

    // Map medicine types to images
    final Map<String, String> medicineTypeImages = {
      'Pills': 'assets/medone/images/medicine.png',
      'Syringe': 'assets/medone/images/syringe.png',
      'Syrup': 'assets/medone/images/syrup.png',
      'Ointment': 'assets/medone/images/ointment.png',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"userid": userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('medicine $data');
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['notifications'].asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;

            // Get medicine type image
            String? medicineType = item['medicine_type'];
            String image = medicineTypeImages[medicineType] ?? 'assets/medone/images/medicine.png';


            return {
              'name': item['medicine'] ?? 'Unknown Medicine',
              'instruction': item['notificationTime'],
              'pillCount': 'Take 1 pill(s)',
              'color': colors[index % colors.length],
              'medicine_timetableID': item['medicine_timetableID'],
              'image': image, // Add image path
            };
          })).where((medicine) => medicine['name'] != null).toList();
        } else {
          showFlushbar(context, data['message'], Colors.red);
          return [];
        }
      } else {
        showFlushbar(context, 'No notifications for medicines', Colors.red);
        return [];
      }
    } catch (e) {
      showFlushbar(context, 'Error: $e', Colors.red);
      return [];
    }
  }

  void showFlushbar(BuildContext context, String message, Color color) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: color,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
  String getMealPeriod() {
    final currentTime = DateTime.now();
    final currentHours = currentTime.hour;

    if (currentHours >= 5 && currentHours < 11) {
      return "morning";
    } else if (currentHours >= 11 && currentHours < 17) {
      return "lunch";
    } else if (currentHours >= 17 && currentHours < 24) {
      return "dinner";
    } else {
      return "Night"; // Optional: handle times between 12 AM - 5 AM
    }
  }

  Future<void> changeStatus(int timetableId, String status, String takenStatus) async {
    final url = MedOneUrls.statusChanging; // Your API URL for changing status
    final takenTime = getMealPeriod(); // Get the meal period based on current time

    try {

      SharedPreferences preferences = await SharedPreferences.getInstance();
      int? userID = preferences.getInt('userId');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userId": int.parse(userID.toString()),
          "timetableId": timetableId,
          "status": status,
          "takenTime": takenTime, // Pass meal period as takenTime
          "takenStatus": takenStatus,  // Assuming takenStatus matches the status
        }),
      );
      print(takenTime);


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Aaa $data');
        if (data['success']) {
          showFlushbar(context, 'Status updated to $status', Colors.green);
        } else {
          showFlushbar(context, 'Failed to update status: ${data['message']}', Colors.red);
        }
      } else {
        showFlushbar(context, 'Failed to update status', Colors.red);
      }
    } catch (e) {
      showFlushbar(context, 'Error: $e', Colors.red);
    }
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
    return '?';
  }

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageColor,
      floatingActionButton:
      Row(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor2,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotScreen(),));
              print("Button clicked!");
            },
            child: const Text('Chatbot',style: text50014,),
          ),
        ],
      ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.pageColor,
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(backgroundColor: AppColors.primaryColor2,
                child:
                  // Text(" _getFirstLetter()",style: text40018,),
                  Text("${_getFirstLetter()}",style: text40018,),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Hi,", style: text60022bla),
                  SizedBox(width: 9),
                  InkWell(
                      onTap: (){

                      },
                      child: Text("userName", style: text60022bla)),
                ],
              ),

              SizedBox(height: 15),
              Text("Today’s Medicine", style: text60031black),
              Text("Reminder", style: text60031black),
              SizedBox(height: 35),

              FutureBuilder<List<Map<String, dynamic>>>(  // Use FutureBuilder to fetch medicines
                future: futureMedicines,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No medicines for today.'));
                  } else {
                    final medicines = snapshot.data!;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 10,
                      child: Stack(
                        children: List.generate(medicines.length, (index) {
                          final reversedIndex = medicines.length - 1 - index; // Reverse the index
                          final medicine = medicines[reversedIndex];

                          return Positioned(
                            top: (medicines.length - 1 - index) * 20.0,
                            left: 0,
                            right: 0,
                            child: buildDismissibleCard(
                              index: index,
                              color: medicine['color'],
                              medicineName: medicine['name'].toString(),
                              instruction: medicine['instruction'],
                              pillcount: medicine['pillCount'],
                              timetableId: medicine['medicine_timetableID'],
                              image: medicine['image'],
                            ),
                          );
                        }),
                      ),
                    );

                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildDismissibleCard({
    required Color color,
    required String medicineName,
    required String instruction,
    required String pillcount,
    required int timetableId,
    required int index,
    required String image,
  }) {
    return Dismissible(
      key: UniqueKey(),
      background: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Taken',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      secondaryBackground: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text(
            'Skipped',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      // onDismissed: (direction) {
      //   String status = direction == DismissDirection.startToEnd ? 'Taken' : 'Skipped';
      //   String takenTime = DateFormat.jm().format(DateTime.now()); // Current time in "HH:mm a" format
      //   String takenStatus = direction == DismissDirection.startToEnd ? 'Yes' : 'No';
      //   changeStatus(timetableId, status, takenStatus); // Call changeStatus with the timetableId
      // },
      onDismissed: (direction) {
        String status = direction == DismissDirection.startToEnd ? 'Taken' : 'Skipped';
        String takenTime = DateFormat.jm().format(DateTime.now()); // Current time in "HH:mm a" format
        String takenStatus = direction == DismissDirection.startToEnd ? 'Yes' : 'No';

        if (direction == DismissDirection.startToEnd) {
          // Directly change status for 'Taken'
          changeStatus(timetableId, status, takenStatus);
        } else if (direction == DismissDirection.endToStart) {
          // Show confirmation dialog for 'Skipped'
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Swipe to skip? No notifications will appear.'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  }, // Close the dialog without any action
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    changeStatus(timetableId, status, takenStatus); // Save the 'Skipped' status
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      },

      child: buildCardContent(color, medicineName, instruction, pillcount, image),
    );
  }



// Helper function to create card content
  Widget buildCardContent(Color color, String medicineName, String instruction, String pillcount, String? image) {
    return Stack(
      children: [
        Container(
          height: 180,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          image != null && image.isNotEmpty
                              ? Image.asset(image)
                              : Image.asset('assets/medone/images/medicine.png'), // Default image
                        ],
                      ),
                      Positioned(
                          right: 60, // Adjust the position
                          child: IconButton(
                            onPressed: () async {
                              Util.launchAsInAppWebViewWithCustomHeaders(Uri.parse('https://youtube.com/shorts/dlsoFpl6unY?si=n2JyUzNnc8Wat1B2'));
                              // const url = 'https://youtube.com/shorts/dlsoFpl6unY?si=n2JyUzNnc8Wat1B2';
                              // final Uri uri = Uri.parse(url);
                              //
                              // if (await canLaunchUrl(Uri.parse(url))) {
                              //   await launchUrl(
                              //     Uri.parse(url),
                              //     mode: LaunchMode.externalApplication, // Opens in an external browser
                              //   );
                              // } else {
                              //   // Handle the case where the URL cannot be launched
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text('Could not launch the URL'),
                              //     ),
                              //   );
                              // }
                            },
                            icon: const Icon(Icons.play_circle, color: Colors.white),
                          )

                      ),
                      Positioned(
                        right: 30, // Adjust the position
                        child: IconButton(
                          onPressed: () {
                            print('Sss $medicineName');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatbotScreen(
                                  medicineName: medicineName,

                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.info_outline, color: AppColors.whiteColor),
                        ),
                      ),
                      // Positioned(
                      //     right: 10, // Adjust the position
                      //     child:
                      //     PopupMenuButton<String>(
                      //       onSelected: (value) async {
                      //         if (value == 'edit') {
                      //
                      //
                      //         } else if (value == 'delete') {
                      //
                      //
                      //         }
                      //       },
                      //       icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                      //       itemBuilder: (context) => [
                      //         PopupMenuItem(
                      //           value: 'edit',
                      //           child: Row(
                      //             children: const [
                      //               SizedBox(width: 8),
                      //               Text('Edit'),
                      //             ],
                      //           ),
                      //         ),
                      //         PopupMenuItem(
                      //           value: 'delete',
                      //           child: Row(
                      //             children: const [
                      //
                      //               SizedBox(width: 8),
                      //               Text('Delete'),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      //
                      //
                      // ),
                    ],
                  ),

                  Text(medicineName, style: text60022),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset('assets/medone/icons/calendar-day.png', height: 15, width: 15),
                      SizedBox(width: 10),
                      Text(instruction, style: text40014),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset('assets/medone/icons/info (2).png', height: 15, width: 15),
                      SizedBox(width: 10),
                      Text(pillcount, style: text40014),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Image.asset(
            'assets/medone/images/doctor.png',
            height: 100,
            width: 100,
          ),
        ),
      ],
    );
  }


}








// import 'dart:async';
// import 'dart:math';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'dart:convert'; // For json decoding
// import 'package:med_one/app_colors.dart'; // Adjust the import according to your project structure
// import 'package:med_one/res/appurl.dart';
// import 'package:med_one/view/Home_pages/my%20profile/edit%20profile.dart';
// import 'package:med_one/widgets/CustomWidgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Utils.dart';
// import '../../constants.dart';
// import '../../main.dart';
//
// class Homescreen extends StatefulWidget {
//   @override
//   _HomescreenState createState() => _HomescreenState();
// }
//
// class _HomescreenState extends State<Homescreen> {
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//   void _setupFCM() async {
//     // Request permission for notifications
//     NotificationSettings settings = await _firebaseMessaging.requestPermission();
//
//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         print('Message Title: ${message.notification?.title}');
//         print('Message Body: ${message.notification?.body}');
//       }
//     });
//
//     // Handle background and terminated state
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Navigate or handle the message accordingly
//     });
//   }
//   void _retrieveToken() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String? userId = preferences.getString('userID');
//
//     String? token = await _firebaseMessaging.getToken();
//     preferences.setString('fcmToken', token!);
//     print("FCM Token: $token");
//     Utils.sendfcmtoken(token!);
//
//     // Save the token to send push notifications
//   }
//
//   Future<List<Map<String, dynamic>>>? futureMedicines;
//
//   String? token;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupFCM();
//     _retrieveToken();
//     futureMedicines = fetchMedicineSchedule(context); // Initialize the Future here
//     _loadUserName();
//     // startSendingTokenPeriodically();
//   }
//   String userName = '';
//   @override
//
//   Future<void> _loadUserName() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
//       userName = preferences.getString("userName") ?? 'No user name found'; // Retrieve user name
//     });
//   }
//
//   // void _retrieveToken() async {
//   //   // Get the FCM token
//   //   token = await _firebaseMessaging.getToken();
//   //
//   //   if (token != null) {
//   //     print("FCM Token: $token");
//   //
//   //     // Send the token to the server
//   //     SharedPreferences preferences = await SharedPreferences.getInstance();
//   //     String? userId = preferences.getString('userID');
//   //
//   //     if (userId != null) {
//   //       firebaseNotificationget(int.parse(userId), token!);
//   //     } else {
//   //       print("User ID is not found in SharedPreferences");
//   //     }
//   //   } else {
//   //     print("Failed to retrieve FCM Token");
//   //   }
//   // }
//
//   Future<void> firebaseNotificationget(int userId, String fcmToken) async {
//     print('periodicaly  called....');
//     final String url = AppUrl.firebaseNotification;  // Replace with your actual API URL
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String? userId = preferences.getString('userID');
//     // Prepare the data to be sent in the body
//     final Map<String, dynamic> body = {
//       "userId": int.parse(userId.toString()),
//       "fcmToken": fcmToken,
//     };
//     print('set akk monuse $userId');
//     print('send fcm $fcmToken');
//     print('send fcm $url');
//     try {
//       // Send the POST request
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',  // Set content type to JSON
//         },
//         body: json.encode(body),  // Encode body as JSON
//       );
//
//       print('helooooo${response.statusCode}');
//       // Handle the response
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success']) {
//           print('sssssss${data}');
//         } else {
//           print('hellll: ${data['message']}');
//         }
//       } else {
//         print('Error here: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
// // Function to call sendFcmToken every minute
// //   void startSendingTokenPeriodically() {
// //     // Set the interval to 1 minute (60 seconds)
// //     Timer.periodic(Duration(minutes: 1), (timer) async {
// //       SharedPreferences preferences = await SharedPreferences.getInstance();
// //       String? userId = preferences.getString('userID');
// //       String? fcmtoken = preferences.getString('fcmToken');
// //       firebaseNotificationget(int.parse(userId.toString()), token!);
// //     });
// //   }
//
// ///fnoti
//
//
//   // Future<List<Map<String, dynamic>>> fetchMedicineSchedule() async {
//   //   SharedPreferences preferences = await SharedPreferences.getInstance();
//   //   String? userId = preferences.getString('userID');
//   //   final url = AppUrl.notifyMedicineSchedule;
//   //
//   //   // List of colors
//   //   final List<Color> colors = [
//   //     AppColors.homecardcolor1,
//   //     AppColors.homecardcolor2,
//   //     AppColors.homecardcolor3,
//   //     AppColors.homecardcolor4,
//   //         AppColors.homecardcolor5,
//   //         AppColors.homecardcolor6,
//   //         AppColors.homecardcolor7,
//   //         AppColors.homecardcolor8,
//   //         AppColors.homecardcolor9,
//   //         AppColors.homecardcolor10,
//   //   ];
//   //
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse(url),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: json.encode({"userid": int.parse(userId.toString())}),
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       print('medicine $data');
//   //       if (data['success']) {
//   //         return List<Map<String, dynamic>>.from(data['notifications'].asMap().entries.map((entry) {
//   //           int index = entry.key;
//   //           var item = entry.value;
//   //
//   //           return {
//   //             'name': item['medicine'] ?? 'Unknown Medicine',
//   //             'instruction': item['notificationTime'],
//   //             'pillCount': 'Take 1 pill(s)',
//   //             'color': colors[index % colors.length], // Assign color based on index
//   //             'medicine_timetableID': item['medicine_timetableID'],
//   //           };
//   //         })).where((medicine) => medicine['name'] != null).toList();
//   //       } else {
//   //         showFlushbar(context, data['message'], Colors.red);
//   //         return [];
//   //       }
//   //     } else {
//   //       showFlushbar(context, 'Failed to fetch data', Colors.red);
//   //       return [];
//   //     }
//   //   } catch (e) {
//   //     showFlushbar(context, 'Error: $e', Colors.red);
//   //     return [];
//   //   }
//   // }
//
//   Future<List<Map<String, dynamic>>> fetchMedicineSchedule(BuildContext context) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String? userId = preferences.getString('userID');
//     final url = AppUrl.notifyMedicineSchedule;
//
//     final List<Color> colors = [
//       AppColors.homecardcolor1,
//       AppColors.homecardcolor2,
//       AppColors.homecardcolor3,
//       AppColors.homecardcolor4,
//       AppColors.homecardcolor5,
//       AppColors.homecardcolor6,
//       AppColors.homecardcolor7,
//       AppColors.homecardcolor8,
//       AppColors.homecardcolor9,
//       AppColors.homecardcolor10,
//     ];
//
//     final Map<String, String> medicineTypeImages = {
//       'Pills': 'assets/images/medicine.png',
//       'Syringe': 'assets/images/syringe.png',
//       'Syrup': 'assets/images/syrup.png',
//       'Ointment': 'assets/images/ointment.png',
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({"userid": int.parse(userId.toString())}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('medicine $data');
//         if (data['success']) {
//           final dateFormat = DateFormat('dd/MM/yyyy, hh:mm:ss a'); // Adjust format to match your date string
//
//           return List<Map<String, dynamic>>.from(data['notifications'].asMap().entries.map((entry) {
//             int index = entry.key;
//             var item = entry.value;
//
//             String? medicineType = item['medicine_type'];
//             String image = medicineTypeImages[medicineType] ?? 'assets/images/default_medicine.png';
//
//             // Parse and format the date
//             DateTime date;
//             try {
//               date = dateFormat.parse(item['notificationDateTimeISO']);
//             } catch (e) {
//               date = DateTime.now(); // Fallback if parsing fails
//             }
//
//             String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);
//
//             return {
//               'name': item['medicine'] ?? 'Unknown Medicine',
//               'instruction': formattedDate,
//               'pillCount': 'Take 1 pill(s)',
//               'color': colors[index % colors.length],
//               'medicine_timetableID': item['medicine_timetableID'],
//               'image': image,
//             };
//           })).where((medicine) => medicine['name'] != null).toList();
//         } else {
//           showFlushbar(context, data['message'], Colors.red);
//           return [];
//         }
//       } else {
//         showFlushbar(context, 'Failed to fetch data', Colors.red);
//         return [];
//       }
//     } catch (e) {
//       showFlushbar(context, 'Error: $e', Colors.red);
//       return [];
//     }
//   }
//
//
//   String getMealPeriod() {
//     final currentTime = DateTime.now();
//     final currentHours = currentTime.hour;
//
//     if (currentHours >= 5 && currentHours < 11) {
//       return "Morning";
//     } else if (currentHours >= 11 && currentHours < 17) {
//       return "lunch";
//     } else if (currentHours >= 17 && currentHours < 24) {
//       return "dinner";
//     } else {
//       return "Night"; // Optional: handle times between 12 AM - 5 AM
//     }
//   }
//
//   Future<void> changeStatus(int timetableId, String status, String takenStatus) async {
//     final url = AppUrl.statusChanging; // Your API URL for changing status
//     final takenTime = getMealPeriod(); // Get the meal period based on current time
//
//     try {
//
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       String? userID = preferences.getString('userID');
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           "userId": int.parse(userID.toString()),
//           "timetableId": timetableId,
//           "status": status,
//           "takenTime": takenTime, // Pass meal period as takenTime
//           "takenStatus": takenStatus,  // Assuming takenStatus matches the status
//         }),
//       );
//       print(takenTime);
//
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('Aaa $data');
//         if (data['success']) {
//           showFlushbar(context, 'Status updated to $status', Colors.green);
//         } else {
//           showFlushbar(context, 'Failed to update status: ${data['message']}', Colors.red);
//         }
//       } else {
//         showFlushbar(context, 'Failed to update status', Colors.red);
//       }
//     } catch (e) {
//       showFlushbar(context, 'Error: $e', Colors.red);
//     }
//   }
//
//   void showFlushbar(BuildContext context, String message, Color color) {
//     Flushbar(
//       message: message,
//       duration: Duration(seconds: 3),
//       backgroundColor: color,
//       flushbarPosition: FlushbarPosition.TOP,
//     ).show(context);
//   }
//
//   // Future<void> changeStatus(int timetableId, String status, String takenTime) async {
//   //   final url = AppUrl.statusChanging; // Your API URL for changing status
//   //   try {
//   //     SharedPreferences preferences = await SharedPreferences.getInstance();
//   //     String? userID = preferences.getString('userID');
//   //     final response = await http.post(
//   //       Uri.parse(url),
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: json.encode({
//   //         "userId": int.parse(userID.toString()),
//   //         "timetableId": timetableId,
//   //         "status": status,
//   //         "takenTime": takenTime,
//   //         "takenStatus": status, // Assuming takenStatus matches the status
//   //       }),
//   //     );
//   //     print(takenTime);
//   //
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       if (data['success']) {
//   //         showFlushbar(context, 'Status updated to $status', Colors.green);
//   //       } else {
//   //         showFlushbar(context, 'Failed to update status: ${data['message']}', Colors.red);
//   //       }
//   //     } else {
//   //       showFlushbar(context, 'Failed to update status', Colors.red);
//   //     }
//   //   } catch (e) {
//   //     showFlushbar(context, 'Error: $e', Colors.red);
//   //   }
//   // }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.pageColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.pageColor,
//         automaticallyImplyLeading: false,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CircleAvatar(
//               child: IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => EditProfilePage()),
//                   );
//                 },
//                 icon: Icon(Icons.person_2_outlined),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text("Hi,", style: text60022bla),
//                   SizedBox(width: 9),
//                   InkWell(
//                       onTap: (){
//
//                       },
//                       child: Text(userName, style: text60022bla)),
//                 ],
//               ),
//
//               SizedBox(height: 15),
//               Text("Today’s Medicine", style: text60031black),
//               Text("Reminder", style: text60031black),
//               SizedBox(height: 35),
//         FutureBuilder<List<Map<String, dynamic>>>(
//           future: futureMedicines,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('No medicines for today.'));
//             } else {
//               final medicines = snapshot.data!;
//               return SizedBox(
//                 height: MediaQuery.of(context).size.height - 10,
//                 child: Stack(
//                   children: List.generate(medicines.length, (index) {
//                     final reversedIndex = medicines.length - 1 - index;
//                     final medicine = medicines[reversedIndex];
//
//                     String notificationTime = medicine['instruction'];
//                     print('Before conversion: $notificationTime');
//
//                     // Adjust the format to match the structure of `instruction`.
//                     DateTime medTakingTime;
//                     try {
//                       medTakingTime = DateFormat('dd/MM/yyyy, hh:mm:ss a').parse(notificationTime);
//                     } catch (e) {
//                       print('Date parsing error: $e');
//                       medTakingTime = DateTime.now(); // Fallback in case of parsing error
//                     }
//
//                     print('Converted DateTime: $medTakingTime');
//
//                     return Positioned(
//                       top: reversedIndex * 20.0,
//                       left: 0,
//                       right: 0,
//                       child: buildDismissibleCard(
//                         index: index,
//                         totalCards: medicines.length,
//                         color: medicine['color'],
//                         medicineName: medicine['name'].toString(),
//                         instruction: notificationTime, // Display the original formatted string
//                         pillCount: medicine['pillCount'].toString(),
//                         timetableId: medicine['medicine_timetableID'],
//                         image: medicine['image'],
//                         medTakingtime: medTakingTime, // Pass the parsed DateTime
//                       ),
//                     );
//                   }),
//                 ),
//               );
//             }
//           },
//         )
//
//
//         ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDismissibleCard({
//     required Color color,
//     required String medicineName,
//     required String instruction,
//     required String pillCount,
//     required int timetableId,
//     required int index,
//     required int totalCards,
//     required String image,
//     required DateTime medTakingtime
//   }) {
//     if (index == totalCards - 1) {
//       return Dismissible(
//         key: UniqueKey(),
//         background: swipeBackground(Colors.green, Alignment.centerLeft, 'Taken'),
//         secondaryBackground: swipeBackground(Colors.red, Alignment.centerRight, 'Skipped'),
//         onDismissed: (direction) {
//           String status = direction == DismissDirection.startToEnd ? 'Taken' : 'Skipped';
//           String takenTime = DateFormat.jm().format(DateTime.now());
//           String takenStatus = direction == DismissDirection.startToEnd ? 'Yes' : 'No';
//           changeStatus(timetableId, status, takenStatus);
//         },
//         child: buildCardContent(color, medicineName, instruction, pillCount, image),
//       );
//     } else {
//       return buildCardContent(color, medicineName, instruction, pillCount, image);
//     }
//   }
//
//   Widget swipeBackground(Color color, Alignment alignment, String label) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         color: color,
//         alignment: alignment,
//         padding: alignment == Alignment.centerLeft ? EdgeInsets.only(left: 20) : EdgeInsets.only(right: 20),
//         child: Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
//       ),
//     );
//   }
//
//   Widget buildCardContent(Color color, String medicineName, String instruction, String pillCount, String image) {
//     return Stack(
//       children: [
//         Container(
//           height: 180,
//           margin: EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(9),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset(image.isNotEmpty ? image : 'assets/images/medicine.png'),
//                     ],
//                   ),
//                   Text(medicineName, style: text60022),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Image.asset('assets/icons/calendar-day.png', height: 15, width: 15),
//                       SizedBox(width: 10),
//                       Text(instruction, style: text50014),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Image.asset('assets/icons/info (2).png', height: 15, width: 15),
//                       SizedBox(width: 10),
//                       Text(pillCount, style: text50014  ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 10,
//           right: 10,
//           child: Image.asset(
//             'assets/images/doctor.png',
//             height: 100,
//             width: 100,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // void changeStatus(int timetableId, String status, String takenStatus) {
//   //   // Implementation for changing the status, e.g., updating a database or API
//   // }
//
//
// }