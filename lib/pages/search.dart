import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Color(0xF6F5F5FF)),
                decoration: const InputDecoration(
                  labelText: "Search by Username",
                  labelStyle: TextStyle(color: Color(0xF6F5F5FF)),
                ),
              ),
              const SizedBox(height: 12,),
              ElevatedButton(
                onPressed: searchUsers,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
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
                            color: myTextColor,
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
                                color: Color(0xF6F5F5FF),
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
                                    color: Color(0xF6F5F5FF),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Email: ${userData['email']}',
                                  style: const TextStyle(
                                    color: Color(0xF6F5F5FF),
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
                  style: TextStyle(color: Color(0xF6F5F5FF)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
