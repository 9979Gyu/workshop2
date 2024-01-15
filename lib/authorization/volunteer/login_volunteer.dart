import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/authorization/controller/AuthGoogle.dart';
import 'package:glaucotalk/authorization/forgot_password.dart';
import 'package:glaucotalk/authorization/volunteer/register_volunteer.dart';
import 'package:glaucotalk/pages/main_menu.dart';
import 'package:glaucotalk/pages/volunteer_homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginVol extends StatefulWidget {


  const LoginVol({super.key});

  @override
  State<LoginVol> createState() => _LoginVolState();
}

class _LoginVolState extends State<LoginVol> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
  String email = "";
  String password = "";
  bool isPasswordVisible = false;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthGoogle _authGoogle = AuthGoogle();

  // user login method
  void volunteerLogin() async {
    // Loading
    showDialog(
      context: context,
      barrierDismissible: false, //prevent dialog from closing on touch outside
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try login
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();


      if (userDoc.exists && userDoc['role'] == 'volunteer') {
        // Saving data to shared preferences after successful login
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailController.text);
        await prefs.setString('role', userDoc['role']); // Save the user's role

        String id = userDoc['IDuser'];// Assuming userId is a String

        // OneSignal login
        OneSignal.login(id);

        // Close the loading dialog
        Navigator.of(context).pop();

        // Navigate to HomePage after successfully login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VolHomePage(),
          ),
        );
      } else {
        // User does not have the 'volunteer' role, show an error message
        Navigator.pop(context);
        showErrorMessage(
            'You do not have the necessary permissions to log in as a volunteer.');
        return;
      }
    } on FirebaseAuthException catch(e){
      Navigator.of(context).pop();
      showErrorMessage(e.message ?? 'Login failed. Please try again');
    } catch(e){
      Navigator.of(context).pop();
      showErrorMessage('Unexpected error occurred. Please try again');
    }
  }

  // show error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo,
          title:  Text(
            'Login Failed',
            style: TextStyle(
                color: myTextColor
            ),
          ),
          content:  Text(
            message,
            style: TextStyle(
                color: myTextColor
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.white
                  )
              ),
              onPressed: () {
                Navigator.pop(context);
                // pop loading circle after show error message
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,),
          onPressed: (){
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (context)=> const MainMenu())
              );
            },
        ),
      ),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                width: 300,
                height: 300
              ),

              Text(
                'L O G I N',
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    //color: Colors.white,
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Text(
                'Volunteer',
                style: GoogleFonts.nunitoSans(
                  textStyle: const TextStyle(
                    //color: Colors.white,
                      color: Colors.black,
                      fontSize: 20,
                     // fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // username textfield
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.white,),
                    fillColor: myCustomColor,
                    filled: true,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), // Text color while typing
                ),
              ),

              const SizedBox(height: 10),

              // password textfield
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: Colors.white,),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: (){
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    fillColor: myCustomColor,
                    filled: true,
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), // Text color while typing
                ),
              ),


              const SizedBox(height: 10),

              // forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return  ForgotPasswordPage();
                            }));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            //color: Colors.white,
                            color: Colors.black,
                            fontSize: 14,
                             fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // log in button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      elevation: 10,
                      shape: const StadiumBorder()
                  ),
                  child:  Text(
                    "Sign In",
                    style: TextStyle(
                        color: myTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: (){
                    volunteerLogin();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  VolHomePage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),
              SignInButton(
                Buttons.google,
                text: "Sign up with Google",
                onPressed: () async {
                  bool result = await _authGoogle.signInWithGoogle("volunteer");

                  if(result){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VolHomePage(),
                      ),
                    );
                  }

                },
              ),
              const SizedBox(height: 25),

              // doesn't have an account
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterVol(),
                          ),
                      );
                    },
                    child:  Text(
                      'Create Account',
                      style: GoogleFonts.heebo(
                        textStyle: TextStyle(
                            color: Colors.deepOrangeAccent[400],
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
