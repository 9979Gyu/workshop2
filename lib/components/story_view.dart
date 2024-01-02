import 'package:flutter/material.dart';

class StoryView extends StatelessWidget {
  final Map<String, dynamic> storyData;

  const StoryView({
    Key? key,
    required this.storyData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build your story view based on storyData
    return Container(
      child: Text(
          storyData['statusText']
          ?? 'No text available'),
      // You should also handle image loading here
    );
  }
}
