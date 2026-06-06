class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final double rating;
  final List<String> genres;
  final String overview;
  final List<String> trailers;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.genres,
    required this.overview,
    required this.trailers,
    this.isFavorite = false,
  });
}

final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Dune: Part Two',
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600', // Ảnh minh họa không gian/sa mạc
    rating: 8.6,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    trailers: ['Official Trailer #1', 'IMAX Sneak Peek'],
  ),
  Movie(
    id: '2',
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600', // Ảnh minh họa tone tối/hành động
    rating: 8.3,
    genres: ['Action', 'Comedy'],
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    trailers: ['Red Band Trailer', 'Behind the Scenes'],
  ),
];