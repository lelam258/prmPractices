import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts?_limit=0';
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải dữ liệu từ máy chủ');
    }
  }

  Future<Post> createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': title, 'body': body, 'userId': 1}),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gửi bài viết mới thất bại!');
    }
  }
}