import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VolChangePasswordScreen extends StatefulWidget {
  const VolChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _VolChangePasswordScreenState createState() => _VolChangePasswordScreenState();
}

class _VolChangePasswordScreenState extends State<VolChangePasswordScreen> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  String? passwordError;

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      _showSnackBar('Password is required.');
      return false;
    }
    if (password.length < 8) {
      _showSnackBar('Password must be at least 8 characters long.');
      return false;
    }
    // Add more password validation rules as needed
    return true;
  }

  void _changePassword() async {
    String oldPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;

    if (!_formKey.currentState!.validate() || !_validatePassword(newPassword)) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);

        // Update the password field in Firestore
        FirebaseFirestore.instance
            .collection('users') // Replace with your Firestore collection name
            .doc(user.uid) // Assuming each document is identified by the user's UID
            .update({'password': newPassword});

        _showSnackBar('Password changed successfully.');

        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // Navigate to home page after successful password change
        Navigator.pop(context); // Remove the current screen from the navigation stack
      } catch (e) {
        _showSnackBar('Error changing password. Please try again.');
        print('Error: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isNightMode = Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your new password must be different \nfrom your previous password.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Current Password',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _currentPasswordController,
                        maxLines: 1,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Your Current password',
                          hintStyle: const TextStyle(color: Color(0xFF6f6f6f)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: (){
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          counterText: '',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              width: 2.0,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password.';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'New Password',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        maxLines: 1,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Your New Password',
                          hintStyle: const TextStyle(color: Color(0xFF6f6f6f)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: (){
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          counterText: '',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              width: 2.0,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (!_validatePassword(value ?? '')) {
                            return 'Password must be at least 8 characters long.';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        maxLines: 1,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Re-type new password',
                          hintStyle: const TextStyle(color: Color(0xFF6f6f6f)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: (){
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          counterText: '',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              width: 2.0,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please re-type your new password.';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent[700],
                          elevation: 10,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            color: myTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          _changePassword();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
