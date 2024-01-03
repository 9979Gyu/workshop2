import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../camera/camera.dart';
import '../homepage.dart';


class AddStoryPage extends StatefulWidget {
  const AddStoryPage({Key? key}) : super(key: key);

  @override
  _AddStoryPageState createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
  late CameraDescription? firstCamera;

  String? _statusText; // Initialize as null or with a default status text
  XFile? _pickedImage; // Updated to use XFile instead of PickedFile

  Future<void> _uploadStatus() async {
    try {
      final User? user = _auth.currentUser;

      // check if user is logged in
      if(user == null){
        print('User is not logged in');
        return;
      }

      // check if status is not empty
      if (_statusText == null || _statusText!.isEmpty){
        print('Status text is empty');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a status',
              style: TextStyle(
                color: myTextColor,
              ),
            ),
          ),
        );
        return;
      }

      // Check if an image is picked
      if (_pickedImage == null) {
        print('No image selected.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
          ),
        );
        return;
      }

      // proceed with uploading the image first
      final storageReference = _storage
          .ref()
          .child('status_images/${user.uid}_${DateTime.now()
          .millisecondsSinceEpoch}.png');

      final uploadTask = storageReference.putFile(File(_pickedImage!.path));
      final TaskSnapshot uploadSnapshot = await uploadTask;
      final String imageDownloadUrl = await uploadSnapshot.ref.getDownloadURL();

      String username = user.displayName ?? user.email?.split('@')[0] ?? 'Unknown User';

      await FirebaseFirestore.instance.collection('status').add({
        'userID': user.uid,
        'username': username,
        'statusText': _statusText,
        'mediaUrl': imageDownloadUrl,
        'timeStamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _statusText = null;
        _pickedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status uploaded successfully'),
        ),
      );

    } catch (e) {
      print('Error uploading status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading status: $e'),
        ),
      );

    }
  }

  void navigateToTakePictureScreen(
      BuildContext context, CameraDescription camera){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
            camera: camera,
            onSavePicture: (XFile? imageFile) async {
              if (imageFile != null) {
                setState(() {
                  _pickedImage = imageFile;
                });
              }
            }
        ),
      ),
    );
  }

  void _selectImageFromGallery() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _pickedImage = pickedFile);
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  if (firstCamera != null) {
                    navigateToTakePictureScreen(context, firstCamera!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No Camera Available')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _selectImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState(){
    super.initState();
    _initializeFirstCamera();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializeFirstCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        firstCamera = cameras.first;
      });
    }
    else{
      // handle the case when there is no camera available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Camera Available'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: myCustomColor,
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Center(
            child: Text(
              'Add Story',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: myTextColor,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: _uploadStatus,
              icon: Icon(
                Icons.check,
                color: myTextColor,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: (){
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

        body: ListView(
          padding: const EdgeInsets.only(top: 55.0),//Adjust the top padding as needed
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _statusText = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Status Here',
                      labelStyle: TextStyle(color: myTextColor),
                      hintText: 'Enter Status',
                      hintStyle: TextStyle(
                        color: myTextColor,
                      ),
                      counterText: '',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFf3f5f6),
                          width: 2.0,
                        ),
                      ),
                      fillColor: Colors.purple,
                      filled: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 18,),

                ElevatedButton(
                  onPressed: () async {
                    final XFile? pickedFile =
                      await _imagePicker.pickImage(
                          source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _pickedImage = pickedFile;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Select Image',
                  style: TextStyle(
                      color: Colors.white),),
                ),
                if (_pickedImage != null)
                  Image.file(
                    File(_pickedImage!.path),
                    width: 100,
                    height: 100,
                  ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showImageSourceActionSheet(context),
          backgroundColor: Colors.deepOrange,
          child: const Icon(Icons.add, color: Colors.white, size: 25),
        ),

      ),
    );
  }
}
