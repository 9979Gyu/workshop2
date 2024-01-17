import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthGoogle{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Function to handle sign in with google account
  Future<bool> signInWithGoogle(String role) async {
    bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
        await _auth.signInWithCredential(credential);

      User? user = userCredential.user;


      if(user != null) {

        int id;
        if (userCredential.additionalUserInfo!.isNewUser) {
          // GET NEW USER ID
          int newUserId = await generateNewUserId();
          // Add data to db
          await _firestore.collection('users').doc(user.uid).set({
            'username': user.displayName,
            'name': user.displayName,
            'email': user.email,
            'profilePictureUrl': user.photoURL,
            'IDuser': newUserId,
            'birthday': "",
            'role': role,
            'status' : 1
          });
          id = newUserId;
        }
        else{
          id = await getIDUserByEmail(userCredential.user!.email!);
        }
        result = true;
        OneSignal.login(id.toString());
      }
      // OneSignal login

      return result;

    }
    catch (e) {
      print('Failed to login with gmail: $e');
      return result;
    }
  }

  Future<int> getHighestUserId() async {
    QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('IDuser', descending: true)
        .limit(1)
        .get();

    if (users.docs.isNotEmpty) {
      // Parse the IDuser as an integer and return
      return users.docs.first['IDuser'];
    } else {
      // No existing users, return a default value or handle accordingly
      return 0;
    }
  }

  Future<int> generateNewUserId() async {
    int highestUserId = await getHighestUserId();
    int newUserId = highestUserId + 1;
    return newUserId;
  }

  Future<int> getIDUserByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> users = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (users.docs.isNotEmpty) {
        return users.docs.first['IDuser'];
      }
      else {
        return 0;
      }
    }
    catch (e) {
      print('Error fetching IDuser by email: $e');
      return 0;
    }
  }


}