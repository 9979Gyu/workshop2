import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/chat_page.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class VolSearchPage extends StatefulWidget {
  const VolSearchPage({Key? key}) : super(key: key);

  @override
  State<VolSearchPage> createState() => _VolSearchPageState();
}

class _VolSearchPageState extends State<VolSearchPage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Color myCustomColor = const Color(0xFF00008B);
  Color myTextColor = const Color(0xF6F5F5FF);

  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String username = "";
  String email = '';
  bool isJoined = false;
  User? user;


  @override
  void initState(){
    super.initState();

  }

  Future<void> searchUsers() async {
    final String nameText = nameController.text;
    final String emailText = emailController.text;
    final String usernameText = usernameController.text;
    late QuerySnapshot userSnapshot;

    if (usernameText.isNotEmpty) {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: usernameText)
          .get();
    }
    else {
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: nameText)
          .where('email', isEqualTo: emailText)
          .get();
    }

    if(userSnapshot.size > 0){
      setState(() {
        searchSnapshot = userSnapshot;
        hasUserSearched = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isNightMode = Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(

              fontSize: 25,
              fontWeight: FontWeight.w600
          ),
        ),

        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,

                decoration: const InputDecoration(
                  labelText: "Search by Username",
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12,),
              ElevatedButton(
                onPressed: searchUsers,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[700],
                    elevation: 10,
                    shape: const StadiumBorder()
                ),
                child: const Text(
                  "Search",
                  style: TextStyle(
                      color: Color(0xF6F5F5FF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),

              if(hasUserSearched)
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Search Results:',
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,

                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0,),

                      // Using ListView.builder to display information for each document
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchSnapshot!.docs.length,
                        itemBuilder: (context, index) {
                          // Accessing data from each document
                          Map<String, dynamic> userData =
                          searchSnapshot!.docs[index].data()
                          as Map<String, dynamic>;
                          return ListTile(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          receiverName: userData['name'],
                                          receiverUserID:
                                          searchSnapshot!.docs[index].id,
                                          senderprofilePicUrl:
                                          userData['profilePictureUrl']
                                      )
                                  )
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                              userData['profilePictureUrl'] != null &&
                                  userData['profilePictureUrl'].isNotEmpty ?
                              NetworkImage(userData['profilePictureUrl']!) :
                              const AssetImage('assets/logo.png') as
                              ImageProvider<Object>,
                              backgroundColor: Colors.grey,
                            ),
                            title: Text(
                              userData['name'] ?? '',
                              style: const TextStyle(

                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Username: ${userData['username']}',
                                  style: const TextStyle(

                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Email: ${userData['email']}',
                                  style: const TextStyle(

                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if(!hasUserSearched)
                const Text(
                  'Please perform a search.',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}