import 'package:flutter/material.dart';
import 'post.dart';
import 'service.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;
  List<Post> _localPostsList = [];
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadDataFromNetwork();
  }

  void _loadDataFromNetwork() {
    setState(() {
      _postsFuture = _apiService.fetchPosts().then((data) {
        _localPostsList = data;
        _isDataInitialized = true;
        return data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Powered List', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDataFromNetwork,
          )
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !_isDataInitialized) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.indigo),
                  SizedBox(height: 12),
                  Text('Loading posts from API...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          else if (snapshot.hasError && !_isDataInitialized) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          else {
            if (_localPostsList.isEmpty) {
              return const Center(child: Text('Danh sách trống rỗng. Hãy thêm bài viết mới!'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _localPostsList.length,
              itemBuilder: (context, index) {
                final post = _localPostsList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.withOpacity(0.1),
                      foregroundColor: Colors.indigo,
                      child: Text('${post.id}'),
                    ),
                    title: Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(apiService: _apiService),
            ),
          ).then((newPostObj) {
            if (newPostObj != null && newPostObj is Post) {
              setState(() {
                int newId = _localPostsList.isNotEmpty ? _localPostsList.first.id + 1 : 1;
                Post finalizedPost = Post(
                  id: newId,
                  title: newPostObj.title,
                  body: newPostObj.body,
                );
                _localPostsList.insert(0, finalizedPost);
              });
            }
          });
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreatePostScreen extends StatefulWidget {
  final ApiService apiService;

  const CreatePostScreen({super.key, required this.apiService});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      Post postCreatedFromServer = await widget.apiService.createPost(
        _titleController.text.trim(),
        _bodyController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context, postCreatedFromServer);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập tiêu đề bài viết' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Body Content',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Vui lòng nhập nội dung bài viết' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Submit Post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}