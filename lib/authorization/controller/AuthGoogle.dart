import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        if (userCredential.additionalUserInfo!.isNewUser) {

          // GET NEW USER ID
          String newUserId = await generateNewUserId();

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
        }
        result = true;
      }
      return result;

    }
    catch (e) {
      print('Failed to login with gmail: $e');
      return result;
    }
  }

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

  // // Function to register user sign in with google account to firestore
  // Future<void> saveUserDataToFirestore(User? user) async {
  //   if (user != null) {
  //     // Reference to the Firestore collection
  //     final CollectionReference usersCollection =
  //     FirebaseFirestore.instance.collection('users');
  //
  //     // Check if the user already exists in Firestore
  //     final userDoc = await usersCollection.doc(user.uid).get();
  //
  //     // GET NEW USER ID
  //     String newUserId = await generateNewUserId();
  //
  //     if (!userDoc.exists) {
  //       // If the user does not exist, add their data to Firestore
  //       await usersCollection.doc(user.uid).set({
  //         'username': user.displayName,
  //         'name': user.displayName,
  //         'email': user.email,
  //         'photoURL': user.photoURL,
  //         'IDuser': newUserId,
  //         'birthday': null,
  //         'role': 'user',
  //         'password': 'abc123',
  //         'status' : 1,
  //       });
  //     }
  //   }
  // }

}