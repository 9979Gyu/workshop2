import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message{
  final String senderId;
  final String senderEmail;
  final String senderName;
  final String receiverId;
  final String message;
  final Timestamp timestamp;


  Message({
    required this.senderId,
    required this.senderEmail,
    required this.senderName,
    required this.receiverId,
    required this.timestamp,
    required this.message,
  });

  // Convert to a map
  Map<String, dynamic> toMap() {
    return{
      'senderId': senderId,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}