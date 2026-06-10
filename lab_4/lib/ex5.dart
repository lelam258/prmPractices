import 'package:flutter/material.dart';

class CommonUIFixes extends StatefulWidget {
  const CommonUIFixes({super.key});

  @override
  State<CommonUIFixes> createState() => _CommonUIFixesState();
}

class _CommonUIFixesState extends State<CommonUIFixes> {
  int _counter = 0;
  final List<String> fixMovies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 – Common UÍ')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Correct ListView inside Column using Expanded',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: fixMovies.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.movie),
                      title: Text(fixMovies[index]),
                    );
                  },
                ),
              ),

              const Divider(height: 40),
              const Text('State Update Fix:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Counter Value: $_counter', style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _counter++;
                      });
                    },
                    child: const Text('Increment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}