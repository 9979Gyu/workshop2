import 'package:flutter/material.dart';
import 'package:glaucotalk/pages/settings/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../../components/Theme_Button.dart';
import '../../../components/box.dart';
import '../../homepage.dart';

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
                MaterialPageRoute(
                    builder: (context) => HomePage()));
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
