// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:glaucotalk/database/chat/chat_service.dart';
//
// class UserListPage extends StatefulWidget {
//   const UserListPage({super.key});
//
//   @override
//   State<UserListPage> createState() => _UserListPageState();
// }
//
// class _UserListPageState extends State<UserListPage> {
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User List"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot){
//           if(!snapshot.hasData){
//             return CircularProgressIndicator();
//           }
//           return ListView(
//             children: snapshot.data!.docs
//                 .map((doc) => _buildUserListItem(doc))
//                 .toList(),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildUserListItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//     String userId = document.id;
//
//     return StreamBuilder<int>(
//       stream: _chatService.getUnreadMessageCount(_firebaseAuth.currentUser!.uid, userId),
//       builder: (context, unreadCountSnapshot) {
//         int unreadCount = unreadCountSnapshot.data ?? 0;
//
//         return ListTile(
//           title: Text(data['name']),
//           subtitle: unreadCount > 0 ? Text('$unreadCount unread messages') : null,
//           onTap: () {
//             // Navigate to chat page
//           },
//         );
//       },
//     );
//   }
// }
