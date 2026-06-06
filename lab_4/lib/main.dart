import 'package:flutter/material.dart';
import 'ex1.dart';
import 'ex2.dart';
import 'ex3.dart';
import 'ex4.dart';
import 'ex5.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F7FA),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      themeMode: _themeMode,
      home: MainMenuScreen(onThemeChanged: toggleTheme, currentThemeMode: _themeMode),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final ThemeMode currentThemeMode;

  const MainMenuScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {'title': 'Exercise 1 – Core Widgets Demo', 'screen': const CoreWidgetsDemo()},
      {'title': 'Exercise 2 – Input Controls Demo', 'screen': const InputControlsDemo()},
      {'title': 'Exercise 3 – Layout Demo', 'screen': const LayoutDemo()},
      {
        'title': 'Exercise 4 – App Structure & Theme',
        'screen': AppStructureTheme(onThemeChanged: onThemeChanged, currentThemeMode: currentThemeMode)
      },
      {'title': 'Exercise 5 – Common UI Fixes', 'screen': const CommonUIFixes()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundament...'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: exercises.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                title: Text(
                  exercises[index]['title'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => exercises[index]['screen']),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}