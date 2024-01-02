
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  String? _token;

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {

    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");

    // Retrieve Firebase Installation ID (FID)
    String? fid = await FirebaseMessaging.instance.getToken();
    print("Firebase Installation ID (FID): $fid");


    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Token Example'),
      ),
      body: Center(
        child: Text(_token ?? 'Retrieving FCM token...'),
      ),
    );
  }
}