import 'package:workshop2/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatService extends ChangeNotifier{

  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // SEND MESSAGES
  Future<void> sendMessage(String receiverId, String message, String name) async{

    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    //final String currentName = _firebaseAuth.currentUser!.name.toString();

    final DocumentSnapshot userDoc = await _fireStore
        .collection('users')
        .doc(currentUserId)
        .get();

    final String currentUserProfile = userDoc['profilePictureUrl'] ?? '';
    final String currentName = userDoc['name'] ?? '';
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        senderName: currentName,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message,
        //senderprofilePicUrl: senderprofilePicUrl,
        //receiverprofilePicUrl: receiverprofilePicUrl

    );

    // construct a chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // Sort the ids- this ensure the chat room id is always the same for any pair of users
    String chatRoomId =
    ids.join("_"); // -> combine the ids into a single string to use as a chatroomID

    // Add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

  }

  // RECEIVE MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    // Construct a chat room id from user ids
    // (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

}