import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:story_view/story_view.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentStoryIndex = 0;
  late Timer _timer;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<QueryDocumentSnapshot>> _storyStream;
  final StoryController storyController = StoryController();

  @override
  void initState() {
    super.initState();
    _storyStream = _firestore
        .collection('status')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    _startWatching();
  }

  void _startWatching() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      // Update percentWatched logic here
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    storyController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    // Your existing onTapDown logic
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Scaffold(
        body: StreamBuilder<List<QueryDocumentSnapshot>>(
          stream: _storyStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No stories available'));
            }
            final stories = snapshot.data!;

            // Create a list of StoryItems for each user's story
            final List<List<StoryItem>> allUsersStories = stories.map((document) {
              List<StoryItem> items = [];

              // Example: Add an image story item if available
              if (document['mediaUrl'] != null) {
                items.add(StoryItem.pageImage(
                  url: document['mediaUrl'],
                  controller: storyController,
                  caption: document['statusText'] ?? 'No Text',
                  duration: const Duration(seconds: 5),
                ));
              }

              // Example: Add a text story item
              items.add(StoryItem.text(
                title: document['statusText'] ?? 'No text',
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 5),
              ));

              return items;
            }).toList().cast<List<StoryItem>>();

            return StoryView(
              storyItems: allUsersStories[currentStoryIndex],
              controller: storyController,
              onComplete: () {
                setState(() {
                  currentStoryIndex = (currentStoryIndex + 1) % allUsersStories.length;
                });
              },
              onVerticalSwipeComplete: (direction) {
                // Logic for vertical swipe action, if needed
              },
              // Additional configurations and callbacks as needed
            );
          },
        ),
      ),
    );
  }
}
