import 'dart:io';

import 'package:workshop2/pages/home_page.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewStoriesPage extends StatefulWidget {
  const ViewStoriesPage({super.key});

  @override
  State<ViewStoriesPage> createState() => _ViewStoriesPageState();
}

class _ViewStoriesPageState extends State<ViewStoriesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CameraDescription? firstCamera;
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  Stream<QuerySnapshot> get _storiesStream {
    return _firestore
        .collection('status')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
            'View Stories',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.yellow,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _storiesStream,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return const Center(
              child: Text('No Stories available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot story = snapshot.data!.docs[index];
              Map<String, dynamic> data
              = story.data() as Map<String, dynamic>;

              return ListTile(
                leading: data['mediaUrl'] != null
                    ? Image.network(data['mediaUrl'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover)
                    : const SizedBox(
                  width: 60,
                  height: 60, //place holder in case of no image
                ),
                title: Text(
                    data['statusText'] ?? 'No status text',
                style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    'Posted by ${data['userID'] ?? 'Unknown'}',
                  style: TextStyle(
                      color: myTextColor,
                      fontSize: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}