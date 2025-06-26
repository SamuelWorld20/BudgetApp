// main.dart
import 'package:flutter/material.dart';
import 'package:budgetapp/splash_screen.dart';

void main() {
  runApp(const MyApp()); // Run the root app widget
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Budget App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // Ensure 'Inter' font is available or use a system default
      ),
      home: const SplashScreen(), // This is the only widget displayed initially
    );
  }
}
