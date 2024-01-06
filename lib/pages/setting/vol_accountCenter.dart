import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:glaucotalk/pages/setting/change_password.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:glaucotalk/pages/setting/vol_changePassword.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../volunteer_homepage.dart';


class VolSettingPageUI extends StatefulWidget {
  const VolSettingPageUI({super.key});

  @override
  _VolSettingPageUIState createState() => _VolSettingPageUIState();
}

class _VolSettingPageUIState extends State<VolSettingPageUI> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);


  @override
  Widget build(BuildContext context) {
    bool isNightMode = Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Account",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
              fontSize: 25,

              fontWeight: FontWeight.bold,
            ),),),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VolHomePage()));
          },
          icon: const Icon(
            Icons.arrow_back,

          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.person_3_rounded,
                  color: Colors.blue,

                ),
                const SizedBox(width: 20),
                Text(
                  "Account Center",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 22,

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
              => const VolChangePasswordScreen()),
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

                  fontWeight: FontWeight.bold,
                ),),),
            const Icon(
                Icons.arrow_forward_ios,
                )
          ],
        ),
      ),
    );
  }
}

