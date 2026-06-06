import 'package:flutter/material.dart';
import 'movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  movie.posterUrl,
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: movie.genres.map((genre) {
                  return Chip(
                    label: Text(genre, style: const TextStyle(color: Colors.black87)),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                movie.overview,
                style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: movie.isFavorite ? Colors.red : Colors.black54,
                    label: 'Favorite',
                    onTap: () {
                      setState(() {
                        movie.isFavorite = !movie.isFavorite;
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.star_border,
                    label: 'Rate',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5. Danh sách các đoạn Trailer phim (Step 4.6)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Trailers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movie.trailers.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    <Widget>[
                    ListTile(
                      leading: const Icon(Icons.play_circle_fill, size: 32, color: Colors.black54),
                      title: Text(
                        movie.trailers[index],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                  ][0],
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black54
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}