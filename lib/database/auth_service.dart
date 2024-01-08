import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/main_menu.dart';

import '../authorization/user/login_user.dart';
import '../authorization/volunteer/login_volunteer.dart';
import 'database_service.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  //bool isEmailVerified = _auth.currentUser?.isEmailVerified ?? false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // getUserRole function
  Future<String?> getUserRole() async {
    final User? user = _auth.currentUser;

    if(user != null) {
      try{
        // get the user's token claims, which may include the 'role' claims
       DocumentSnapshot userDoc = await _firestore
           .collection('users')
           .doc(user.uid)
           .get();

       if(userDoc.exists){
         Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
         return userData['role'] as String?;
       }
       else {
         return null;
       }
      }
      catch(e){
        print('Error retrieving user role: $e');
        return null;
      }
    }
    return null;
  }

  //Sign In
  Future<User?> signInWithEmailandPassword(BuildContext context, String email, String password) async {
    try {
      // sign in
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email:email ,
          password:password
      );
      // After successful sign-in, retrieve the user role
      String? userRole = await getUserRole();
      handleLoginSuccess(context, userRole);

      return userCredential.user;

    }
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  void handleLoginSuccess(BuildContext context, String? userRole) async {

    if (userRole == 'user'){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(onTap: (){}),)
      );
      // navigate to the login
    }
    else if (userRole == ' volunteer'){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginVol(),)
      );
      // Navigate to the login
    }
    else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainMenu(),)
      );
      // Handle the case where the user does not have the role
      //  show a generic dashboard or display an error message.
    }
  }

  Future<void> verifyEmail() async {
    final User? user = _auth.currentUser;
    if(user != null){
      await user.sendEmailVerification();
      print('Email verification sent to ${user.email}');
    } else{
      print("No user currently signed in");
    }
  }

  //Register
  Future <User?> registerUserWithEmailandPassword(String name, String email,
      String password, String username, DateTime birthday, String role) async {
    try {

      // Check if all required fields are provided
      if (name.isEmpty || email.isEmpty || password.isEmpty || username.isEmpty) {
        throw Exception('All fields are required');
      }

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //user.uid;

      // call our database service to update the user data
      await DatabaseService().updateUserData(name, email, password, username, birthday, role);

      // After creating user, create a new document for the users in user collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'username' : username,
        'birthday' : birthday,
        'role' : role,
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error during registration: ${e.message}");
      return null;
    }
  }
  Future<void> signOut()async{
    return await FirebaseAuth.instance.signOut();
  }
}