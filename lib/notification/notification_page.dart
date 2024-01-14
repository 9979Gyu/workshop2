import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import '../main.dart';
import 'constant.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('A bg message just showed up :  ${message.messageId}');
}
//
// void handleMessage(RemoteMessage? message) {
//   if (message == null) {
//     return;
//   }
//
//   // Navigate to home page when user taps notifications
//   navigatorKey.currentState?.pushNamed(
//     '/login',
//     arguments: message,
//   );
// }
//
// Future<void> initPushNotifications() async {
//   // Handle notifications if the app is terminated and now open
//   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//
//   // Event listener for when a notification opens the app
//   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // await initPushNotifications(); // Initialize push notifications

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late TextEditingController _textToken;
  late TextEditingController _textSetToken;

  @override
  void dispose() {
    _textToken.dispose();
    _textSetToken.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _textToken = TextEditingController();
    _textSetToken = TextEditingController();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  // icon: '@mipmap/ic_launcher'
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Notifications'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textToken,
                      decoration: InputDecoration(
                          enabled: false,
                          labelText: "My Token for this Device"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                            new ClipboardData(text: _textToken.text));
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  _textToken.text = await token();
                },
                child: Text('Get Token'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _textSetToken,
                decoration: InputDecoration(labelText: "Enter Token"),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (_textSetToken.text.isNotEmpty) {
                          pushNotificationsSpecificDevice(
                            title: "You have a new Message",
                            body: "Somebody",
                            token: _textSetToken.text,
                          );
                        }
                      },
                      child: Text('Send Notification for specific Device'),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: showNotification,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  Future<bool> pushNotificationsSpecificDevice({
    required String token,
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{ "to" : "$token",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    await http.post(
      Uri.parse(Constant.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constant.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    return true;
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                // icon: '@mipmap/ic_launcher'
            )
        )
    );
  }
}