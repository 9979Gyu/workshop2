
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chats").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError){
            return const Center(child: Text("Something went wrong.."),);
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: Text("Loading"),
            );
          }

          if(snapshot.hasData){
            return CustomScrollView(
              slivers: [
                const CupertinoSliverNavigationBar(
                  largeTitle: Text("Chats"),
                ),
                SliverList(delegate: SliverChildListDelegate(
                  snapshot.data!.docs.map((DocumentSnapshot document){
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return CupertinoListTile(
                        title: Text(data['title'])
                    );
                  }).toList(),
                ),
                ),
              ],
            );
          }

          return Container();
        });
  }
}
