import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText, // to hide the character like password
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        fillColor: Colors.deepPurpleAccent[400], // color dlm box
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
      ),

    );
  }
}