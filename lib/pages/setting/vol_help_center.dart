import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:glaucotalk/pages/setting/contact_us.dart';
import 'package:glaucotalk/pages/setting/feedback_page.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:glaucotalk/pages/setting/vol_contact_us.dart';
import 'package:glaucotalk/pages/setting/vol_feedback.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../volunteer_homepage.dart';


class VolHelpCenter extends StatefulWidget {
  const VolHelpCenter({super.key});

  @override
  State<VolHelpCenter> createState() => _VolHelpCenterState();
}

class _VolHelpCenterState extends State<VolHelpCenter> {
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
          "Help",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(

                fontSize: 22,
                fontWeight: FontWeight.w600),
          ),),
        leading: IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VolHomePage())
            );
          },
          icon: const Icon(
            Icons.arrow_back,

          ),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(18),
        child:  ListView(
          children: [
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.live_help_rounded,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10,height: 30,),
                Text(
                  "Help Center",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(

                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),),
              ],
            ),
            const Divider(

              height: 40,
              thickness: 4,
            ),
            const SizedBox(height: 20,),
            buildAccountOption(context, "Contact Us"),
            const SizedBox(height: 20,),
            buildFeedbackOption(context, "Send Feedback"),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const VolContactUsScreen()),
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

            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildFeedbackOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const VolFeedbackPage()),
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