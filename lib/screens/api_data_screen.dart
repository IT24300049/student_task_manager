import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class ApiDataScreen extends StatefulWidget {
  const ApiDataScreen({super.key});

  @override
  State<ApiDataScreen> createState() => _ApiDataScreenState();
}

class _ApiDataScreenState extends State<ApiDataScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;
  String? _favoritePostTitle;

  @override
  void initState() {
    super.initState();
    _postsFuture = _apiService.fetchPosts();
    _loadFavoritePost();
  }

  Future<void> _loadFavoritePost() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoritePostTitle = prefs.getString('favorite_post_title');
    });
  }

  Future<void> _toggleFavorite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoritePostTitle == title) {
      await prefs.remove('favorite_post_title');
      setState(() {
        _favoritePostTitle = null;
      });
    } else {
      await prefs.setString('favorite_post_title', title);
      setState(() {
        _favoritePostTitle = title;
      });
    }
  }

  void _retry() {
    setState(() {
      _postsFuture = _apiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Data & Challenge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: _retry,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_favoritePostTitle != null)
            Container(
              width: double.infinity,
              color: Colors.amber.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Favorite: $_favoritePostTitle',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _retry,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final posts = snapshot.data ?? [];
                if (posts.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final isFav = _favoritePostTitle == post.title;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${post.id}'),
                        ),
                        title: Text(
                          post.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.star : Icons.star_border,
                            color: isFav ? Colors.amber : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(post.title),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}