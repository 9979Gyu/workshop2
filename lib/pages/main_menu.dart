import 'package:flutter/material.dart';
import 'package:glaucotalk/authorization/user/login_user.dart';
import 'package:glaucotalk/authorization/volunteer/login_volunteer.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  Color myTextColor = const Color(0xF6F5F5FF);
  Color myCustomColor = const Color(0xFF00008B);

  final userController = TextEditingController();
  final volunteerController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      body: SafeArea(
        //child: Center(
        child: Form(
          child: SingleChildScrollView(
            child: Column(

              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                Image.asset("assets/logo.png",
                  width: 200,
                  height: 200,),
                const SizedBox(height:2),

                Text('Come Join and Have a Chat with Our Community!',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: myTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50,),

                SizedBox(
                  width: 350,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[800],
                      elevation: 20,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "I need virtual assistance",
                      style: TextStyle(color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(onTap: (){},),),);

                    },
                  ),
                ),

                const SizedBox(height: 30,),


                SizedBox(
                  width: 350,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[800],
                      elevation: 20,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "I would like to volunteer",
                      style: TextStyle(color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => LoginVol()
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    //);
  }
}