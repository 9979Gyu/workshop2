// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:glaucotalk/pages/chat_page.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationsService {
//   static const key = 'AAAALr-80oA:APA91bH3KnrOeDXzATGSMBLxKsn3cAwimvv2iYkNBm3fK7b3iaVY_OK6nHDqR9i3PZrz9qur7gm8Y9ajYn1aGRbsQPyWA7NLQ7a_AAVKwQGct0orypxxVRFCADJ1uCusvLOvByM4NEZB';
//
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   void _initLocalNotification(){
//
//     const androidSettings = AndroidInitializationSettings(
//         '@mipmap/ic_launcher'
//     );
//
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestCriticalPermission: true,
//       requestSoundPermission: true,
//     );
//
//     const initializationSettings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings
//     );
//
//     flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse:(response) {
//           debugPrint(response.payload.toString());
//         });
//   }
//
//   Future<void> _showLocalNotification (RemoteMessage message) async {
//
//     final styleInformation = BigTextStyleInformation(
//       message.notification!.body.toString(),
//       htmlFormatBigText: true,
//       contentTitle: message.notification!.title,
//       htmlFormatTitle: true,
//     );
//
//     final androidDetails = AndroidNotificationDetails(
//         'com.example.apptalk.urgent',
//         'mychannelid',
//         importance: Importance.max,
//         styleInformation: styleInformation,
//         priority: Priority.max
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//     );
//
//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload: message.data['body']
//     );
//   }
//
//   Future<void> requestPermission() async {
//     final messaging = FirebaseMessaging.instance;
//
//     final settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       debugPrint('User granted provisional permission');
//     } else {
//       debugPrint('User declined or has not accepted permission');
//     }
//   }
//
//   Future<void> getToken() async {
//     final token = await FirebaseMessaging.instance.getToken();
//     _saveToken(token!);
//   }
//
//   Future<void> _saveToken(String token) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .set({'token':token}, SetOptions(merge: true));
//   }
//
//   String receiverToken ='';
//
//   Future<void> getReceiverToken (String? receiverId) async {
//     final getToken = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(receiverId)
//         .get();
//
//     if (getToken.exists) {
//       receiverToken = await getToken.data()!['token'] ?? '';
//     } else {
//       debugPrint('token does not exist');
//     }
//   }
//
//   void firebaseNotification(DocumentSnapshot document, context){
//     _initLocalNotification();
//
//     FirebaseMessaging.onMessageOpenedApp
//         .listen((RemoteMessage message) async {
//       Map<String, dynamic> data = message.data;
//
//           await Navigator.of((context).push(
//             MaterialPageRoute(
//               builder: (_) => ChatPage(
//                 receiverName: data['name'] ?? '',
//                 receiverIDuser: data['IDuser'] ?? '',
//                 receiverUserID: document.id,
//                 senderprofilePicUrl: data['profilePicUrl'] ?? '',),
//           ),
//           ),
//           );
//     });
//
//     FirebaseMessaging.onMessage
//         .listen((RemoteMessage message) async {
//       await _showLocalNotification(message);
//     });
//   }
//
//   Future<void> sendNotification(
//       {required String body,
//         required String senderId}) async {
//     try {
//       await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'key=$key',
//         },
//         body: jsonEncode(<String, dynamic>{
//           "to": receiverToken,
//           "priority": 'high',
//           'notification': <String, dynamic>{
//             'body': body,
//             'title': 'New Message !',
//           },
//           'data': <String, String>{
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'status': 'done',
//             'senderId': senderId,
//           }
//         }),
//       );
//     } catch (e){
//       debugPrint(e.toString());
//     }
//   }
// }