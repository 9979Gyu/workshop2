import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({
    super.key,
    required this.onTap,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
