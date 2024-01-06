import 'dart:async' show Timer;
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:glaucotalk/camera/camera.dart';
import 'package:glaucotalk/database/auth_service.dart';
import 'package:glaucotalk/pages/chat_page.dart';
import 'package:glaucotalk/pages/profile_page.dart';
import 'package:glaucotalk/pages/search.dart';
import 'package:glaucotalk/pages/setting/Notification%20page/noti_page.dart';
import 'package:glaucotalk/pages/setting/account_center.dart';
import 'package:glaucotalk/pages/setting/help_center.dart';
import 'package:glaucotalk/pages/setting/theme/Apparance.dart';
import 'package:glaucotalk/pages/status/statuspage.dart';
import 'package:glaucotalk/pages/view/image_classification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../autherization/user/login_user.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer timer;
  String profilePictureUrl ='';

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = "";
  String email = "";

  AuthService authService = AuthService();

  int _selectedIndex =0;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  late CameraDescription? firstCamera;

  get floatingActionButton => null;

  // Function to save the snapped picture to local storage
  Future<void> savePictureToStorage (XFile? imageFile) async {
    if (imageFile == null) {
      return;
      // handle the case if no image to save
    }

    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/snapped_image.jpg';

    final rawImage = File(imageFile.path).readAsBytesSync();
    final image = img.decodeImage(Uint8List.fromList(rawImage));

    if (image != null){
      final savedFile = File(filePath);
      savedFile.writeAsBytesSync(img.encodeJpg(image));
      print('Image saved to $filePath');
    } else {
      print ('Failed to process the image');
    }
  }

  // void updateUserPresence() {
  //   ref.read(authControllerProvider).updateUserPresence();
  // }

  //Function to navigate to TakePictureScreen

  void navigateToTakePictureScreen(
      BuildContext context, CameraDescription camera){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TakePictureScreen(
              camera: camera,
            onSavePicture: (XFile? image) async {
              if (image != null) {
                await savePictureToStorage(image);
              }
            }
          ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize firstCamera in the initState method
    _initializeFirstCamera();
    // call fetchUserData to get user data
    fetchUserData();
    // Schedule a microtask
    //updateUserPresence();
    timer = Timer.periodic(
      const Duration(minutes: 1),
          (timer) => setState(() {}),
    );
  }

  @override
  void dispose() {
    timer.cancel();
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

  // sign user out
  void signOut(){
    FirebaseAuth.instance.signOut();
  }


  Future<void> fetchUserData() async{
    try{
      // get tje current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // fetch the user;s document from firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if(userDoc.exists){
        // Extract and set user data to the respective TextEditingController
        setState(() {
          nameController.text = userDoc['name'];
          usernameController.text = userDoc['username'];
          emailController.text = userDoc['email'];

          // set the profile pictrue URL from firestore
          profilePictureUrl = userDoc['profilePictureUrl'];
          // set other fields similarity
        });

        print("This is the profile picture url : ${profilePictureUrl}");
      }
      else{
        print("Data not exist");
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> softDeleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'status': 0}); // set status to 0 = inactive
    } catch(e){
      Text("Error soft delete: $e");

    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: myCustomColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black54,
          title: Text(
            'C H A T ',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Colors.yellow,
              ),
            ),
          ),
          actions: [
            // Search button
            IconButton(
              onPressed: () {
                // Add your search functionality here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const SearchPage(),
                  ),
                );
              },
              icon: const Icon(Icons.search,
                size: 27,
                color: Colors.white,

              ),
            ),

            // IconButton(
            //   onPressed: () {
            //     navigateToTakePictureScreen(context, firstCamera!);
            //   },
            //   icon: const Icon(
            //     Icons.camera_alt,
            //     color: Colors.white,),
            // ),
          ],

          bottom: const TabBar(
            labelColor: Colors.orange,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20),// Color for the selected tab's text
            unselectedLabelColor: Colors.white,
            splashFactory: NoSplash.splashFactory,// Color for unselected tabs' text
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Status'),
              Tab(text: 'Capture'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            Column(
              children: [
                // Display user's name and email
                Column(
                  children: [
                    // Display user's name
                    Text(
                      'Logged in as: ${nameController.text}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: myTextColor,
                      ),
                    ),
                    // Display user's email
                    Text(
                      'Email: ${emailController.text}',
                      style: TextStyle(
                          fontSize: 16,
                          color: myTextColor),
                    ),
                  ],
                ),
                Expanded(
                  child: _buildUserList(),
                )
              ],
            ),
            // Content for status tab
            const Column(
              children: [
                Expanded(
                  child: StatusPage(userId: '',),
                ),
              ],
            ),
            const Column(
              children: [
                Expanded(
                  child: ImageClassificationPage(),
                ),
              ],
            ),
          ],
        ),

        //Add a Drawer for sidebar navigation
        drawer: Drawer(
          backgroundColor: const Color(0xFF00008B),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: profilePictureUrl != null &&
                            profilePictureUrl.isNotEmpty ?
                        NetworkImage(profilePictureUrl!) :
                        const AssetImage('assets/logo.png') as
                        ImageProvider<Object>,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nameController.text, // Display the user's name
                            style: const TextStyle(
                              fontSize: 25,
                              color: Color(0xF6F5F5FF),
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Text(
                            '@' + usernameController.text, // Display the user's username
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xF6F5F5FF),
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Align(
                            alignment: Alignment.centerLeft, // Adjust alignment as needed
                            child: ElevatedButton(
                              onPressed: () async {
                                // Navigate to the edit profile page
                                bool result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ),
                                );

                                print("this is the save changes $result");
                                if(result){
                                  fetchUserData();
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Color(0xF6F5F5FF),
                                      fontSize: 20,
                                    ),
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              ListTile(
                leading: const Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 30,
                    color:Color(0xF6F5F5FF),
                  ),
                ),
                selected: _selectedIndex == 0,
                onTap: (){
                  // Update the state of the app
                  _onItemTapped(0);
                  // then close the drawer
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPageUI()
                    ),
                  );
                },
              ),

              const SizedBox(height: 8,),


              ListTile(
                leading: const Icon(
                  Icons.app_settings_alt_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(1);
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => const ThemePage()
                    ),
                  );
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.chat_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(2);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Notifications',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 3,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(3);
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotiPage())
                  );
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.question_mark_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Help',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 4,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(4);
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) {
                        return const HelpCenter();
                      },
                        settings: const RouteSettings(name: 'HelpCenter',),
                      )
                  );
                },
              ),
              const SizedBox(height: 8,),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Color(0xF6F5F5FF),
                  size: 40,
                ),
                title: const Text('Sign Out',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xF6F5F5FF),),
                ),
                selected: _selectedIndex == 5,
                onTap: () async {
                  // Update the state of the app
                  _onItemTapped(5);
                  // Then close the drawer
                  Navigator.pop(context);

                  try{
                    await FirebaseAuth.instance.signOut();
                    // Navigate to login page after signed out
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(onTap: () {})));
                  }
                  catch (e){
                    print("Error signing out: ${e}");
                  }
                },
              ),
              const SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }

  //build a list of users for the current logged in users.
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Text('Error');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('loading . . .');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    bool isCurrentUser = _auth.currentUser!.email == data['name'];
    int status = data['status'] ?? 1; // Default to 1 (active) if status is not presented
    // Check if a profile picture URL is available
    String profilePictureUrl = data['profilePictureUrl'] ?? '';

    if(status == 1 &&_auth.currentUser!.email != data['name']){
      return Dismissible(
        key: Key(document.id), // Unique key for Dismissible
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
              Icons.delete,
              color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          softDeleteUser(document.id);
          // Below code is a permanent delete inside firestore
          // FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(document.id)
          //     .delete();
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text("Successfully deleted"),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: profilePictureUrl.isNotEmpty
                ? NetworkImage(profilePictureUrl)
                : AssetImage('assets/logo.png') as ImageProvider,
            backgroundColor: Colors.blueGrey,
          ),
          title: Text(
            data['name'],
            style: TextStyle(
              color: isCurrentUser
                  ? Colors.deepOrange : myTextColor,
              fontSize: isCurrentUser ? 25.0 : 20.0,
            ),
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(
                receiverName: data['name']?? '',
                receiverUserID: document.id?? '',
                senderprofilePicUrl: data['profilePicUrl']?? '',
              )),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}