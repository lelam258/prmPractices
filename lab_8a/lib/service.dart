import 'dart:async';
import 'dart:convert';
import 'post.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> decodedList = json.decode(response.statusCode == 200 ? response.body : '');
        return decodedList.map((jsonMap) => Post.fromJson(jsonMap)).toList();
      } else {
        throw Exception('Server returned code ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet connection.');
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Post> createPost(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/posts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during POST request: $e');
    }
  }
}