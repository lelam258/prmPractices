import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
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

  @override
  void initState() {
    super.initState();
    // Khởi tạo luồng nạp dữ liệu ngay khi màn hình vừa dựng xong
    _initFetch();
  }

  void _initFetch() {
    setState(() {
      _postsFuture = _apiService.fetchPosts();
    });
  }

  // Hàm hỗ trợ kích hoạt tính năng kéo để làm mới danh sách (Pull to Refresh) [cite: 477]
  Future<void> _handleRefresh() async {
    _initFetch();
    await _postsFuture.catchError((_) => <Post>[]); // Tránh crash luồng Refresh khi có lỗi xảy ra
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Network Posts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Gán hành động vuốt để làm mới [cite: 477]
        child: FutureBuilder<List<Post>>(
          future: _postsFuture, // Khống chế luồng xử lý luân chuyển dữ liệu
          builder: (context, snapshot) {
            // TRẠNG THÁI 1: Hệ thống đang chờ dữ liệu đổ về từ Internet (Loading) [cite: 426, 505]
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(), // Vòng xoay vô tận
                    SizedBox(height: 16),
                    Text('Fetching data from API, please wait...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            // TRẠNG THÁI 2: Quá trình kết nối xảy ra lỗi kỹ thuật (Error Handling) [cite: 426, 436]
            else if (snapshot.hasError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // Đảm bảo luôn cuộn được để kích hoạt kéo làm mới
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Something went wrong!', // Thông điệp thân thiện [cite: 452]
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 24),
                        // Nút Retry hỗ trợ người dùng tải lại nhanh dữ liệu [cite: 453, 481]
                        ElevatedButton.icon(
                          onPressed: _initFetch,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }

            // TRẠNG THÁI 3: Kết nối thành công và có dữ liệu trả về (HasData) [cite: 507]
            else if (snapshot.hasData) {
              final posts = snapshot.data!;
              if (posts.isEmpty) {
                return const Center(child: Text('No posts available.'));
              }

              // Sử dụng ListView.builder để tối ưu hóa bộ nhớ khi vẽ danh sách dài [cite: 448, 470]
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      // Hiển thị chỉ số định danh (ID) bài viết [cite: 449]
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.withOpacity(0.1),
                        foregroundColor: Colors.indigo,
                        child: Text('${post.id}'),
                      ),
                      // Hiển thị tiêu đề bài viết từ đối tượng Model [cite: 449]
                      title: Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], height: 1.3),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.black38),
                      onTap: () {
                        // Gọi màn hình xem chi tiết bài viết (Bonus Feature) [cite: 478]
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }

            // Trạng thái dự phòng mặc định (Fallback UI)
            return const Center(child: Text('No data found.'));
          },
        ),
      ),
      // Nút hành động nổi mở Form tạo mới bài viết qua phương thức POST (Step 7) [cite: 479, 526]
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(apiService: _apiService),
            ),
          ).then((wasCreated) {
            // Nếu gửi POST thành công, tự động làm mới danh sách để cập nhật giao diện
            if (wasCreated == true) _initFetch();
          });
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Details #${post.id}')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 8),
            Text('Author User ID: ${post.userId}', style: const TextStyle(color: Colors.black38, fontStyle: FontStyle.italic)),
            const Divider(height: 30),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
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

  void _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Gọi dịch vụ mạng gửi gói tin POST đi [cite: 527]
      final result = await widget.apiService.createPost(
        _titleController.text.trim(),
        _bodyController.text.trim(),
      );

      if (!mounted) return;
      // Báo cáo kết quả thành công rực rỡ cho người dùng xem [cite: 456, 528]
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post created successfully! (New ID: ${result.id})'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Trả về tín hiệu true báo hiệu biểu mẫu hoàn thành tốt
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
      appBar: AppBar(title: const Text('Create New Post')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Content Body', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter content details' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: _isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Submit Post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}