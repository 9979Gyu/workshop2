import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:glaucotalk/pages/volunteer_homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class VolNotiPage extends StatefulWidget {
  const VolNotiPage({super.key});

  @override
  State<VolNotiPage> createState() => _VolNotiPageState();
}

class _VolNotiPageState extends State<VolNotiPage> {
  bool isSwitched = false;
  // bool isGroupNotiSwitched = false;
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  int messageNotificationValue = 0;

  // Reference to Firestore collection
  CollectionReference notifications = FirebaseFirestore.instance
      .collection('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Notifications",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),
        ),

        leading: IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VolHomePage()));
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(18),
        //child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notifications_active,
                ),

                const SizedBox(width: 10,height: 30,),

                Text(
                  "Message Notification",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Divider(
              height: 40,
              thickness: 4,
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text("Show Notifications",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 100,),
                  Switch(
                      value: isSwitched,
                      onChanged: (value){
                        setState(() {
                          isSwitched = value;
                          messageNotificationValue = value ? 1: 0; // set 1 if true. else 0

                          // update firestore collection
                          notifications
                              .doc('messageNotification')
                              .set({'value': messageNotificationValue});
                        });
                      }),
                ],
              ),),
          ],
        ),
      ),

    );
  }
}
