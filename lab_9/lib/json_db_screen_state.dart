import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

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

  // ===========================================================================
  // TẦNG XỬ LÝ LOGIC FILE (STORAGE SERVICE LAYER - Lab 9.2 & Lab 9.3)
  // ===========================================================================

  // Hàm lấy đường dẫn tệp JSON trong thư mục tài liệu của ứng dụng trên thiết bị (Lab 9.2 - Step 2)
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory(); // path_provider
    return File('${directory.path}/local_movies.json');
  }

  // Hàm nạp dữ liệu khi khởi chạy ứng dụng (Lab 9.2 - Step 3)
  Future<void> _loadDataAtStartup() async {
    try {
      final file = await _getLocalFile();

      // Nếu tệp tin cục bộ đã tồn tại, tiến hành đọc tệp
      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          _moviesList = jsonDecode(contents);
          _filteredMoviesList = _moviesList;
          _isLoading = false;
        });
      } else {
        // Nếu ứng dụng chạy lần đầu chưa có file, tự động nạp từ bản mã Assets (Lab 9.1 kết hợp)
        await _importFromAssets();
      }
    } catch (e) {
      _showSnackBar('Error loading local data: $e', Colors.red);
      setState(() => _isLoading = false);
    }
  }

  // Lab 9.1: Đọc dữ liệu JSON thô từ thư mục tệp nhúng Assets công khai
  Future<void> _importFromAssets() async {
    setState(() => _isLoading = true);
    try {
      // Đọc tệp văn bản từ assets thông qua rootBundle
      String jsonString = await rootBundle.loadString('assets/data/movies.json');
      List<dynamic> decodedData = jsonDecode(jsonString);

      setState(() {
        _moviesList = decodedData;
        _filteredMoviesList = _moviesList;
        _isLoading = false;
      });

      // Đồng bộ lưu đè ngay vào tệp hệ thống thiết bị để sẵn sàng thực hiện CRUD
      await _autoSaveToStorage();
      _showSnackBar('Data successfully loaded from Assets!', Colors.green);
    } catch (e) {
      _showSnackBar('Failed to read assets JSON: $e', Colors.red);
      setState(() => _isLoading = false);
    }
  }

  // Lab 9.2 & 9.3: Hàm tự động mã hóa và ghi dữ liệu đè lại vào File hệ thống thiết bị (Auto-Save)
  Future<void> _autoSaveToStorage() async {
    try {
      final file = await _getLocalFile();
      String rawJson = jsonEncode(_moviesList); // Chuyển List -> Chuỗi JSON mã hóa
      await file.writeAsString(rawJson); // Ghi file bất đồng bộ

      // Cập nhật bộ lọc tìm kiếm trên UI ngay khi dữ liệu gốc thay đổi
      _filterMovies(_searchQuery);
    } catch (e) {
      _showSnackBar('Auto-save failed: $e', Colors.red);
    }
  }

  // ===========================================================================
  // CÁC THAO TÁC NGHIỆP VỤ CRUD DATABASE (Lab 9.3 - Step 2 & 3)
  // ===========================================================================

  // Chức năng Tìm kiếm / Lọc nội dung phim (Search Filter)
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

  // Thao tác THÊM phim mới (Create - Tự sinh ID tăng dần)
  void _addMovie(String title, String genre, String year) {
    setState(() {
      // Tính toán tạo mã ID duy nhất dựa trên thời gian hoặc mã số cao nhất
      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString().substring(7);

      _moviesList.add({
        "id": uniqueId,
        "title": title,
        "genre": genre,
        "year": year,
      });
    });
    _autoSaveToStorage(); // Tự động ghi lại vào ổ cứng thiết bị
    _showSnackBar('Added "$title" to database.', Colors.blue);
  }

  // Thao tác SỬA/CẬP NHẬT thông tin phim (Update)
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

  // Thao tác XÓA phim ra khỏi cơ sở dữ liệu (Delete)
  void _deleteMovie(String id, String title) {
    setState(() {
      _moviesList.removeWhere((m) => m['id'] == id);
    });
    _autoSaveToStorage();
    _showSnackBar('Removed "$title" from system.', Colors.redAccent);
  }

  // ===========================================================================
  // GIAO DIỆN HIỂN THỊ (USER INTERACTION LAYOUT)
  // ===========================================================================

  // Hàm phụ trợ tạo nhanh SnackBar hiển thị phản hồi UX thông minh (Bonus Feature)
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Hộp thoại biểu mẫu dùng chung cho cả tác vụ Thêm và Sửa thông tin phim
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

  // Hộp thoại xác nhận trước khi thực thi xóa phần tử nhằm nâng cao chất lượng trải nghiệm (Bonus Feature)
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
          // Nút hành động cho phép ép buộc nạp đè dữ liệu gốc từ Asset để kiểm thử (Lab 9.1)
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
            // Khối thanh tìm kiếm thời gian thực (Search Engine Bar - Lab 9.3)
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

            // Hiển thị số lượng bản ghi thực tế đang hiện hữu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Items: ${_filteredMoviesList.length}', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                if (_searchQuery.isNotEmpty)
                  const Text('Filtering active', style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 10),

            // Khối kết quả danh sách dạng cuộn mượt mà (ListView Layer)
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
                      // Đọc 2 trường thông tin thiết yếu trở lên (Title, Genre, Year) (Lab 9.1 Yêu cầu)
                      title: Text(movie['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('Genre: ${movie['genre']} • Year: ${movie['year']}', style: TextStyle(color: Colors.grey[600])),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Nút sửa (Update)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 22),
                            onPressed: () => _showMovieFormDialog(existingMovie: movie),
                          ),
                          // Nút xóa (Delete)
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
      // Nút hành động nổi kích hoạt Form Thêm mới bộ phim (Create - Lab 9.2 & 9.3)
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