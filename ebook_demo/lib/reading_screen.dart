import 'package:flutter/material.dart';
import 'book.dart';

class ReadingScreen extends StatefulWidget {
  final String bookTitle;
  final String chapterTitle;
  final String content;

  const ReadingScreen({
    super.key,
    required this.bookTitle,
    required this.chapterTitle,
    required this.content,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  // Tao id duy nhat
  late String bookmarkId;

  @override
  void initState() {
    super.initState();

    // Ghep ten sach va ten chuong
    bookmarkId = "${widget.bookTitle} - ${widget.chapterTitle}";
  }

  @override
  Widget build(BuildContext context) {
    // kiem tra chuong cua sach da bookmark chua
    bool isBookmarked = bookmarkedChapters.contains(bookmarkId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookTitle),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.amber : null, // bookmark mau vang
            ),
            onPressed: () {
              setState(() {
                if (isBookmarked) {
                  bookmarkedChapters.remove(bookmarkId); // Xoa bookmark
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã xóa đánh dấu")),
                  );
                } else {
                  bookmarkedChapters.add(bookmarkId); // Them bookmark
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã đánh dấu trang thành công!")),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chapterTitle,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.content,
                style: const TextStyle(fontSize: 18, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}