import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
                "Password reset email sent. Please check your email."),
          );
        },
      );
    } on FirebaseAuthException catch(e){
     print(e);
     showDialog(
         context: context,
         builder: (context){
           return AlertDialog(
             content: Text(e.message.toString()),
           );
         });
    }
    /*on FirebaseAuthException catch(e){
     if(e.code == 'user-not-found'){
       print(e);
       showDialog(
         context: context,
         builder: (context){
           return AlertDialog(
             content: Text(e.message.toString()),
           );
         },
       );
     } else{
       // handle other firebaseauth errors
       showDialog(
           context: context,
           builder: (context){
             return AlertDialog(
               content: Text(e.message.toString()),
             );
           },
       );
     }

   } */
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF00008B),
        appBar: AppBar(
          backgroundColor: const Color(0xFF00008B),
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Enter your Email, we will send the password reset link",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xF6F5F5FF),
                  ),
                ),
                textAlign: TextAlign.center,
              ),

            ),
            const SizedBox(height:20 ),

            //Email TextField
            Center(
              child: Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.deepPurple[800],
                    filled: true,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                      color: Color(0xF6F5F5FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: (){
                  passwordReset();
                },
              ),
            ),
          ],
        )
    );
  }
}
