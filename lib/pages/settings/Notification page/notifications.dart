import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var initializationSettingsAndroid =
  const AndroidInitializationSettings('app_icon');
  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Called when the app is in the foreground
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Called when the app is opened from a notification
      // Handle navigation or other app logic
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Handle background messages
  }

  Future<void> _showNotification(RemoteMessage message) async {
    var androidChannelSpecifics = const AndroidNotificationDetails(
      '200785318528',
      'GlaucoTalk',
      importance: Importance.max,
      priority: Priority.high,
    );

    var generalNotificationDetails =
    NotificationDetails(android: androidChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID
      message.notification?.title ?? 'Title',
      message.notification?.body ?? 'Body',
      generalNotificationDetails,
      payload: 'Notification Payload',
    );
  }

  Future<void> sendNotificationToUser(String userUid, String message) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // Retrieve the user's device token from your database
    String userDeviceToken = await getUserDeviceToken(userUid);

    // Create notification message
    final notificationMessage = {
      'notification': {
        'title': 'GlaucoTalk',
        'body': message,
      },
      'to': userDeviceToken,
    };

    // Send the notification using HTTP POST
    Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
        'key=BNjwPn2zN3WKGAeO_KbzMpCGadMr4b-OZQo0eu-GDHJ8CKixCpaxVQKgbvILXxVCOJU6-opI2cPiZm1giKSCRVk', // Replace with your FCM server key
      },
      body: jsonEncode(notificationMessage),
    );
  }

  // Function to handle background messages
  Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
    // Handle background messages
  }

  // Function to retrieve the user's device token from your database
  Future<String> getUserDeviceToken(String userUid) async {
    // Implement this function to retrieve the user's device token
    // You may need to use Firebase Realtime Database or Firestore
    // to store and retrieve the device token associated with the user.
    return ""; // Replace with actual implementation
  }

  @override
  Widget build(BuildContext context) {
    // Your app UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Token Example'),
      ),
      body: const Center(
        child: Text('Retrieving FCM token...'),
      ),
    );
  }
}
