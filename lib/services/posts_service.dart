import 'api_service.dart';

class PostService {
  // Fetch posts with pagination
  Future<Map<String, dynamic>> fetchPosts({int limit = 10, int skip = 0}) async {
    return await ApiService.getRequest("/posts?limit=$limit&skip=$skip");
  }

  //Fetch comments (limit=0 → get all comments)
  Future<Map<String, dynamic>> fetchComments({int limit = 0, int skip = 0}) async {
    return await ApiService.getRequest("/comments?limit=$limit&skip=$skip");
  }

  //Delete post
  Future<void> deletePost(int id) async {
    await ApiService.deleteRequest("/posts/$id");
  }

  //Search posts (query ya category ke liye)
  Future<Map<String, dynamic>> searchPosts(String term) async {
    return await ApiService.getRequest("/posts/search?q=$term");
  }

  //Add new post
  Future<Map<String, dynamic>> addPost(Map<String, dynamic> newPost) async {
    return await ApiService.postRequest("/posts/add", newPost);
  }

  //Update post
  Future<Map<String, dynamic>> updatePost(int id, Map<String, dynamic> updatedPost) async {
    return await ApiService.putRequest("/posts/$id", updatedPost);
  }

  //Get current user
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await ApiService.getRequest("/users/1");
  }
  // Get user by username
  Future<Map<String, dynamic>> getUserByUsername(String username) async {
    return await ApiService.getRequest("/users/username/$username");
  }

}
