import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:glaucotalk/main.dart';

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

    initPushNotifications();
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message){
    if(message == null){
      return;
    }

    // navigate to home page when user tap notifications
    navigatorKey.currentState?.pushNamed(
      '/login',
      arguments: message,
    );
  }

  // function to initialize foreground and background settings
  Future initPushNotifications() async {
    //   handle notifications if app is terminated and now open
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // event listener for when a notifications open the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

}