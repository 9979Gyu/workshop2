import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/camera/vol_display_picture.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

import 'DisplayPictureScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: VolTakePictureScreen(
        camera: firstCamera,
        onSavePicture: (XFile? imageFile) {
          // Define what should happen when a picture is saved.
          // For example, you can upload it to Firebase Storage.
          if (imageFile != null) {
            savePictureToStorage(imageFile);
          }
        },
      ),
    ),
  );
}

Future<void> savePictureToStorage(XFile imageFile) async {
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/snapped_image.jpg';

    final rawImage = File(imageFile.path).readAsBytesSync();
    final image = decodeImage(Uint8List.fromList(rawImage));

    if (image != null) {
      final savedFile = File(filePath);
      savedFile.writeAsBytesSync(encodeJpg(image));

      // You can add additional code here, such as showing a success message.
    } else {
      print('Failed to process the image');
    }
  } catch (e) {
    print('Unable to save the picture to local storage: $e');
    // You can handle the error here.
  }
}

class VolTakePictureScreen extends StatefulWidget {
  const VolTakePictureScreen({
    Key? key,
    required this.camera,
    required this.onSavePicture,
  }) : super(key: key);

  final CameraDescription camera;
  final void Function(XFile?) onSavePicture;

  @override
  State<VolTakePictureScreen> createState() => _VolTakePictureScreenState();
}

class _VolTakePictureScreenState extends State<VolTakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> savePictureToStorage(String sourceImagePath, String destinationImagePath) async {
    try {
      final rawImage = File(sourceImagePath).readAsBytesSync();
      final image = decodeImage(Uint8List.fromList(rawImage));

      if (image != null) {
        final savedFile = File(destinationImagePath);
        savedFile.writeAsBytesSync(encodeJpg(image));

        // You can add additional code here, such as showing a success message.
      } else {
        print('Failed to process the image');
      }
    } catch (e) {
      print('Unable to save the picture to local storage: $e');
      // You can handle the error here.
    }
  }

  Future<void> _displayImageFoundFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        // Specify the destination path where you want to save the image in local storage.
        final localImagePath = '${(await getApplicationDocumentsDirectory()).path}/local_image.jpg';

        // Call the function to save the picked image to local storage
        await savePictureToStorage(pickedImage.path, localImagePath);

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VolDisplayPictureScreen(
              imagePath: pickedImage.path,
            ),
          ),
        );
      }
    } catch (e) {
      print("Unable to pick the image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('Take A Picture'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                final image = await _controller.takePicture();
                if (!mounted) return;

                final ref = firebase_storage.FirebaseStorage.instance
                    .ref()
                    .child('images/img_${DateTime.now().microsecondsSinceEpoch}.png');
                await ref.putFile(File(image.path));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Picture taken and uploaded to Firebase Storage'),
                  ),
                );

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      imagePath: image.path,
                    ),
                  ),
                );
              } catch (e) {
                print("Unable to take a picture: $e");
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          FloatingActionButton(
            onPressed: () async {
              await _displayImageFoundFromGallery();
            },
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}