import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final double fontSize;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.fontSize,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCurrentUser ? Colors.deepPurple[900] : Colors.black54,
      ),
      child: Text(
        message,
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.white
       ),
      ),
    );
  }
}
