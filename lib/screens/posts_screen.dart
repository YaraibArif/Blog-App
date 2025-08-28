import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import '../widgets/loader.dart';
import '../widgets/error_view.dart';
import '../widgets/post_tile.dart';
import 'add_post_screen.dart';
import 'search_screen.dart';
import 'user_profile_screen.dart';

String formatNumber(int number) {
  return NumberFormat.compact().format(number);
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    postsProvider.fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        postsProvider.fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Daily Stories",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPostScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white),
            onPressed: () {
              postsProvider.shufflePosts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),

        ],
      ),

      body: Builder(
        builder: (context) {
          if (postsProvider.isLoading && postsProvider.posts.isEmpty) {
            return const Loader(size: 40, color: Colors.white);
          }

          if (postsProvider.posts.isEmpty) {
            return ErrorView(
              message: "No posts found",
              onRetry: () => postsProvider.fetchPosts(),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: postsProvider.posts.length +
                (postsProvider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < postsProvider.posts.length) {
                final post = postsProvider.posts[index];
                return PostTile(
                  post: post,
                  onDelete: () {
                    postsProvider.deletePostById(post['id']);
                  },
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Loader(size: 25, color: Colors.orange),
                );
              }
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, "/posts");
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, "/quotes");
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_quote), label: "Quotes"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
