import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glaucotalk/autherization/user/login_user.dart';
import 'package:glaucotalk/yt/screen/chats.dart';
import 'package:glaucotalk/yt/screen/people.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final CameraDescription camera;

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  CupertinoApp(
      home: HomeScreen(),
      theme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.deepOrange)
    );
  }
}

class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);

   var screens =  [const Chats(), People()];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(
              label: "Chats",
                icon: Icon(
                  CupertinoIcons.chat_bubble_2_fill,),
            ),
            BottomNavigationBarItem(
              label: "Status",
              icon: Icon(
                CupertinoIcons.smiley_fill,),
            ),
            BottomNavigationBarItem(
              label: "Capture",
              icon: Icon(
                CupertinoIcons.camera_fill,),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index){
          return screens[index];
        },
      ),
    );
  }
}

