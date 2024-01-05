import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/autherization/volunteer/login_volunteer.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:glaucotalk/pages/main_menu.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterVol extends StatefulWidget {
  const RegisterVol({super.key});

  @override
  State<RegisterVol> createState() => _RegisterVolState();
}

class _RegisterVolState extends State<RegisterVol> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  // Text editing controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dateController = TextEditingController();
  final usernameController = TextEditingController();
  String? passwordError;
  String? emailError;
  bool isPasswordVisible = false;

  // User register method
  void volSignUp() async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Try to register the user
    try {
      // Validate the email address
      emailError = validateEmail(emailController.text);
      if (emailError != null) {
        showErrorMessage(emailError!);
        return; // Don't proceed with registration if the email is invalid
      }

      // Validate the password
      passwordError = validatePassword(passwordController.text);
      if (passwordError != null) {
        showErrorMessage(passwordError!);
        return; // Don't proceed with registration if the password is invalid
      }

      // Check if password entered is the same
      if (passwordController.text == confirmPasswordController.text) {
        // Create a new user in Firebase authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Create a new document in Firestore for the users
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'birthday': dateController.text,
          'username': usernameController.text,
          'role': 'volunteer',
        });

        // Show success message or navigate to homepage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        showErrorMessage("The passwords do not match");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Dismiss the loading dialog
      showErrorMessage(e.message ?? "An unknown error occurred");
    }catch (e) {
      Navigator.pop(context); // Dismiss the loading dialog
      showErrorMessage("An unexpected error occurred. Please try again.");
    }
  }

  // Error message
  void showErrorMessage(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Pop loading circle after showing the error message
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool isValidEmail(String email) {
    // Define a regular expression pattern for a valid email address
    final pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';

    // Create a regular expression object
    final regex = RegExp(pattern);

    // Use the regex to match the email address
    return regex.hasMatch(email);
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _selectDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        dateController.text = selected.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
              Icons.home,
              color: Colors.black),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MainMenu(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  "assets/logo.png",
                  width: 200,
                  height: 200,
                ),

                const Text(
                  'Welcome to our app !',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      hintText: 'Name',
                      fillColor: myCustomColor,
                      filled: true,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: usernameController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      hintText: 'Username',
                      fillColor: myCustomColor,
                      filled: true,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),

                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

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
                      fillColor:myCustomColor,
                      filled: true,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),

                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

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
                      fillColor: myCustomColor,
                      filled: true,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
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

                      errorText: passwordError,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: confirmPasswordController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

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

                      hintText: 'Confirm Password',
                      fillColor: myCustomColor,
                      filled: true,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
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
                      errorText: passwordError,

                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: dateController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      hintText: 'Date of Birth',
                      fillColor: myCustomColor,
                      filled: true,
                      suffixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.white),
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),

                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[800],
                      elevation: 10,
                      shape: const StadiumBorder(),
                    ),

                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        color: myTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      volSignUp();
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Log In',
                        style: GoogleFonts.heebo(
                          textStyle: TextStyle(
                              color: Colors.deepOrangeAccent[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginVol(
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one digit';
  }
  return null;
}

