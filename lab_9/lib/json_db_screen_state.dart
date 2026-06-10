import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
class JsonDatabaseScreen extends StatefulWidget {
  const JsonDatabaseScreen({super.key});

  @override
  State<JsonDatabaseScreen> createState() => _JsonDatabaseScreenState();
}

class _JsonDatabaseScreenState extends State<JsonDatabaseScreen> {
  List<dynamic> _moviesList = [];
  List<dynamic> _filteredMoviesList = [];

  String _searchQuery = '';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataAtStartup();
  }
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory(); // path_provider
    return File('${directory.path}/local_movies.json');
  }

  Future<void> _loadDataAtStartup() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          _moviesList = jsonDecode(contents);
          _filteredMoviesList = _moviesList;
          _isLoading = false;
        });
      } else {
        await _importFromAssets();
      }
    } catch (e) {
      _showSnackBar('Error loading local data: $e', Colors.red);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _importFromAssets() async {
    setState(() => _isLoading = true);
    try {
      String jsonString = await rootBundle.loadString('assets/data/movies.json');
      List<dynamic> decodedData = jsonDecode(jsonString);

      setState(() {
        _moviesList = decodedData;
        _filteredMoviesList = _moviesList;
        _isLoading = false;
      });
      await _autoSaveToStorage();
      _showSnackBar('Data successfully loaded from Assets!', Colors.green);
    } catch (e) {
      _showSnackBar('Failed to read assets JSON: $e', Colors.red);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _autoSaveToStorage() async {
    try {
      final file = await _getLocalFile();
      String rawJson = jsonEncode(_moviesList);
      await file.writeAsString(rawJson);
      _filterMovies(_searchQuery);
    } catch (e) {
      _showSnackBar('Auto-save failed: $e', Colors.red);
    }
  }
  void _filterMovies(String query) {
    setState(() {
      _searchQuery = query;
      if (query.trim().isEmpty) {
        _filteredMoviesList = _moviesList;
      } else {
        _filteredMoviesList = _moviesList.where((movie) {
          final title = movie['title'].toString().toLowerCase();
          final genre = movie['genre'].toString().toLowerCase();
          return title.contains(query.toLowerCase()) || genre.contains(query.toLowerCase());
        }).toList();
      }
    });
  }
  void _addMovie(String title, String genre, String year) {
    setState(() {
      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString().substring(7);

      _moviesList.add({
        "id": uniqueId,
        "title": title,
        "genre": genre,
        "year": year,
      });
    });
    _autoSaveToStorage();
    _showSnackBar('Added "$title" to database.', Colors.blue);
  }

  void _editMovie(String id, String newTitle, String newGenre, String newYear) {
    setState(() {
      int index = _moviesList.indexWhere((m) => m['id'] == id);
      if (index != -1) {
        _moviesList[index] = {
          "id": id,
          "title": newTitle,
          "genre": newGenre,
          "year": newYear,
        };
      }
    });
    _autoSaveToStorage();
    _showSnackBar('Movie information updated.', Colors.orange);
  }
  void _deleteMovie(String id, String title) {
    setState(() {
      _moviesList.removeWhere((m) => m['id'] == id);
    });
    _autoSaveToStorage();
    _showSnackBar('Removed "$title" from system.', Colors.redAccent);
  }
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  void _showMovieFormDialog({Map<String, dynamic>? existingMovie}) {
    final bool isEditMode = existingMovie != null;
    final titleCtrl = TextEditingController(text: isEditMode ? existingMovie['title'] : '');
    final genreCtrl = TextEditingController(text: isEditMode ? existingMovie['genre'] : '');
    final yearCtrl = TextEditingController(text: isEditMode ? existingMovie['year'] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditMode ? 'Edit Movie Details' : 'Add New Movie'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Movie Title', prefixIcon: Icon(Icons.movie)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: genreCtrl,
                decoration: const InputDecoration(labelText: 'Genre', prefixIcon: Icon(Icons.category)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: yearCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Release Year', prefixIcon: Icon(Icons.calendar_today)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty || genreCtrl.text.isEmpty || yearCtrl.text.isEmpty) {
                _showSnackBar('Please fill in all fields', Colors.amber[800]!);
                return;
              }
              if (isEditMode) {
                _editMovie(existingMovie['id'], titleCtrl.text, genreCtrl.text, yearCtrl.text);
              } else {
                _addMovie(titleCtrl.text, genreCtrl.text, yearCtrl.text);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            child: Text(isEditMode ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(String id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [Icon(Icons.warning_amber_rounded, color: Colors.red), SizedBox(width: 8), Text('Confirm Delete')],
        ),
        content: Text('Are you sure you want to permanently erase "$title" from local database storage?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _deleteMovie(id, title);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Local Database', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Reset from Assets JSON',
            onPressed: _importFromAssets,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterMovies,
                decoration: InputDecoration(
                  hintText: 'Search by title or genre...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterMovies('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Items: ${_filteredMoviesList.length}', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                if (_searchQuery.isNotEmpty)
                  const Text('Filtering active', style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredMoviesList.isEmpty
                  ? const Center(child: Text('No matching items found in JSON database.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                itemCount: _filteredMoviesList.length,
                itemBuilder: (context, index) {
                  final movie = _filteredMoviesList[index];
                  return Card(
                    color: Colors.white,
                    elevation: 0.5,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        foregroundColor: Colors.blueAccent,
                        child: const Icon(Icons.movie_filter_rounded),
                      ),
                      title: Text(movie['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('Genre: ${movie['genre']} • Year: ${movie['year']}', style: TextStyle(color: Colors.grey[600])),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 22),
                            onPressed: () => _showMovieFormDialog(existingMovie: movie),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                            onPressed: () => _showDeleteConfirmDialog(movie['id'], movie['title']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMovieFormDialog(),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Movie'),
      ),
    );
  }
}