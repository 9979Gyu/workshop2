import 'package:workshop2/pages/setting/help_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
  TextEditingController messageController = TextEditingController();


  Future<void> saveContactData() async{
    try{

      // get the current users ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Generate a unique document ID for each submission
      // final conDocRef = FirebaseFirestore.instance.collection('contacts').doc();

      // update the contacts document in firestore
      await FirebaseFirestore.instance.collection('contacts').add({
        'userID': userId,
        'dateTime' : DateTime.now(),
        'comment' : messageController.text,
        'status' : 1,
      });

      print("-------------------------Successfully saved data-------------------------------");

    } catch(e){
      print('Error saving data: $e');

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar(
        title: Text(
            "Help",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: myTextColor,
                fontSize: 30,
                fontWeight: FontWeight.w600),
          ),),
        backgroundColor: Colors.black54,

        leading: IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HelpCenter()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
               Text(
                "Contact Us",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: myTextColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 20,),

              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    enabledBorder:  OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    hintText: 'Tell us how we can help',
                    helperMaxLines: 5,
                    prefixIcon: const Icon(
                      Icons.telegram,
                      color: Colors.white,
                    ),
                    fillColor: Colors.deepPurple,
                    filled: true,
                    hintStyle: TextStyle(
                      color:  myTextColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 90,
                        horizontal: 15
                   ),
                  ),
                  style: const TextStyle(
                      color: Colors.white), // Text color while typing
                ),
              ),

              const SizedBox(height: 30,),

              // send button
              SizedBox(
                width: 200,
                 child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange[700],
                    elevation: 10,
                    shape: const StadiumBorder()
                  ),
                    child:  const Text(
                        "SEND",
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                    ),
                   onPressed: (){
                     // add save input to database function
                    // await saveContactData();
                     if(messageController.text.trim().isNotEmpty){
                       saveContactData();
                       // Inform user that the feedback has been sent
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (content) => buildSuccessPage(),
                        ),
                       );
                     }
                   },
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSuccessPage() {
    return Scaffold(
      backgroundColor: myCustomColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Thanks for your contact!',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xF6F5F5FF),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'We appreciate your feedback—it fuels our improvement process.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xF6F5F5FF),
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpCenter()
                        ), (route) => false
                    );
                  },
                  child: const Text("Return")
              ),
            ],
          ),
        ),
      ),
    );
  }
}