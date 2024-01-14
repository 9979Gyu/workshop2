import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/components/chat_bubble.dart';
import 'package:glaucotalk/components/my_text_field.dart';
import 'package:glaucotalk/database/chat/chat_service.dart';
import 'package:glaucotalk/database/notification/notification_service.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverUserID;
  final String receiverIDuser;
  final String senderprofilePicUrl;

  const ChatPage({
    super.key,
    required this.receiverName,
    required this.receiverUserID,
    required this.receiverIDuser,
    required this.senderprofilePicUrl});

  @override
  State<ChatPage> createState() => _ChatPageState(receiverUserID: receiverUserID);
}

class _ChatPageState extends State<ChatPage> {
  final String receiverUserID;
  late FirebaseFirestore _firestore;
  double fontSize = 14.0; // Initial font size

  _ChatPageState({
    required this.receiverUserID
  });

  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
 // final notificationsService = NotificationsService();

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  File? backgroundImage;


  // baru add
  // @override
  // void initState() {
  //   notificationsService.getReceiverToken(widget.receiverUserID);
  //   super.initState();
  //   notificationsService.firebaseNotification(document as DocumentSnapshot<Object?>, context);
  // }

  @override
  void initState(){
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _updateUserSeen('online'); // set initial status to online
    // load the saved background image path when the page is initialized
    _loadBackgroundImage();
    _loadFontSize();
  }

  //load font size from shared preferences
  Future<void> _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('fontSize') ?? 14.0; // default size
    });
  }

  Future<void> _saveFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', fontSize);
  }

  @override
  void dispose(){
    super.dispose();
    _updateUserSeen('offline'); // set the status to offline when page is disposed
  }

  void _updateUserSeen(String seen) async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'seen': seen});
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  void sendMessage() async{
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty){
      // String profilePicUrl = "lib/images/winter.jpg"; // fetch current user's profile pic

      await _chatService.sendMessage(
        receiverUserID,
        _messageController.text,
        widget.receiverIDuser,
        widget.receiverName,
        //widget.senderprofilePicUrl,
        //"",
      );

      // // baru add
      // await notificationsService.sendNotification(
      //   body: _messageController.text,
      //   senderId: FirebaseAuth.instance.currentUser!.uid,
      // );

      print(widget.receiverUserID);
      print(widget.receiverIDuser);
      // clear the text controller after sending the message
      _messageController.clear();
    }

    // buat query daripada document user id, nak dapatkan userId dalam field collection
  }

  Future<Map<String, dynamic>?> getUserData(String IDuser) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(IDuser)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        // Document with the given userId does not exist
        return null;
      }
    } catch (e) {
      // Handle any potential errors here
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        backgroundImage = File(pickedImage.path);
      });

      // save the selected background to shared preference
      _saveBackgroundImage(pickedImage.path);
    }
  }

  // load the saved background image path from shared preferences
  Future<void> _loadBackgroundImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('backgroundImage');
    if(imagePath != null) {
      setState(() {
        backgroundImage = File(imagePath);
      });
    }
  }

  // save the selected background to shared preferences
  Future<void> _saveBackgroundImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundImage', imagePath);
  }

  // Increase the font size
  void increaseFontSize() {
    setState(() {
      fontSize += 2.0;
    });
    _saveFontSize();
  }

  // Decrease the font size
  void decreaseFontSize() {
    setState(() {
      fontSize -= 2.0;
    });
    _saveFontSize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myCustomColor,
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text(
                widget.receiverName,
                style: const TextStyle(
                    color: Colors.white),),
              StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(widget.receiverUserID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData){
                      return const SizedBox.shrink();
                    }

                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    var userStatus = data['seen'] as String? ?? 'offline';
                    var statusColor = Colors.grey;

                    if (userStatus == 'online'){
                      statusColor = Colors.green;
                    } else if (userStatus == 'offline') {
                      statusColor = Colors.red;
                    }

                    return Text(
                      userStatus,
                      style: TextStyle(
                          color: statusColor),
                    );
                  },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black54,
          actions: [
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: _pickImage,
              color: Colors.white,
            ),
            // Button to increase font size
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: increaseFontSize,
              color: Colors.white,
            ),
            // Button to decrease font size
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: decreaseFontSize,
              color: Colors.white,
            ),
          ],
          leading: IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,),
          )
      ),
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

    // fetch the unread count for the conversation

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
                        maxRadius: 25,
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(data['senderEmail'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ChatBubble(
                            message: data['message'],
                            isCurrentUser: isCurrentUser,
                            fontSize: fontSize,),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                    if (isCurrentUser && senderProfilePictureUrl != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(senderProfilePictureUrl),
                        maxRadius: 25,
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
      padding: const EdgeInsets.symmetric(horizontal:20.0 ,),
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
         /* IconButton(
              onPressed: sendMessage,
          */
          IconButton(
              onPressed: () async {
                // Retrieve and print user data for the receiverUserId
                Map<String, dynamic>? userData = await getUserData(widget.receiverIDuser);
                if (userData != null) {
                  print(userData);
                } else {
                  print('User data found for IDuser: ${widget.receiverIDuser}');
                }
                sendMessage();
              },
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