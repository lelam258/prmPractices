import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'post.dart';
import 'screen.dart';

void main() {
  runApp(const ApiNetworkApp());
}
class ApiNetworkApp extends StatelessWidget {
  const ApiNetworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - API Powered App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF6F8FA),
      ),
      home: const PostListScreen(),
    );
  }
}