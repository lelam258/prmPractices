import 'package:flutter/material.dart';

import 'signup_screen.dart';

void main() {
  runApp(const ResponsiveFormApp());
}

class ResponsiveFormApp extends StatelessWidget {
  const ResponsiveFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Registration Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F7F8),
      ),
      home: const SignupScreen(),
    );
  }
}
