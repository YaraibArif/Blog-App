import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../widgets/stat_item.dart';
import '../widgets/post_card.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

String formatNumber(int number) {
  return NumberFormat.compact().format(number);
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<dynamic> posts = [];
  bool isLoading = true;
  Map<int, int> commentCounts = {};

  @override
  void initState() {
    super.initState();
    fetchPostsAndComments();
  }

  Future<void> fetchPostsAndComments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.getRequest("/posts");
      final fetchedPosts = data["posts"] as List<dynamic>;
      Map<int, int> counts = {};
      int totalLikes = 0;
      int totalViews = 0;

      //  Single loop for stats
      for (var post in fetchedPosts) {
        final postId = post["id"];

        // Comments fetch
        final commentsData = await ApiService.getRequest("/posts/$postId/comments");
        final commentsList = commentsData["comments"] as List<dynamic>;
        counts[postId] = commentsList.length;

        // Likes and views safely
        final reactions = post["reactions"] is int ? post["reactions"] as int : 0;
        final views = post.containsKey("views") && post["views"] is int
            ? post["views"] as int
            : (50 + reactions);

        totalLikes += reactions;
        totalViews += views;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.currentUser != null) {
        // Update user dynamically
        final updatedUser = authProvider.currentUser!.copyWith(
          posts: fetchedPosts.length,
          likes: totalLikes,
          views: totalViews,
        );
        authProvider.setUser(updatedUser);
      }

      setState(() {
        posts = fetchedPosts;
        commentCounts = counts;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching posts/comments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen: true, so UI rebuilds on Provider update
    final authProvider = Provider.of<AuthProvider>(context);
    final User user = authProvider.currentUser ?? User.demo();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.white),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: user.profilePic.contains("assets/")
                  ? AssetImage(user.profilePic) as ImageProvider
                  : NetworkImage(user.profilePic),
            ),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "@${user.username}",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatItem(value: user.posts.toString(), label: "Posts"),
                StatItem(value: formatNumber(user.likes), label: "Likes"),
                StatItem(value: formatNumber(user.views), label: "Views"),
              ],
            ),
            const SizedBox(height: 20),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final postId = post["id"];
                final commentsCount = commentCounts[postId] ?? 0;

                return PostCard(
                  user: user.name,
                  time: "Just now",
                  content: post["body"] ?? "",
                  likes: post["reactions"] is int ? post["reactions"] : 0,
                  comments: commentsCount,
                  shares: 3,
                  avatarUrl: user.profilePic,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
