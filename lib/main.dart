import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glaucotalk/database/auth_service.dart';
import 'package:glaucotalk/pages/setting/Notification%20page/local_notifications.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'database/firebase_api.dart';
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'pages/MySplashPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  await LocalNotifications.init();
  await FirebaseMessaging.instance.getInitialMessage();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(), // Make sure MyApp is a descendant of MultiProvider
    ),
  );
}


class MyApp extends StatefulWidget {
  // final CameraDescription camera;

  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("ec829f71-6de7-44d6-9dca-1a648cef4f22");

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MySplashPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

