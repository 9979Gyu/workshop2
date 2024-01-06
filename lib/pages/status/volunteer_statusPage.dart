//volunteer_statusPage.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/status/stories/view_stories_page.dart';
import 'package:glaucotalk/pages/status/story_page.dart';
import 'package:glaucotalk/pages/status/vol_addStory.dart';
import 'package:image_picker/image_picker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../../model/status.dart';
import '../volunteer_homepage.dart';
import 'add_story_page.dart';

class VolStatusPage extends StatefulWidget {
  final String userId;

  const VolStatusPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<VolStatusPage> createState() => _VolStatusPageState();
}

class _VolStatusPageState extends State<VolStatusPage> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final imagePicker = ImagePicker();
  String profilePictureUrl = '';

  List<Status> statusDataList = [];
  List<String> profilePictureUrls = [];

  PickedFile? pickedImage;
  String storyContent = '';

  String _statusText = ""; // Add your status text here
  String _mediaUrl = ""; // Add your media URL here (if any)

  @override
  void initState() {
    super.initState();
    // call a function to retrieve the user's profile picture url when
    // the widget initialized
    _retrieveUserProfilePicture();
    _retrieveUserStatusUpdates();
  }

  // Function to retrieve user's profile picture URL
  Future<void> _retrieveUserProfilePicture() async {
    try {
      // get the current signed-in user
      final user = _auth.currentUser;
      if (user != null) {
        final profilePictureRef =
        _storage.ref().child('profile_pictures/${user.uid}.png');

        // get the download URL for the profile picture
        final downloadUrl = await profilePictureRef.getDownloadURL();

        setState(() {
          profilePictureUrl = downloadUrl;
        });
      } else {
        // Handle the case where no user is signed in
        setState(() {
          profilePictureUrl = ''; // Set a default or empty URL
        });
      }
    } catch (e) {
      print('Error retrieving profile picture with error: $e');
    }
  }

  Future<void> _retrieveUserStatusUpdates() async {
    try {
      final querySnapshot = await _firestore
          .collection('status')
          .where('userId', isEqualTo: widget.userId)
          .get();

      final data = querySnapshot.docs.map((doc) {
        final userId = doc['userId'];
        final profilePictureUrl = doc['profilePictureUrl'];

        return Status(
          userId: userId,
          profilePictureUrl: profilePictureUrl,
          content: '',
          timestamp: Timestamp.fromDate(DateTime.now()),
          // Replace with your timestamp logic
        );
      }).toList();

      setState(() {
        statusDataList = data;
      });
    } catch (e) {
      print('Error retrieving user status updates: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile =
      await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          pickedImage = pickedFile as PickedFile?;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _openStory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StoryPage(),
      ),
    );
  }

  Future<void> postStatus(String content, String? mediaUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      Status newStatus = Status(
        userId: user.uid,
        // Set the user ID
        content: content,
        mediaUrl: mediaUrl,
        timestamp: Timestamp.fromDate(DateTime.now()),
        profilePictureUrl: profilePictureUrl,
      );

      // Add logic to save this status in Firestore
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          // First Tab: User Profiles in Horizontal ListView
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                // Adjust top padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(

                      height: 85,

                      child: ListView.builder(
                        itemCount: 6, // Replace with actual count
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _openStory(),
                            // Call function with index if needed
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    profilePictureUrl),
                                // You'll need a different URL for each profile or adjust accordingly
                                radius: 30,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Second Tab: Placeholder
          Container(
            child: Center(
              child: Text('Second Tab Placeholder'),
            ),
          ),
        ],
      ),
    );
  }
}