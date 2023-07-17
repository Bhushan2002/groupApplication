import 'package:flutter/material.dart';

class ThemeColor{
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    hintColor: Colors.green,
    cardColor: Colors.black12,
    fontFamily: 'Roboto',
    // Add other customizations here
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal,
    hintColor: Colors.orange,
    cardColor: Colors.black26,
    appBarTheme: AppBarTheme(backgroundColor: Color(0xf2E1A47)),
    fontFamily: 'Roboto',
    // Add other customizations here
  );
}