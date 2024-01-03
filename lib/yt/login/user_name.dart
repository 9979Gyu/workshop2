import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/yt/main.dart';

class UserName extends StatelessWidget {
   UserName({Key? key}) : super(key: key);

  var _text = TextEditingController();
   TextEditingController nameController = TextEditingController();
   TextEditingController usernameController = TextEditingController();
   TextEditingController passwordController = TextEditingController();
   TextEditingController dateController = TextEditingController();
   TextEditingController emailController = TextEditingController();
   TextEditingController birthController = TextEditingController();


   CollectionReference users = FirebaseFirestore.instance.collection('users');

  void createUserInFirestore(){
    users.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot){
          if(querySnapshot.docs.isEmpty){
            users.add({
              'name': _text.text,
              'status': 'Available',
              'uid': FirebaseAuth.instance.currentUser!.uid,
              'birthday': birthController,
              'email': emailController,
              'username' : usernameController,
            });
          }
    })
        .catchError((error){});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter your name"),
              CupertinoTextField(
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25),
                maxLength: 15,
                controller: _text,
                keyboardType: TextInputType.name,
                autofillHints: <String>[AutofillHints.name],
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                  child: const Text("Continue"),
                  onPressed: (){
                    FirebaseAuth.instance.currentUser!
                        .updateProfile(displayName: _text.text);

                    createUserInFirestore();

                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => HomeScreen()),
                    );
                  })
            ],
          ),
        ),

    );
  }
}
