import 'package:flutter/material.dart';
import 'screen.dart';

void main() {
  runApp(const ApiPoweredApp());
}

class ApiPoweredApp extends StatelessWidget {
  const ApiPoweredApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - REST API Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const PostListScreen(),
    );
  }
}