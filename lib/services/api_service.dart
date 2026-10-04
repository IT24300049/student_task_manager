import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  Future<List<Post>> fetchPosts() async {
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Unable to load data');
    }
  }
}