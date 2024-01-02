import 'package:workshop2/pages/setting/theme/theme_provider.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness:  Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade500,
    primary: Colors.grey.shade300,
    secondary: Colors.grey,
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.green.shade900,
        primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
  )
);

