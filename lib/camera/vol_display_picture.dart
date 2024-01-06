import 'dart:io';
import 'package:flutter/material.dart';

class VolDisplayPictureScreen extends StatelessWidget {
  //final String imageUrl;
  final String imagePath;

  const VolDisplayPictureScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(title: const Text('Display the Picture'),
        backgroundColor: Colors.black54,
      ),
      // The Image is stored as a file on the device. use the 'Image.file'
      // constructor with the given path to display the image
      body: Image.file(File(imagePath)),
    );
  }
}
