import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/model/message.dart';
import 'package:glaucotalk/Controller/OneSignalController.dart'; // Import your OneSignalController class

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message, String receiverIDuser, String name) async {
    try {
      // Validate current user
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        print('No current user found.');
        return;
      }

      // Get current user info
      final String currentUserId = currentUser.uid;
      final String currentUserEmail = currentUser.email ?? 'No email';
      final DocumentSnapshot userDoc = await _fireStore
          .collection('users')
          .doc(currentUserId)
          .get();

      print(currentUserId);

      final String currentName = userDoc['name'] ?? '';
      final Timestamp timestamp = Timestamp.now();

      // Create a new message
      Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        senderName: currentName,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message,
      );

      // Construct a chat room id
      List<String> ids = [currentUserId, receiverId];
      ids.sort(); // Sort the ids
      String chatRoomId = ids.join("_");

      // Add new message to database
      await _fireStore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());

      // Send push notification using OneSignalController
      OneSignalController onesignal = OneSignalController();
      onesignal.SendNotification(
          "New Message Received",
          message,
          [receiverIDuser]);

      print('Message sent successfully.');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    try {
      List<String> ids = [userId, otherUserId];
      ids.sort();
      String chatRoomId = ids.join("_");

      return _fireStore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (e) {
      print('Error retrieving messages: $e');
      return Stream<QuerySnapshot>.empty();
    }
  }
}
