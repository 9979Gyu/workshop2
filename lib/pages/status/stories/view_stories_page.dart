import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../homepage.dart';

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
  int _currentIndex = 0; // Index of the currently displayed status
  QuerySnapshot? _snapshot; // Declare a global variable for snapshot data

  @override
  void initState() {
    super.initState();
    _fetchStories(); // Fetch stories when the widget initializes
  }

  Future<void> _fetchStories() async {
    final snapshot = await _firestore
        .collection('status')
        .orderBy('timeStamp', descending: true)
        .get();

    setState(() {
      _snapshot = snapshot;
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();

    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      // Today's date
      return 'Today , ${DateFormat('kk:mm').format(date)}';
    } else {
      final yesterday = now.subtract(const Duration(days: 1));
      if (yesterday.day == date.day &&
          yesterday.month == date.month &&
          yesterday.year == date.year) {
        // Yesterday's date
        return 'Yesterday , ${DateFormat('kk:mm').format(date)}';
      } else {
        // Older date, show full date
        return DateFormat('yyyy-MM-dd , kk:mm').format(date);
      }
    }
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
          onPressed: () {
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
      body: _snapshot == null
          ? const Center(
          child: CircularProgressIndicator(),
        )
            : _snapshot!.docs.isEmpty
            ? const Center(
              child: Text('No Stories available'),
             )
          : PageView.builder(
               itemCount: _snapshot!.docs.length,
               controller: PageController(
                    initialPage: _currentIndex,
                ),
                onPageChanged: (index) {
               setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              DocumentSnapshot story = _snapshot!.docs[index];
              Map<String, dynamic> data =
              story.data() as Map<String, dynamic>;

              // Extract the timestamp and format it
              Timestamp timestamp = data['timeStamp'];
              // DateTime date = timestamp.toDate();
              // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
              //String formattedDate = formatTimestamp(timestamp);

              // Modify here to include the user's name
              String postedBy = data['username'] ?? 'Unknown User';

              return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                data['mediaUrl'] != null
                    ? Image.network(data['mediaUrl'],
                    width: 300,
                    height: 400,
                    fit: BoxFit.cover)
                    : const SizedBox(
                  width: 300,
                  height: 300, //placeholder in case of no image
                ),
              const SizedBox(height: 20),
              Text(
                data['statusText'] ?? 'No status text',
                style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Posted by ${data['username'] ?? 'Unknown User'}',
                style: TextStyle(
                    color: myTextColor,
                    fontSize: 16),
              ),
                // Display the formatted timestamp
                Text(
                  //formattedDate,
                  formatTimestamp(timestamp),
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: myCustomColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (_currentIndex > 0) {
                  setState(() {
                    _currentIndex--;
                  });
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                if (_currentIndex < _snapshot!.docs.length - 1) {
                  setState(() {
                    _currentIndex++;
                  });
                }
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
