import 'package:flutter/material.dart';
import 'movie.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String _searchQuery = '';
  final Set<String> _selectedGenres = {};
  String _selectedSort = 'A-Z';

  final List<String> _availableGenres = [
    'Action', 'Adventure', 'Animation', 'Comedy', 'Crime', 'Drama', 'Family', 'Sci-Fi', 'Thriller'
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Movie> _getFilteredAndSortedMovies() {
    List<Movie> filtered = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesGenre = _selectedGenres.isEmpty ||
          movie.genres.any((genre) => _selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    if (_selectedSort == 'A-Z') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else if (_selectedSort == 'Z-A') {
      filtered.sort((a, b) => b.title.compareTo(a.title));
    } else if (_selectedSort == 'Year') {
      filtered.sort((a, b) => b.year.compareTo(a.year));
    } else if (_selectedSort == 'Rating') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return filtered;
  }
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = 'A-Z';
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = _getFilteredAndSortedMovies();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Find a Movie',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  if (_searchQuery.isNotEmpty || _selectedGenres.isNotEmpty)
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Clear Filters'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search movies by title...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Genres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (_selectedGenres.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        '${_selectedGenres.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  ]
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _availableGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                    selectedColor: Colors.deepPurple.withOpacity(0.2),
                    checkmarkColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results (${visibleMovies.length})',
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.sort, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _selectedSort,
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedSort = newValue;
                            });
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'A-Z', child: Text('Sort: A–Z')),
                          DropdownMenuItem(value: 'Z-A', child: Text('Sort: Z–A')),
                          DropdownMenuItem(value: 'Year', child: Text('Sort: Year')),
                          DropdownMenuItem(value: 'Rating', child: Text('Sort: Rating')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: visibleMovies.isEmpty
                    ? const Center(child: Text('No movies match your criteria.', style: TextStyle(fontSize: 16)))
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(movie: visibleMovies[index], isTablet: false);
                        },
                      );
                    } else {
                      return GridView.builder(
                        itemCount: visibleMovies.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 140,
                        ),
                        itemBuilder: (context, index) {
                          return MovieCard(movie: visibleMovies[index], isTablet: true);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isTablet;

  const MovieCard({super.key, required this.movie, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final cardMargin = isTablet ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16.0);

    return Card(
      margin: cardMargin,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, cardConstraints) {
          final double imageWidth = isTablet ? 100 : 120;
          return Row(
            children: [
              Image.network(
                movie.posterUrl,
                width: imageWidth,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageWidth,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Year: ${movie.year}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.genres.join(', '),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.rating} / 10',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}