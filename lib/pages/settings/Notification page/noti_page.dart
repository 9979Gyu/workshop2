import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  bool isSwitched = false;
  bool isGroupNotiSwitched = false;
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          " Notifications",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: myTextColor,
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),),
        leading: IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()));
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
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10,height: 30,),
                  Text(
                    "Message Notification",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: myTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),),
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
                          color: myTextColor,
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
                          });
                        }),
                ],
              ),),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text("Sound",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: myTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 215,),
                    IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,),
                        onPressed: (){},
                    ),
                  ],
                ),),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10,height: 30,),
                  Text(
                    "Group Notification",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: myTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),),
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
                            color: myTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 100,),
                    Switch(
                        value: isGroupNotiSwitched,
                        onChanged: (value){
                          setState(() {
                            isGroupNotiSwitched = value;
                          });
                        }),
                  ],
                ),),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text("Sound",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: myTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 215,),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.white,),
                      onPressed: (){},
                    ),
                  ],
                ),),

            ],
          ),


        ),


     // ),
    );
  }
}
