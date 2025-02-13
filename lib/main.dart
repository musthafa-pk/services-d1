
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upgrader/upgrader.dart';
import 'Dr1/SplashDoctorOne.dart';
import 'firebase_options.dart';

// Background message handler (runs when the app is terminated or in the background)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

 void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // Register background handler
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'doctorOne',
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'AeonikTRIAL'
      ),
      // home:Homepage()
      home:UpgradeAlert(
          child: MainSplashScreenDocOne()
          // child: Menupage()
      )
      // home:DroneBottomNavigation()
    );
  }
}
