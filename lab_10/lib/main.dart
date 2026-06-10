import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  try {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } catch (e) {
    debugPrint("Bỏ qua lỗi khởi tạo notification trên môi trường không hỗ trợ: $e");
  }

  runApp(const IntegratedAuthApp());
}

class IntegratedAuthApp extends StatelessWidget {
  const IntegratedAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 - Full Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const SplashScreen(),
    );
  }
}