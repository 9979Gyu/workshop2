import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/camera/vol_camera.dart';
import 'package:glaucotalk/pages/chat_page.dart';
import 'package:glaucotalk/pages/profile_page.dart';
import 'package:glaucotalk/pages/search.dart';
import 'package:glaucotalk/pages/setting/Notification%20page/noti_page.dart';
import 'package:glaucotalk/pages/setting/account_center.dart';
import 'package:glaucotalk/pages/setting/help_center.dart';
import 'package:glaucotalk/pages/setting/theme/Apparance.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:glaucotalk/pages/setting/vol_accountCenter.dart';
import 'package:glaucotalk/pages/setting/vol_help_center.dart';
import 'package:glaucotalk/pages/status/story_page.dart';
import 'package:glaucotalk/pages/status/vol_addStory.dart';
import 'package:glaucotalk/pages/status/volunteer_statusPage.dart';
import 'package:glaucotalk/pages/vol_chat_page.dart';
import 'package:glaucotalk/pages/vol_profile_page.dart';
import 'package:glaucotalk/pages/volunteer_search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../autherization/user/login_user.dart';
import '../autherization/volunteer/login_volunteer.dart';
import '../database/auth_service.dart';


class VolHomePage extends StatefulWidget {
  VolHomePage({Key? key}) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  State<VolHomePage> createState() => _VolHomePageState();
}

class _VolHomePageState extends State<VolHomePage> {
  String profilePictureUrl = '';
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  late CameraDescription? firstCamera;

  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  late Timer timer;

  int _selectedIndex = 0;

