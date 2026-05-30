import 'package:flutter/material.dart';
import 'book.dart';
import 'reading_screen.dart';

class DetailScreen extends StatelessWidget {
  final Book book;

  const DetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Hien thi thong tin sach
          Center(
            child: Image.asset(
              book.coverUrl,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(book.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text("Tác giả: ${book.author}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const Divider(height: 30, thickness: 1),
          const Text("MỤC LỤC", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // danh sach cac chuong
          Expanded(
            child: ListView.builder(
              itemCount: book.chapters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text("Chương ${index + 1}"),
                  onTap: () {
                    // sang man doc sach
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingScreen(
                          bookTitle: book.title,
                          chapterTitle: "Chương ${index + 1}",
                          content: book.chapters[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}