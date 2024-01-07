import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/components/chat_bubble.dart';
import 'package:glaucotalk/components/my_text_field.dart';
import 'package:glaucotalk/database/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverUserID;
  final String senderprofilePicUrl;

  const ChatPage({
    super.key,
    required this.receiverName,
    required this.receiverUserID,
    required this.senderprofilePicUrl});

  @override
  State<ChatPage> createState() => _ChatPageState(receiverUserID: receiverUserID);
}

class _ChatPageState extends State<ChatPage> {
  final String receiverUserID;

  _ChatPageState({required this.receiverUserID});
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async{
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty){
      // String profilePicUrl = "lib/images/winter.jpg"; // fetch current user's profile pic

      await _chatService.sendMessage(
        receiverUserID,
        _messageController.text,
        widget.receiverName,
        //widget.senderprofilePicUrl,
        //"",

      );

      print(widget.receiverUserID);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.receiverName,
            style: const TextStyle(
                color: Colors.white),),
        ),
        backgroundColor: Colors.black54,),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),

          // User input
          _buildMessageInput(),
          const SizedBox(height: 25),

        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading..');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },);
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Determine if the message is sent by the current user
    bool isCurrentUser = (data['senderId'] == _firebaseAuth.currentUser!.uid);

    // Fetch the sender's and receiver's profile picture URLs
    Future<String?> fetchProfilePictureUrl(String userId) async {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          return userDoc['profilePictureUrl'];
        }
      } catch (e) {
        print('Error fetching image: $e');
      }
      return null;
    }

    return FutureBuilder<String?>(
      // Fetch the profile picture URL based on the sender's ID
      future: fetchProfilePictureUrl(data['senderId']),
      builder: (context, senderSnapshot) {
        final senderProfilePictureUrl = senderSnapshot.data;

        return FutureBuilder<String?>(
          // Fetch the profile picture URL based on the receiver's ID
          future: fetchProfilePictureUrl(widget.receiverUserID),
          builder: (context, receiverSnapshot) {
            final receiverProfilePictureUrl = receiverSnapshot.data;

            return Container(
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isCurrentUser && receiverProfilePictureUrl != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(receiverProfilePictureUrl),
                        maxRadius: 20,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(data['senderEmail']),
                          const SizedBox(height: 8),
                          ChatBubble(message: data['message']),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                    if (isCurrentUser && senderProfilePictureUrl != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(senderProfilePictureUrl),
                        maxRadius: 20,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  // build message input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:25.0 ,),
      child: Row(
        children: [
          // TextField
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter Message',
              obscureText: false,
            ),
          ),

          // Send button
          IconButton(
              onPressed: sendMessage,
              icon:
              const Icon(
                Icons.telegram_outlined,
                size: 40,
                color: Colors.white,))
        ],
      ),
    );
  }
}