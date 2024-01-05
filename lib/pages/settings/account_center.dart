import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:glaucotalk/pages/settings/change_password.dart';
import 'package:google_fonts/google_fonts.dart';


class SettingPageUI extends StatefulWidget {
  const SettingPageUI({super.key});

  @override
  _SettingPageUIState createState() => _SettingPageUIState();
}

class _SettingPageUIState extends State<SettingPageUI> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
            "Account",
            style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                fontSize: 25,
                color: myTextColor,
                  fontWeight: FontWeight.bold,
                ),),),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
            MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 40),
              Row(
              children: [
                const Icon(
                  Icons.person_3_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 30),
                Text(
                    "Account Center",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: myTextColor,
                      fontWeight: FontWeight.bold,
                    ),),),
              ],
            ),
            const Divider(height: 40, thickness: 4),
            const SizedBox(height: 10),
            buildAccountOption(
                context, "Change Password"),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context)
                => const ChangePasswordScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                title,
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: myTextColor,
                    fontWeight: FontWeight.bold,
                  ),),),
            const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white)
          ],
        ),
      ),
    );
  }
}