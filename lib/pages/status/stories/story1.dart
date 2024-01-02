import 'package:flutter/material.dart';

class MyStory1 extends StatelessWidget {
  const MyStory1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/images/winter.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
