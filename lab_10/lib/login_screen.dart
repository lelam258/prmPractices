
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');

  bool _isLoading = false;
  bool _obscurePassword = true;
  Future<void> _triggerLocalNotification(String username) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'auth_channel_id',
      'Authentication Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Access Granted! 🎉',
      'Welcome back, $username. Secure session initialized.',
      platformChannelSpecifics,
    );
  }
  Future<void> _loginWithRealAPI() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
          'expiresInMins': 60,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String token = data['token'] ?? '';
        final String firstName = data['firstName'] ?? data['username'] ?? 'User';
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', firstName);
        await _triggerLocalNotification(firstName);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(token: token, loginMethod: 'DummyJSON REST API'),
          ),
        );
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        _showErrorSnackBar(errorData['message'] ?? 'Invalid username or password');
      }
    } catch (e) {
      _showErrorSnackBar('Network error or invalid data format: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', 'MOCK_GOOGLE_TOKEN_XYZ123');
    await prefs.setString('user_name', 'Google User');

    await _triggerLocalNotification('Google User');

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(token: 'MOCK_GOOGLE_TOKEN_XYZ123', loginMethod: 'Firebase Google Auth'),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.lock_person_rounded, size: 55, color: Colors.indigo),
                      const SizedBox(height: 12),
                      const Text(
                        'Account Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter username' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter password' : null,
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _loginWithRealAPI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Sign In via API', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('OR', style: TextStyle(color: Colors.grey))),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),

                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _loginWithGoogle,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.red),
                        label: const Text('Continue with Google Auth', style: TextStyle(fontSize: 15, color: Colors.black87)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}