  void navigateToTakePictureScreen(BuildContext context, CameraDescription? camera) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VolTakePictureScreen(
          camera: camera!,
          onSavePicture: (XFile? xFile) {},
          //onSavePicture: savePictureToStorage,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    } else {
      // handle the case when there is no camera available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Camera Available'),
        ),
      );
    }
  }

  // sign user out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> fetchUserData() async {
    try {
      // get the current user's ID
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // fetch the user's document from firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // Extract and set user data to the respective TextEditingController
        setState(() {
          nameController.text = userDoc['name'];
          usernameController.text = userDoc['username'];
          emailController.text = userDoc['email'];

          // set the profile picture URL from firestore
          profilePictureUrl = userDoc['profilePictureUrl'];
          // set other fields similarly
        });

        print("This is the profile picture URL : ${profilePictureUrl}");
      } else {
        print("Data does not exist");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isNightMode = Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark;
    return DefaultTabController(
        length: 2,
    child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Center(
          child: Text(
            "Message",
            style: GoogleFonts.aBeeZee(
              textStyle: const TextStyle(

                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          // Search Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VolSearchPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.search_sharp,
              size: 20,

            ),
          ),
          IconButton(
            onPressed: () {
              navigateToTakePictureScreen(context, firstCamera!);
            },
            icon: const Icon(
              Icons.camera_alt,
              ),
          ),
        ],
      ),

      body: TabBarView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title 'Stories'
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Stories',
                  style: TextStyle(

                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Story View (Added as the second child in TabBarView)
              Container(
                height: 85, // Adjust height as needed
                child: VolStatusPage(userId: '',), // Replace 'YourStoryViewWidget()' with your story view implementation
              ),

              // Display user's name and email
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  children: [
                    // Display current user's name
                    Text(
                      'Logged in as ${nameController.text}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,

                      ),
                      textAlign: TextAlign.center, // Center text within the column
                    ),
                    // Display current user's email
                    Text(
                      '${emailController.text}',
                      style: TextStyle(
                        fontSize: 14,

                      ),
                      textAlign: TextAlign.center, // Center text within the column
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildUserList(),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VolAddStoryPage(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent[700],
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),

      // Add a drawer for a sidebar navigation
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            DrawerHeader(
                child: Row(
                  children: [
                    Expanded(child: CircleAvatar(
                      radius: 35,
                      backgroundImage: profilePictureUrl != null &&
                          profilePictureUrl.isNotEmpty
                          ? NetworkImage(profilePictureUrl!)
                          : const AssetImage('assets/logo.png') as
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
                            nameController.text,
                            style: const TextStyle(
                              fontSize: 20,

                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@${usernameController.text}',
                            style: const TextStyle(
                              fontSize: 18,

                            ),
                          ),
                          const SizedBox(height: 8,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Navigate to Edit Profile
                                bool result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => const VolProfilePage(),
                                    ),
                                );

                                print('This is the save changes: $result');
                                if(result){
                                  fetchUserData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigoAccent,
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Color(0xF6F5F5FF),
                                      fontSize: 18,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
            ),

            const SizedBox(height: 5),

             ListTile(
              leading: const Icon(
                Icons.account_circle_rounded,
                size: 40,

              ),
              title: Text(
                'Account',
                style: GoogleFonts.robotoCondensed(
                  textStyle: const TextStyle(

                    fontSize: 30,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
               selected: _selectedIndex == 0,
               onTap: () {
                // Update the state of the app
                 _onItemTapped(0);
                 // Close the drawer
                 Navigator.pop(context);
                 Navigator.push(context,
                   MaterialPageRoute(
                       builder: (context) => const VolSettingPageUI()
                   ),
                 );
               },
            ),

            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(
                Icons.app_settings_alt_outlined,

                size: 40,
              ),
              title: Text(
                'Appearance',
                style: GoogleFonts.robotoCondensed(
                  textStyle: const TextStyle(

                      fontSize: 30,
                      fontWeight: FontWeight.w600
                  ),
                ),
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

                size: 40,
              ),
              title: Text(
                'Chats',
                style: GoogleFonts.robotoCondensed(
                  textStyle: const TextStyle(

                      fontSize: 30,
                      fontWeight: FontWeight.w600
                  ),
                ),
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

                size: 40,
              ),
              title: Text(
                'Notifications',
                style: GoogleFonts.robotoCondensed(
                  textStyle: const TextStyle(

                      fontSize: 30,
                      fontWeight: FontWeight.w600
                  ),
                ),
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

                size: 40,
              ),
              title: Text(
                'Help',
                style: GoogleFonts.robotoCondensed(
                  textStyle: const TextStyle(

                      fontSize: 30,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              selected: _selectedIndex == 4,
              onTap: () {
                // Update the state of the app
                _onItemTapped(4);
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) {
                      return const VolHelpCenter();
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

                size: 40,
              ),
              title: Text(
                'Sign Out',
                style: GoogleFonts.robotoCondensed(
                  textStyle: const TextStyle(

                      fontSize: 30,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              selected: _selectedIndex == 5,
              onTap: () async {
                // Show confirmation dialog
                bool confirmLogout = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    );
                  },
                ) ?? false; // The ?? false is used in case the dialog is dismissed without any button being pressed

                // Check confirmation and perform sign out
                if (confirmLogout) {
                  try {
                    await FirebaseAuth.instance.signOut();
                    // Navigate to login page after signed out
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(onTap: () {})),
                          (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    print("Error signing out: $e");
                  }
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

  // build a list of users for the current logged in users
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

    // Using a ValueNotifier to handle image loading state
    ValueNotifier<bool> useDefaultImage = ValueNotifier<bool>(false);

    // Check if a profile picture URL is available
    String? profilePictureUrl = data['profilePictureUrl'] ?? '';

    // // If no URL available, set to use default image to true
    // if (profilePictureUrl.isEmpty){
    //   useDefaultImage.value = true;
    // }
    //

    // display all users except current user
    if(_auth.currentUser!.email != data['email']){
      return ListTile(
      leading: CircleAvatar(
        backgroundImage: profilePictureUrl != null && profilePictureUrl.isNotEmpty
            ? NetworkImage(profilePictureUrl)
            : AssetImage('assets/logo.png') as ImageProvider,
        backgroundColor: Colors.blueGrey,
      ),
        title: Text(
          data['name'],
          style: TextStyle(fontSize: 18),
        ),
        onTap: (){
          // pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VolChatPage(
              receiverName: data['name'] ?? '',
              receiverUserID: document.id?? '',
              senderprofilePicUrl: data['profilePicUrl'] ?? '',
            ),
            ),
          );
        },
      );
    } else{
      // Return empty container
      return Container();
    }
  }
}
