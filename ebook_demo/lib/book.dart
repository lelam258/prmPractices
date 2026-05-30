class Book{
  final String title;
  final String author;
  final String coverUrl;
  final List<String> chapters;

  Book({required this.title, required this.author, required this.coverUrl, required this.chapters});
}
final Set<String> bookmarkedChapters = {};