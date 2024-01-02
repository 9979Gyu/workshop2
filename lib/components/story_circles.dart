import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final String profilePictureUrl;
  final function;

  const StoryCircle({
    super.key,
    this.function,
    required this.profilePictureUrl,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
     child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 2),
            image: DecorationImage(
              image: NetworkImage(profilePictureUrl),
            fit: BoxFit.cover,
            )
          ),
        ),
      ),
    );
  }
}
