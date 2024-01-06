import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glaucotalk/components/Theme_Button.dart';
import 'package:glaucotalk/components/box.dart';
import 'package:glaucotalk/pages/home_page.dart';
import 'package:glaucotalk/pages/setting/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../volunteer_homepage.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isNightMode = Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Display & Brightness", style: TextStyle(fontSize: 22)),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VolHomePage()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,

          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  Icons.light_mode,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  "Appearance",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            buildAppearanceOption(
              "Night Mode",
              isNightMode,
                  (bool newValue) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildAppearanceOption(
      String title,
      bool value,
      Function(bool) onChangeMethod,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }
}