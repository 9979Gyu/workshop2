import 'package:workshop2/components/Theme_Button.dart';
import 'package:workshop2/components/box.dart';
import 'package:workshop2/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop2/pages/setting/theme/theme_provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: MyBox(
          color: Theme.of(context).colorScheme.primary,
          child: THButton(
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },

          )
        ),
      ),
    );
  }
}
