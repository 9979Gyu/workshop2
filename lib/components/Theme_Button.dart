import 'package:flutter/material.dart';

class THButton extends StatelessWidget {
  final Color? color;
  final void Function()? onTap;

  const THButton({
    super.key,
    required this.color,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(25),
        child: const Center(
          child: Text("TAP"),
        ),
      ),
    );
  }
}
