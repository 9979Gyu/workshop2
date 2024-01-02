
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");


  // updating the userdata
  Future updateUserData(
      String name,
      String email,
      String password,
      String username,
      DateTime birthday) async{

    return await userCollection.doc(uid).set({
      "name": name,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
      "username" : username,
      "birthday" : birthday,
    });
  }
}