import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/firebase_options.dart';
import 'package:glaucotalk/notification/noti.dart';

import '../api/firebase_api.dart';
import 'package:glaucotalk/notification/home_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  // A constructor for the MyApp class.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disables the debug banner in the top-right corner.

      home: HomePage(),  // Sets the home screen of the app to an instance of the HomePage class.

      navigatorKey: navigatorKey,  // Uses a global key for the navigator, which allows you to navigate without using context.

      routes: {
        '/notification_screen': (context) => const NotiPage(),  // Defines named routes. '/notification_screen' leads to an instance of NotiPage.
      },
    );
  }
}