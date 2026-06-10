import 'package:flutter/material.dart';
import 'json_db_screen_state.dart';

void main() {
  runApp(const LocalStorageApp());
}

class LocalStorageApp extends StatelessWidget {
  const LocalStorageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const JsonDatabaseScreen(),
    );
  }
}


