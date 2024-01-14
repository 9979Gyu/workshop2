import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:glaucotalk/authorization/user/login_user.dart';
import 'package:glaucotalk/database/notification/notification_service.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:glaucotalk/pages/main_menu.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  // static final notifications = NotificationsService();

  Future<String> getHighestUserId() async {
    QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('IDuser', descending: true)
        .limit(1)
        .get();

    if (users.docs.isNotEmpty){
      return users.docs.first['IDuser'];
    } else {
      // No existing users, return a default value or handle accordingly
      return '0';
    }
  }

  Future<String> generateNewUserId() async {
    String highestUserId = await getHighestUserId();
    int newUserId = int.parse(highestUserId) + 1;
    return newUserId.toString();
  }

  // User register method
  void userSignUp() async {
    // Show loading circle
    showDialog(
      context: context,
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

        // Back up yg before
        // await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        //   'name': nameController.text,
        //   'email': emailController.text,
        //   'password': passwordController.text,
        //   'birthday': dateController.text,
        //   'username': usernameController.text,
        //   'role': 'user',
        //   'status' : 1,
        // });

        // Create a new document in Firestore for the users with new user ID

        // GET NEW USER ID
        String newUserId = await generateNewUserId();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'IDuser': newUserId,
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'birthday': dateController.text,
          'username': usernameController.text,
          'role': 'user',
          'status' : 1,
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

      // baru add
      // await notifications.requestPermission();
      // await notifications.getToken();

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Dismiss the loading dialog
      showErrorMessage(e.message ?? "An unknown error occurred");
    } catch (e) {
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
      backgroundColor: myCustomColor,
      appBar: AppBar(
        backgroundColor: myCustomColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
              Icons.home,
              color: Colors.white
          ),
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
                  width: 150,
                  height: 150,
                ),

                Text(
                  'Welcome to our app !',
                  style: TextStyle(
                    color: myTextColor,
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
                      fillColor: Colors.deepPurple,
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
                      fillColor: Colors.deepPurple,
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
                      fillColor: Colors.deepPurple,
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
                      fillColor: Colors.deepPurple,
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
                      fillColor: Colors.deepPurple,
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
                      fillColor: Colors.deepPurple,
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
                      backgroundColor: Colors.deepOrangeAccent,
                      elevation: 10,
                      shape: const StadiumBorder(),
                    ),

                    child: const Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Color(0xF6F5F5FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      userSignUp();
                    },
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(width: 4),

                    TextButton(
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 20,
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              onTap: () {},
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