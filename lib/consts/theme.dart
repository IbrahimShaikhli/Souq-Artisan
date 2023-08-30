import 'package:flutter/material.dart';

class ThemeDat {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.black, // Change this to your primary color
    hintColor: Colors.grey, // Change this to your accent color
    fontFamily: 'sans_regular', // Replace 'ModernFont' with your desired font family

    textTheme: const TextTheme(
      // Body text style
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),

      // Headline text style
      titleLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),

      // Add more text styles here
      titleMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      ),

      titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      ),

      labelLarge: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),

      bodySmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.black54,
      ),
    ),
  );
}
