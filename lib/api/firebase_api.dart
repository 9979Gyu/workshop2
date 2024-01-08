import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:glaucotalk/notification/push_notification.dart';

class FirebaseApi {
  // create instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission();

    // fetch FCM token of the device
    final fcmToken = await _firebaseMessaging.getToken();

    // print token
    print("\nToken: $fcmToken\n");

    // initialize further settings for push noti
    initPushNotifications();
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message){
    if(message == null){
      return;
    }
    else{
      navigatorKey.currentState?.pushNamed(
        '/notification_screen',
        arguments: message,
      );
    }
  }

  // function to initialize foreground and bg settings
  Future initPushNotifications() async {
    // handle notification if the apps wa terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}