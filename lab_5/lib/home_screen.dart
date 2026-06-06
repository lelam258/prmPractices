import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                // Điều hướng sang màn hình chi tiết và truyền object dữ liệu (Step 3)
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                  // Gọi setState khi quay về để cập nhật lại icon Favorite nếu có thay đổi
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Hiển thị Poster phim dạng bo góc
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          movie.posterUrl,
                          width: 110,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Hiển thị Tiêu đề và Thông tin tóm tắt bên phải
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '⭐ ${movie.rating} • ${movie.genres.join(", ")}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}