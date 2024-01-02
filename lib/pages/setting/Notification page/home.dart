import 'package:workshop2/pages/setting/Notification%20page/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  // @override
  // void initState() {
  //   listenToNotifications();
  //   super.initState();
  // }
  //
  // // to listen to any notification clicked or not
  // listenToNotifications() {
  //   print("Listening to notification");
  //   LocalNotifications.onClickNotification.stream.listen((event) {
  //     print(event);
  //     Navigator.pushNamed(context, '/another', arguments: event);
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar (
        title: Text('Notification Setup',
          style: GoogleFonts.aBeeZee(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.yellow,
            ),
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
              icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black),
                  onPressed: (){
                LocalNotifications.showSimpleNotification(
                    title: "simple notifications",
                    body: "This is simple notifications",
                    payload: "This is simple data"
                  );
                },
                  label: const Text("Simple Notification"),
          ),
        ],
      ),
    );
  }
}
