import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:glaucotalk/pages/volunteer_homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class VolProfilePage extends StatefulWidget {
  const VolProfilePage({Key? key}) : super(key: key);

  @override
  State<VolProfilePage> createState() => _VolProfilePageState();
}

class _VolProfilePageState extends State<VolProfilePage> {
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Uint8List? _image;
  final imagePicker = ImagePicker();
  String dropdownvalue = "Male"; // replace to stored user's gender
  bool obscureText = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  File? get file => null;

  String profilePictureUrl ='';

  Future<void> uploadImageAndSave() async{
    try{
      final user = _auth.currentUser;
      if (user == null) {
        // Handle the case where the user is not signed in.
        return;
      }
      final profile = 'profile_pictures/${user.uid}.png';

      // Upload image to cloud storage
      final UploadTask task = _storage.ref().child(profile).putData(_image!);

      // Get download URL of the uploaded image
      final TaskSnapshot snapshot = await task;
      final imageUrl = await snapshot.ref.getDownloadURL();

      // Update user's firestore doc with the image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePictureUrl': imageUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture uploaded and updated.'),
        ),
      );
    } catch (error) {
      // Handle errors here.
      print('Error uploading image: $error');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = Uint8List.fromList(imageBytes);
      });
    } else {
      print("Image source not found");
    }
  }

  @override
  void initState(){
    super.initState();
    // Call a function to fetch user's data from firestore
    fetchUserData();
  }

  Future<void> fetchUserData() async{
    try{
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the user's document from firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if(userDoc.exists){
        // Extract and set user data to the respective TextEditingController
        setState(() {
          emailController.text = userDoc['email'];
          nameController.text = userDoc['name'];
          usernameController.text = userDoc['username'];
          profilePictureUrl = userDoc['profilePictureUrl'];
          dateController.text = userDoc['birthday'];
          dropdownvalue = userDoc['gender'] ?? 'Male';
        });

        print("This is user name : ${userDoc['username']}");
        print("This is profile picture : ${profilePictureUrl}");
      }
      else{
        print("Data does not exist");
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<void> _selectDate() async{
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if(selected != null){
      setState(() {
        String formattedDate =
            "${selected.year}-${selected.month.toString().padLeft(2, '0')}"
            "-${selected.day.toString().padLeft(2, '0')}";
        dateController.text = formattedDate; // Update the dateController
      });
    }
  }

  Future<void> updateUserData() async{
    try{
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the user document in firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'name': nameController.text,
        'gender' : dropdownvalue,
        'email' : emailController.text,
        'birthday' : dateController.text,
        'username' : usernameController.text,
        'profilePictureUrl' : profilePictureUrl,
      });

      // Inform the user that the profile has been updated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isNightMode = Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600),
          ),),
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VolHomePage()));
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                      : (profilePictureUrl != null && profilePictureUrl.isNotEmpty
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(profilePictureUrl),
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/logo.png'),
                  )),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dropdownvalue,
                        style: const TextStyle(),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                      ),
                      offset: const Offset(0, 50),
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Male',
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                'Male',
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Female',
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                'Female',
                              ),
                            ),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        setState(() {
                          dropdownvalue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "username",
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "email",
                ),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date of Birth",
                  suffixIcon: Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xF6F5F5FF),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                onTap: () {
                  _selectDate();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[700],
                    elevation: 10,
                    shape: const StadiumBorder()),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                      color: Color(0xF6F5F5FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if(usernameController.text.isNotEmpty &&
                      nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty){
                    await updateUserData();
                    await uploadImageAndSave();
                    Navigator.pop(context, true);
                  }
                  else{
                    Navigator.pop(context, false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
