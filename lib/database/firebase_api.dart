import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi{
  // Create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notification
Future<void> initNotifications() async{
  // Request permission from user (will prompt the user)
  await _firebaseMessaging.requestPermission();

  // fetch FCM token for this device
  final fCMToken = await _firebaseMessaging.getToken();

  // Print the token (do this to your server normally)
  print('Token: $fCMToken');

}

  // function to handle received messages

  // function to initialize foreground and background settings



}