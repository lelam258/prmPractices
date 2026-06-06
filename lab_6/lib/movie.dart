class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = [
  Movie(
    title: 'Dune: Part Two',
    year: 2024,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400',
    rating: 8.6,
  ),
  Movie(
    title: 'Deadpool & Wolverine',
    year: 2024,
    genres: ['Action', 'Comedy', 'Sci-Fi'],
    posterUrl: 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=400',
    rating: 8.3,
  ),
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=400',
    rating: 9.0,
  ),
  Movie(
    title: 'Toy Story 4',
    year: 2019,
    genres: ['Animation', 'Comedy', 'Family'],
    posterUrl: 'https://images.unsplash.com/photo-1608889175123-8ec330b86f84?w=400',
    rating: 7.7,
  ),
];