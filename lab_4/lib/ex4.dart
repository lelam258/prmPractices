import 'package:flutter/material.dart';

class AppStructureTheme extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final ThemeMode currentThemeMode;

  const AppStructureTheme({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 – App Structure'),
        actions: [
          Row(
            children: [
              const Text('Dark'),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  onThemeChanged(value);
                },
              ),
            ],
          )
        ],
      ),
      body: const Center(
        child: Text(
          'This is a simple screen with theme toggle.',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FloatingActionButton Pressed!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}