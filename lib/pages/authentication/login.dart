import 'package:workshop2/pages/password/forgot_password.dart';
import 'package:workshop2/pages/home_page.dart';
import 'package:workshop2/pages/main_menu.dart';
import 'package:workshop2/pages/authentication/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatefulWidget {

  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
  String email ="";
  String password = "";
  String displayName = "";

  bool isPasswordVisible = false;

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // user login method
  void userLogin() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //final authService = Provider.of<AuthService>(context, listen: false);

    // try login
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // pop loading circle before user logged in
      Navigator.pop(context);

      // Saving data to shared preferences after successful login
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', emailController.text.trim());


      // Navigate to HomePage after successfully login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  HomePage(),
        ),
      );
    }
    catch (e) {
      // Dismiss the loading dialog in case of an error
      Navigator.pop(context);

      if (e is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Firebase Auth Error: ${e.message}"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("General Error: ${e.toString()}"),
          ),
        );
      }
    }
  }

  // show error message to user
  void showErrorMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo,
          title:  Text('Login Failed',
            style: TextStyle(color: myTextColor),),
          content:  Text('Invalid username or password',
            style: TextStyle(color: myTextColor),),
          actions: [
            TextButton(
              child: const Text('OK',
                  style: TextStyle(color: Colors.white)),
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
      appBar: AppBar(
        backgroundColor: myCustomColor,
        leading: IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.white,),
          iconSize: 40,
          onPressed: (){
            Navigator.of(
                context).push(
                MaterialPageRoute(
                    builder: (context)=> const MainMenu())
            );
          },
        ),
      ),
      backgroundColor: myCustomColor,
      // safe area of the screen - guarantee visible to user
      body: SafeArea(
        //child: Center(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              // allign everything to the middle of the screen
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const SizedBox(height: 50),
                // logo
                Image.asset("assets/logo.png",
                  width: 200,
                  height: 200,),
                //const SizedBox(height:2),

                // text under the lock icon
                Text(
                  'L O G I N',
                  style: GoogleFonts.passionOne(
                    textStyle: const TextStyle(
                      //color: Colors.white,
                        color: Color(0xF6F5F5FF),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
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
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.white,),
                      fillColor: Colors.deepPurple,
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
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
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
                      fillColor: Colors.deepPurple,
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
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xF6F5F5FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                        backgroundColor: Colors.deepOrangeAccent,
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
                      userLogin();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  HomePage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                /*
                // other login method
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Color(0xF6F5F5FF),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.deepOrange[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // google + fb login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        onTap: () async{
                          final user = await AuthService().signInWithGoogle();
                          if (user != null && mounted){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => HomePage()));
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error signing in with Google'),
                              ),
                            );
                          }
                        },
                        imagePath: 'lib/images/google.png'),



                    const SizedBox(width: 10.0),

                    // facebook button
                    SquareTile(
                        onTap: (){},
                        imagePath: 'lib/images/facebook.png'),

                  ],
                ),
                */
                const SizedBox(height: 25),

                // doesn't have an account
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?',
                      style: TextStyle(
                          color: Color(0xF6F5F5FF),
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage(onTap: (){}),)
                        );
                      },
                      child:  Text(
                        'Create Account',
                        style: GoogleFonts.passionOne(
                          textStyle: const TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
