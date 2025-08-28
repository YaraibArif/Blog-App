import 'dart:math';
import 'package:flutter/material.dart';
import '../services/posts_service.dart';
import '../models/user.dart';

class PostsProvider with ChangeNotifier {
  final PostService _postService = PostService();

  final List<Map<String, dynamic>> _serverPosts = [];
  final List<Map<String, dynamic>> _localPosts = [];
  final List<Map<String, dynamic>> _searchResults = [];

  //Shuffle Posts
  List<Map<String, dynamic>> _shuffledPosts = [];
  bool isShuffled = false;

  bool isLoading = false;
  bool hasMore = true;
  int limit = 10;
  int skip = 0;

  User? currentUser;

  // Getter for Posts
  List<Map<String, dynamic>> get posts {
    if (isShuffled) return _shuffledPosts;
    return [..._localPosts, ..._serverPosts];
  }
  List<Map<String, dynamic>> get searchResults => _searchResults;

  // Init Search (for SearchScreen)
  Future<void> initSearch() async {
    try {
      if (_serverPosts.isEmpty) {
        await fetchPosts(); // agar server posts empty hain to fetch karo
      }

      _searchResults
        ..clear()
        ..addAll([..._localPosts, ..._serverPosts]); // dono show karo

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error in initSearch: $e");
    }
  }

  // Fetch Posts from api
  Future<void> fetchPosts() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final data = await _postService.fetchPosts(limit: limit, skip: skip);
      final newPosts = List<Map<String, dynamic>>.from(data['posts'] ?? []);

      for (var post in newPosts) {
        post['id'] ??= Random().nextInt(100000);
        post['user'] = User.demo(); // API se user nahi aata, dummy use karna
      }

      if (newPosts.isNotEmpty) {
        _serverPosts.addAll(newPosts);
        skip += limit;
      }

      if (newPosts.length < limit) hasMore = false;
    } catch (e) {
      debugPrint("❌ Error loading posts: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Fetch Current User
  Future<void> fetchCurrentUser() async {
    try {
      final data = await _postService.getCurrentUser();
      currentUser = User.fromJson(data);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching current user: $e");
      currentUser = User.demo();
    }
  }

  Future<void> deletePostById(int id) async {
    try {
      // Check local posts
      final localIndex = _localPosts.indexWhere((p) => p['id'] == id);
      if (localIndex != -1) {
        _localPosts.removeAt(localIndex);

        // agar shuffle mode on hai to shuffledPosts bhi update karo
        if (isShuffled) {
          _shuffledPosts.removeWhere((p) => p['id'] == id);
        }

        notifyListeners();
        return;
      }

      // Check server posts
      final serverIndex = _serverPosts.indexWhere((p) => p['id'] == id);
      if (serverIndex != -1) {
        await _postService.deletePost(id);
        _serverPosts.removeAt(serverIndex);

        // agar shuffle mode on hai to shuffledPosts bhi update karo
        if (isShuffled) {
          _shuffledPosts.removeWhere((p) => p['id'] == id);
        }

        notifyListeners();
        return;
      }

    } catch (e) {
      debugPrint("❌ Error deleting post: $e");
    }
  }

  //Refresh Posts
  Future<void> refreshPosts() async {
    _serverPosts.clear();
    skip = 0;
    hasMore = true;
    await fetchPosts();
  }

  //Add Post (Local me)
  Future<void> addPost(Map<String, dynamic> newPost) async {
    try {
      final createdPost = await _postService.addPost(newPost);

      createdPost['id'] ??= Random().nextInt(100000);
      createdPost['user'] = currentUser ?? User.demo();

      _localPosts.insert(0, createdPost);

      if (isShuffled) {
        _shuffledPosts.insert(0, createdPost);
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error adding post: $e");

      final fallbackPost = {
        "id": Random().nextInt(100000),
        "title": newPost["title"],
        "body": newPost["body"],
        "tags": newPost["tags"],
        "views": 0,
        "user": currentUser ?? User.demo(),
      };

      _localPosts.insert(0, fallbackPost);
      notifyListeners();
    }
  }

  // Search by Query (Local + Server)
  Future<void> searchPosts(String query) async {
    try {
      _searchResults.clear();

      if (query.isEmpty) {
        _searchResults.addAll([..._localPosts, ..._serverPosts]);
        notifyListeners();
        return;
      }

      // Local filter
      final localMatches = _localPosts.where((post) {
        final title = (post['title'] ?? "").toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();

      // Server filter (API search)
      final data = await _postService.searchPosts(query);
      final serverMatches = List<Map<String, dynamic>>.from(data['posts'] ?? []);

      _searchResults..addAll(localMatches)..addAll(serverMatches);

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error searching posts: $e");
    }
  }

  //Search by Category (Local + Server)
  Future<void> searchByCategory(String category) async {
    try {
      _searchResults.clear();

      if (category == "All Stories") {
        _searchResults.addAll([..._localPosts, ..._serverPosts]);
        notifyListeners();
        return;
      }

      // Local filter
      final localMatches = _localPosts.where((post) {
        final tags = (post['tags'] as List?)?.map((e) => e.toString().toLowerCase()).toList() ?? [];
        return tags.contains(category.toLowerCase());
      }).toList();

      // Server filter (API search by tag)
      final data = await _postService.searchPosts(category);
      final serverMatches = List<Map<String, dynamic>>.from(data['posts'] ?? []);

      _searchResults..addAll(localMatches)..addAll(serverMatches);

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error filtering by category: $e");
    }
  }

  void shufflePosts() {
    _shuffledPosts = [..._localPosts, ..._serverPosts]..shuffle(Random());
    isShuffled = true;
    notifyListeners();
  }

  void resetShuffle() {
    isShuffled = false;
    notifyListeners();
  }

}
