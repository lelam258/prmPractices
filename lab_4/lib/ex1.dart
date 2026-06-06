import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 – Core Widge...')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Headline Text
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 2. Icon Material
            const Center(
              child: Icon(
                  Icons.movie_creation_outlined,
                  size: 80,
                  color: Colors.blue
              ),
            ),
            const SizedBox(height: 20),

            // 3. Image.network
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://images.unsplash.com/photo-1535914254981-b5012eebbd15?w=600',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Loi anh
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. ListTile
            Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.black54),
                title: const Text('Movie Item'),
                subtitle: const Text('This is a sample ListTile inside a Card.'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}