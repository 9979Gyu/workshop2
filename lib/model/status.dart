
// Create a class to represent the status data
import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String userId;
  final String content;
  final String? mediaUrl;
  final String profilePictureUrl;// Nullable if no media is attached
  final Timestamp timestamp;

  Status({
    required this.userId,
    required this.content,
    this.mediaUrl,
    required this.timestamp,
    required this.profilePictureUrl,
  });
}

// Inside your user class or wherever you store user data
class User {
  final String userId;
  final String username;
  final String profilePictureUrl;
  final List<Status> statuses;

  User({
    required this.userId,
    required this.username,
    required this.profilePictureUrl,
    required this.statuses,
  });
}
